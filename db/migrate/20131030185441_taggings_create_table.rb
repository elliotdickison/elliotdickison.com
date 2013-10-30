class TaggingsCreateTable < ActiveRecord::Migration
  def up
  	create_table :taggings do |t|
      t.references :tag
      t.references :taggable, polymorphic: true

      t.timestamps
    end
  end

  def down
  	drop_table :taggings
  end
end
