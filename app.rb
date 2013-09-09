# TODO
# better route names (blog/post-name/, file/file_name.extension)
# user file cacheing
# blog order/limit
# comment spam filtering
# spacing/margins...
# responsive layout
# tourguide & notify
# create a github repo

# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'digest/md5'

set :database, 'sqlite3:///blog.db'

# Set the views folder
set :views, Proc.new { File.join(root, 'app', 'views') }

# Require all models
Dir['./app/models/*.rb'].each {|file| require file }

# Require all controllers
Dir['./app/controllers/*.rb'].each {|file| require file }

# MISC

get '/code' do
  @selected_tab = :code
  erb :code
end

get '/about' do
  @selected_tab = :about
  erb :about
end

get '/contact' do
  @selected_tab = :contact
  erb :contact
end
