class PostSlug < ActiveRecord::Migration
  def up
  	rename_column :posts, :reference_id, :slug
  	add_index :posts, :slug
  end

  def down
  	remove_index :posts, :slug
  	rename_column :posts, :slug, :reference_id
  end
end
