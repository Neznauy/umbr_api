class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings

  def new_avg_rating(new_rating)
    (avg_rating*rating_quantity+new_rating)/(rating_quantity+1)
  end
end
