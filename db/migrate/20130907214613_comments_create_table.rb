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

  	Comment.create(commenter: "Elliot Dickison", email: "ejdickison@gmail.com", body: "Herro there! What a boring blog you have.", post: Post.find(1));
  end

  def down
  	drop_table :comments
  end
end
