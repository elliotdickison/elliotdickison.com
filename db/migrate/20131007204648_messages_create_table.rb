class MessagesCreateTable < ActiveRecord::Migration
  def up
  	create_table :messages do |t|
  	  t.string :name
  	  t.string :email
  	  t.text :body

  	  t.timestamps
  	end

  	Message.create(name: "Spiderman", email: "test@gmail.com", body: "A message from the contact form...");
  end

  def down
  	drop_table :messages
  end
end
