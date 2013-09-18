class UserFilesAddIndex < ActiveRecord::Migration
  def up
  	add_index(:user_files, [:name, :extension], unique: true, name: "by_file_name")
  end

  def down
  	remove_index :user_files, name: "by_file_name"
  end
end
