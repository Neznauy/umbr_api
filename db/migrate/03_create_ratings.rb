class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :rating_value, null: false 
      t.belongs_to :post, foreign_key: true
      t.timestamps
    end
  end
end
