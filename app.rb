# TODO
# cache user_files in tmp folder
# email about comments (for moderation)
# add comment numbers (& links)
# test ie...
# contact form
# github/twitter/instagram links
# comment scrubbing
# delayed publishing of posts
# code page

# SOME DAY...
# clean up css -> mobile first!
# implement html5 & hardboiled markup (header/footer/section/rel)
# fix indentation
# create a github repo
# convert from classic to modular app
# validate post reference ids
# blog archive
# post preview
# give user ownership of posts, files, etc.
# tourguide & notify
# reroute after login

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

configure do
  set :posts_per_page, 5
end

register do
  def auth (type)
    condition do
      # redirect '/login' unless @user and @user.send("is_#{type}?")
    end
  end
end

helpers do
  def is_user?
    @user != nil
  end

  def get_reference_id (text)
    text.downcase.gsub(/(')/, '').gsub(/([^a-z0-9])/, '-').gsub(/(--+)/, '-').gsub(/^(-*)|(-*)$/, '')
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
