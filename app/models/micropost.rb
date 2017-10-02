class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.maximum_length}
  validate :picture_size

  default_scope ->{order(created_at: :desc)}

  scope :find_post_by_userid, ->(id){where user_id: id}

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    errors.add(:picture, t("less_then_5MB")) if picture.size > Settings.picture.maximum_size.megabytes
  end
end
