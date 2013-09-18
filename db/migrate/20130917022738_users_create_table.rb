class UsersCreateTable < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  	  t.string :name
  	  t.string :password
  	  t.string :first
  	  t.string :last
  	  t.string :email
  	  t.timestamps
  	end

  	User.create(name: "elliot", password: "934b535800b1cba8f96a5d72f72f1611", first: "Elliot", last: "Dickison", email: "ejdickison@gmail.com");
  end

  def down
  	drop_table :users
  end
end
