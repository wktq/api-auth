class Proposal < ApplicationRecord
  extend Enumerize
  enumerize :status, in: [:proposed, :accepted, :paid, :completed, :inspected, :done], default: :proposed

  belongs_to :user
  belongs_to :task
  has_one :charge

  PLATFORM_FEE = 0.1
  MEMBER_REWARD_PERCENTAGE = 1 - PLATFORM_FEE
  REAUTH_CHARGE_SPAN = 6.days

  def member_reward
    (self.reward * self.unit * MEMBER_REWARD_PERCENTAGE).to_i
  end

  def reauth_charge!
    refund = Stripe::Refund.create(charge: self.charge.charge_id) # 決済取り消し
    stripe_charge = self.create_stripe_charge # 再度与信を確保

    if stripe_charge
      self.charge.update(
        charge_id: stripe_charge.id,
        captured: false,
        transfer_id: nil,
        payment_id: nil,
        balance_transaction_id: nil,
        status: stripe_charge.status, # succeeded, pending, failed
        metadata: stripe_charge.to_json,
        available_on: nil
      )
      Megaphone.notifier.post(text: "オファーID: #{self.id} の与信を再確保しました")
      self.set_charge_job
    else
      Megaphone.notifier.post(text: "オファーID: #{self.id} の与信の再確保に失敗しました")
    end
  rescue => e
    ErrorUtility.log_and_notify(e)
    ErrorUtility.notify_error(self)
    Megaphone.notifier.post(text: "オファーID: #{self.id} の与信の再確保に失敗しました")
  end

  def set_charge_job
    ReauthChargeJob.set(
      wait_until: (Date.today + REAUTH_CHARGE_SPAN).beginning_of_day
    ).perform_later(self.id)
  end

  def paid!(stripe_charge)
    charge = self.build_charge(charge_id: stripe_charge.id, metadata: stripe_charge.to_json)
    if charge.save
      self.update(status: :paid, paid_at: Time.zone.now)
    end
    return charge.errors.blank?
  end

  def create_stripe_charge
    charge = Stripe::Charge.create({
      amount: self.reward * self.unit,
      currency: "jpy",
      customer: self.task.user.client_profile.stripe_customer_id,
      capture: false, # 基本的に後でcaptureする
      description: self.task.title,
      statement_descriptor: 'Crowdbase', # クレジットカードの決済表示（22文字まで）
      metadata: {
        '提案ID': self.id,
        'クライアントID': self.user_id,
        'タスクID': self.task_id,
        '報酬金額': self.reward * self.unit
      },
      destination: {
        amount: self.member_reward,
        account: self.user.connect_profile.stripe_account_id,
      }
    })

    self.update(status: :paid, paid_at: Time.zone.now)
    return charge
  end

  def inspected!
    self.update(status: :inspected, inspected_at: Time.zone.now)

    Notification.create(
      title: 'オファーの検収が完了しました',
      content: self.task.title + "の検収が完了し、報酬が支払われました。",
      group: 'task_inspect',
      avatar_url: self.user.avatar,
      target_user_id: self.task.user_id,
      link_url: '/my/rooms',
      user_id: self.user.id
    )
    Notification.create(
      title: 'オファーの検収が完了しました',
      content: self.task.title + "の検収が完了し、報酬が支払われました。",
      group: 'task_inspect',
      avatar_url: self.task.user.avatar,
      target_user_id: self.user_id,
      link_url: '/my/rooms',
      user_id: self.task.user.id
    )
    # self.set_reward_not_payouted_job
    # self.user.update_rating!
    # self.target_user.update_rating!
    self.capture_charge!
  end

  def capture_charge!
    charge = Stripe::Charge.retrieve(self.charge.charge_id)
    charge.capture # capture charge

    if charge && charge.paid && charge.captured
      transfer = Stripe::Transfer.retrieve(charge.transfer)
      transaction = Stripe::BalanceTransaction.list(
        { type: 'payment', limit: 1, source: transfer.destination_payment },
        stripe_account: self.target_user.connect_profile.stripe_account_id
      ).data.first

      self.charge.update(
        captured: true,
        transfer_id: transfer ? transfer.id : nil,
        payment_id: transfer ? transfer.destination_payment : nil,
        balance_transaction_id: transaction ? transaction.id : nil,
        status: charge.status, # succeeded, pending, failed
        metadata: charge.to_json,
        available_on: transaction ? Time.at(transaction.available_on) : nil
      )
      p "Proposal ID: #{self.id} をキャプチャしました"
    else
      p "Proposal ID: #{self.id} のキャプチャに失敗しました"
    end
  rescue => e
    p "Proposal ID: #{self.id} のキャプチャに失敗しました"
    p e
  end
end
