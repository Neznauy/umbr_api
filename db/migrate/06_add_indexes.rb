class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :login, unique: true

    add_index :posts, :avg_rating
    add_index :posts, :author_ip
  end
end
