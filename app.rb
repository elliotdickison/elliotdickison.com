# TODO
# cache user_files in tmp folder
# email about comments (for moderation)
# test ie...
# contact form
# github/twitter/instagram links
# delayed publishing of posts
# code page
# 404 page
# ajax load more posts
# implement sinatra bundles

# SOME DAY...
# comment website
# clean up css -> mobile first!
# implement html5 & hardboiled markup (header/footer/section/rel)
# fix indentation
# create a github repo
# convert from classic to modular app
# validate post reference id uniqueness
# blog archive
# post preview
# give user ownership of posts, files, etc.
# tourguide & notify
# reroute after login
# error headers/display
# better facebook/twitter share meta data

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
  set :posts_per_page, 1
end

register do
  def auth (type)
    condition do
      redirect '/login' unless @user && @user.send("is_#{type}?")
    end
  end
end

helpers do
  def is_user?
    @user != nil
  end

  def facebook_share_link(link)
    'https://www.facebook.com/sharer/sharer.php?u=' << URI.escape('http://elliotjam.es' << link)
  end

  def twitter_share_link(link)
    'https://twitter.com/share?url=' << URI.escape('http://elliotjam.es' << link)
  end
end

before do
  begin
    if Sinatra::Base.development?
      @user = User.first
    else
      @user = User.find(session[:user_id])
    end
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end
end

# Require all controllers
Dir['./app/controllers/*.rb'].each {|file| require file }

# MISC

get '/code' do
  @page_title = 'Code'
  @selected_tab = :code
  erb :code
end

get '/about' do
  @page_title = 'About'
  @selected_tab = :about
  erb :about
end

get '/contact' do
  @page_title = 'Contact'
  @selected_tab = :contact
  erb :contact
end
