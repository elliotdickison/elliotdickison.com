class TaggingsAddIndex < ActiveRecord::Migration
  def up
  	add_index :taggings, [:tag_id, :taggable_id, :taggable_type], unique: true
  end

  def down
  	remove_index :taggings, [:tag_id, :taggable_id, :taggable_type]
  end
end
