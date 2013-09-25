class PostsCreateTable < ActiveRecord::Migration
  def up
  	create_table :posts do |t|
  	  t.string :title
  	  t.text :body
  	  t.timestamps
  	end

  	Post.create(title: "Building a Ski Press", body: "Note that this frame design is only meant to withstand operating pressures of 40-50psi.  If higher pressures are desired you can easily substitute with stronger materials such as thicker tubing or even I-beams.  Also the dimensions provided in this howto are guidelines.  Your press frame should be designed specifically for the bladder you choose, the mold dimensions, the desired operating pressures, etc.  It is recommended that you consult a certified engineer when designing and building ANY ski press or ski building equipment.");
  end

  def down
  	drop_table :posts
  end
end
