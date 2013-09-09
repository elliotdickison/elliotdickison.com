class CreateUserFilesTable < ActiveRecord::Migration
  def up
  	create_table :user_files do |t|
  	  t.string :name
  	  t.string :extension
  	  t.binary :content
  	  t.timestamps
  	end

  	UserFile.create(name: "my_file", extension: "txt", content: "This is a simple text file...");
  end

  def down
  	drop_table :user_files
  end
end
