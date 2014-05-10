class CommentsAreGonzo < ActiveRecord::Migration
  def up
  	drop_table :comments
  end

  def down
  	# Burn those bridges!
  end
end
