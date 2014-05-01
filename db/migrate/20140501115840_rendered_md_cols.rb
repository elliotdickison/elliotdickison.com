class RenderedMdCols < ActiveRecord::Migration
  def up
  	add_column :posts, :rendered_body, :text
  	add_column :comments, :rendered_body, :text

  	Post.all.each do |post|
  		post.save
  	end

  	Comment.all.each do |comment|
  		comment.save
  	end
  end

  def down
  	remove_column :posts, :rendered_body
  	remove_column :comments, :rendered_body
  end
end
