# == Schema Information
#
# Table name: connect_profiles
#
#  id                                 :integer          not null, primary key
#  address_kana_city                  :string
#  address_kana_line1                 :string
#  address_kana_postal_code           :string
#  address_kana_state                 :string
#  address_kana_town                  :string
#  address_kanji_city                 :string
#  address_kanji_line1                :string
#  address_kanji_postal_code          :string
#  address_kanji_state                :string
#  address_kanji_town                 :string
#  dob_day                            :string
#  dob_month                          :string
#  dob_year                           :string
#  gender                             :string
#  first_name_kana                    :string
#  first_name_kanji                   :string
#  last_name_kana                     :string
#  last_name_kanji                    :string
#  phone_number                       :string
#  type                               :string
#  tos_acceptance_date                :string
#  tos_acceptance_ip                  :string
#  verification                       :text
#  business_name                      :string
#  business_name_kana                 :string
#  business_name_kanji                :string
#  business_tax_id                    :string
#  personal_address_kana_city         :string
#  personal_address_kana_line1        :string
#  personal_address_kana_postal_code  :string
#  personal_address_kana_state        :string
#  personal_address_kana_town         :string
#  personal_address_kanji_city        :string
#  personal_address_kanji_line1       :string
#  personal_address_kanji_postal_code :string
#  personal_address_kanji_state       :string
#  personal_address_kanji_town        :string
#  stripe_account_id                  :string
#  stripe_secret_key                  :string
#  stripe_publishable_key             :string
#  user_id                            :integer
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  status                             :string
#  review                             :string
#  review_message                     :text
#

# require 'error_utility'
# require 'megaphone'

class ConnectProfile < ApplicationRecord
  self.inheritance_column = :_type_disabled
  extend Enumerize
  enumerize :gender, in: [:female, :male]
  enumerize :status, in: [:unverified, :pending, :verified, :reject], default: :unverified
  enumerize :review, in: [:unverified, :pending, :verified, :reject], default: :unverified
  serialize :verification, JSON

  KATAKANA_REGEX = /\A[ァ-ンー－0-9０-９-]+\z/
  PHONE_NUMBER_REGEX = /\A\d{10}\z|\A\d{11}\z/

  validates :first_name_kanji, presence: true
  validates :last_name_kanji, presence: true
  validates :address_kanji_state, presence: true
  validates :address_kanji_city, presence: true
  validates :address_kanji_town, presence: true
  validates :address_kanji_line1, presence: true
  validates :address_kanji_postal_code, presence: true, format: { with: /\A\d{7}\z/, message: 'は半角数字7桁のみ有効です' }

  validates :address_kanji_postal_code, format: { with: /\A\d{7}\z/, message: 'は半角数字7桁のみ有効です' }

  validates :first_name_kana,    format: { with: KATAKANA_REGEX, message: 'は全角カタカナのみ有効です' }, unless: 'self.company?'
  validates :last_name_kana,     format: { with: KATAKANA_REGEX, message: 'は全角カタカナのみ有効です' }, unless: 'self.company?'
  validates :address_kana_state, format: { with: KATAKANA_REGEX, message: 'は全角カタカナのみ有効です' }, unless: 'self.company?'
  validates :address_kana_city,  format: { with: KATAKANA_REGEX, message: 'は全角カタカナと数字及びハイフンのみ有効です' }, unless: 'self.company?'
  validates :address_kana_town,  format: { with: KATAKANA_REGEX, message: 'は全角カタカナと数字及びハイフンのみ有効です' }, unless: 'self.company?'
  validates :address_kana_line1, format: { with: KATAKANA_REGEX, message: 'は全角カタカナと数字及びハイフンのみ有効です' }, unless: 'self.company?'

  validates :phone_number, format: { with: PHONE_NUMBER_REGEX, message: 'は半角数字11桁または10桁のみ有効です' }, unless: 'self.company?'

  ATTRIBUTES = [
    :id,
    :address_kana_city,
    :address_kana_line1,
    :address_kana_postal_code,
    :address_kana_state,
    :address_kana_town,
    :address_kanji_city,
    :address_kanji_line1,
    :address_kanji_postal_code,
    :address_kanji_state,
    :address_kanji_town,
    :dob_day,
    :dob_month,
    :dob_year,
    :gender,
    :type,
    :first_name_kana,
    :first_name_kanji,
    :last_name_kana,
    :last_name_kanji,
    :phone_number,
    :business_name,
    :business_name_kana,
    :business_name_kanji,
    :business_tax_id,
  ]

  belongs_to :user

  def company?
    self.type == 'company'
  end

  def update_with_event(event)
    self.status = event['data']['object']['legal_entity']['verification']['status']
    self.verification = event['data']['object']['legal_entity']['verification']
    self.save(validate: false)
  end

  def update_stripe_managed_account!
    if self.stripe_account_id.blank?
      account = self.create_stripe_managed_account!
      return account
    end

    begin
      account = Stripe::Account.retrieve(self.stripe_account_id)
      account.legal_entity.address_kanji.postal_code = self.address_kanji_postal_code
      account.legal_entity.address_kanji.state       = self.address_kanji_state
      account.legal_entity.address_kanji.city        = self.address_kanji_city
      account.legal_entity.address_kanji.town        = self.address_kanji_town
      account.legal_entity.address_kanji.line1       = self.address_kanji_line1
      account.legal_entity.address_kana.postal_code  = self.address_kanji_postal_code
      account.legal_entity.address_kana.state        = self.address_kana_state
      account.legal_entity.address_kana.city         = self.address_kana_city
      account.legal_entity.address_kana.town         = self.address_kana_town
      account.legal_entity.address_kana.line1        = self.address_kana_line1
      account.legal_entity.dob.day                   = self.dob_day
      account.legal_entity.dob.month                 = self.dob_month
      account.legal_entity.dob.year                  = self.dob_year
      account.legal_entity.gender                    = self.gender
      account.legal_entity.first_name_kana           = self.first_name_kana
      account.legal_entity.first_name_kanji          = self.first_name_kanji
      account.legal_entity.last_name_kana            = self.last_name_kana
      account.legal_entity.last_name_kanji           = self.last_name_kanji
      account.legal_entity.phone_number              = self.phone_number
      account.legal_entity.type                      = self.type
      account.payout_schedule.interval               = 'manual'
      account.save
    rescue => e
      # ErrorUtility.log_and_notify(e)
      p e
    end

    self.update(
      status: account.legal_entity.verification.status,
      verification: account.verification.to_json
    )

    return account
  end

  after_create :create_stripe_managed_account!
  # before_validation do
  #   self.address_kana_line1 = self.address_kana_line1.gsub(/[[:blank:]]+/, "") unless self.company?
  # end

  def create_stripe_managed_account!
    p 'create_stripe_managed_account called'

    begin
      account = Stripe::Account.create({ type: 'custom' })
      self.update(
        stripe_account_id: account.id,
        stripe_secret_key: account.keys.secret,
        stripe_publishable_key: account.keys.publishable
      )

      account.tos_acceptance.date = Time.now.to_i
      account.tos_acceptance.ip = request.remote_ip
      acct.save
      account.tos_acceptance.date = Time.zone.now.to_i
      remote_ip = Thread.current[:request].env["HTTP_X_FORWARDED_FOR"] || Thread.current[:request].remote_ip
      account.tos_acceptance.ip = Thread.current[:request].remote_ip
      account.save
      return account
    rescue => e
      p e
      # ErrorUtility.log_and_notify(e)
    end
  end
end
