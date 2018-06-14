class AddDenormalizationColumnsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :avg_rating, :float, default: 0
    add_column :posts, :rating_quantity, :integer, default: 0
  end
end
