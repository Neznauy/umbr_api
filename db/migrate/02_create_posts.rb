class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :title, null: false
      t.text :content, null: false
      t.text :author_ip, null: false     
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
