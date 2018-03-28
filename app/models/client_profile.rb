class ClientProfile < ApplicationRecord
  belongs_to :user

  ATTRIBUTES = [
    :about,
    { job_type: [] },
    :url,
    :min_reward
  ]

  ATTRIBUTES = [
    :about,
    :url,
  ]

  def add_card!(token)
    if self.stripe_customer_id.blank?
      customer = create_customer!
      customer.source = token
      customer.save
    else
      stripe_customer_id = self.stripe_customer_id
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.source = token
      customer.save
    end
  end

  private
    def create_customer!
      customer = Stripe::Customer.create(
        email: self.user.email,
        metadata: { user_id: self.user.id }
      )
      self.update(stripe_customer_id: customer.id)
      return customer
    end
end
