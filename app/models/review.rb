class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true

  validate :at_least_review_or_rating

  def at_least_review_or_rating
    if rating == nil && rating == nil
      errors.add(:at_least_review_or_rating, "Please leave at least review or rating")
    end
  end
end
