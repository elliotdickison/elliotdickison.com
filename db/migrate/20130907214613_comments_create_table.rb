class CommentsCreateTable < ActiveRecord::Migration
  def up
  	create_table :comments do |t|
  	  t.string :commenter
  	  t.string :email
  	  t.text :body

  	  t.references :post

  	  t.timestamps
  	end

  	add_index :comments, :post_id
  end

  def down
  	drop_table :comments
  end
end
