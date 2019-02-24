class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true

  validate :need_rating

  def need_rating
    if rating == nil
      errors.add(:Please_rating, "")
    end
  end
end
