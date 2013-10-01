class CommentsAddWebsiteCol < ActiveRecord::Migration
  def up
  	add_column :comments, :website, :string
  end

  def down
  	remove_column :comments, :website
  end
end
