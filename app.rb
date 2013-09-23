# TODO
# better route names (blog/year/post-name/)
# cache user_files in tmp folder
# comment spam filtering (moderator approval)
# tourguide & notify
# add comment numbers (& links)
# give user ownership of posts, files, etc.
# test ie...
# blog archive
# contact form
# github/twitter/instagram links

# REFACTOR
# clean up css -> mobile first!
# implement html5 & hardboiled markup (header/footer/section/rel)
# fix indentation
# create a github repo
# convert from classic to modular app

# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'digest/md5'

# Set the database
set :database, ENV['DATABASE_URL'] || 'postgresql://elliot.dickison:iamaskier@localhost/elliot.dickison'

# Set the views folder
set :views, Proc.new { File.join(root, 'app', 'views') }

# Turn on sessions
enable :sessions

# Require all models
Dir['./app/models/*.rb'].each {|file| require file }

register do
  def auth (type)
    condition do
      redirect '/login' unless @user and @user.send("is_#{type}?")
    end
  end
end

helpers do
  def is_user?
    @user != nil
  end
end

before do
  begin
    @user = User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end
end

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
