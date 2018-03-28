class Task < ApplicationRecord
  include JobTypeEnumerations

  enumerize :status, in: [
    :draft,
    :available,
    :unavailable
  ], scope: true, default: :draft


  enumerize :job_type, in: JOB_TYPES, predicates: true, i18n_scope: 'enumerize.job_type'

  # mount_uploader :image, ProjectImageUploader

  belongs_to :user
  has_one :favorite, dependent: :destroy
  has_many :proposals, dependent: :destroy

  def expired?
    self.deadline < Time.zone.now
  end

  scope :available, -> { where(status: :available).where('deadline > ?', Time.zone.now) }

  private
    def self.matching_job_types_query
    end

end
