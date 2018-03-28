class MemberProfile < ApplicationRecord
  include JobTypeEnumerations

  # acts_as_taggable_on :skills

  JOB_TYPES = [
    :about,
    :job_type,
    :url
  ]

  ATTRIBUTES = [
    :about,
    :url,
    :min_reward,
    :id
  ]

  enumerize :job_type, in: JOB_TYPES, predicates: true, i18n_scope: 'job_type'
  belongs_to :user
  validates :user_id, presence: true
  serialize :job_type, Array

end
