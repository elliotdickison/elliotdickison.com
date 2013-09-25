class PostsAddReferenceId < ActiveRecord::Migration
  def up
  	add_column :posts, :reference_id, :string

  	Post.all.each do |p|
  		p.reference_id = p.title
  		p.save
  	end
  end

  def down
  	remove_column :posts, :reference_id
  end
end
