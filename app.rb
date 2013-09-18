# TODO
# better route names (blog/year/post-name/)
# cache user_files in tmp folder
# blog order/limit
# comment spam filtering (moderator approval)
# spacing/margins...
# responsive layout
# tourguide & notify
# create a github repo
# add users
# permissions/admin
# convert from classic to modular app
# add comment numbers (& links)
# give user ownership of posts, files, etc.
# email confirmation for comments? probably not...
# fix indentation
# implement html5 & hardboiled markup (header/footer/section/rel)

# app.rb
require 'sinatra'
require 'sinatra/activerecord'
require 'digest/md5'

set :database, 'sqlite3:///blog.db'

# Set the views folder
set :views, Proc.new { File.join(root, 'app', 'views') }

enable :sessions

# Require all model
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

get '/login' do
  erb :login, layout: nil
end

post '/login' do
  @user = User.authenticate(params[:name], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    @error = 'Invalid username or password.'
    erb :login, layout: nil
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
