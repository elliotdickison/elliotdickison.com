# TODO
# test ie...
# delayed publishing of posts (PublishedAt set on publish)
# code page
# better content (about, contact, 404)
# figure out sub-domains (admin)
# clean up css
# comment markdown of some sort

# SOME DAY...
# offer rss feed
# post tags (remember rel-tag microformat)
# better admin controls
# cache user_files in tmp folder
# implement asset bundler
# add better admin links
# clean up css -> mobile first!
# implement html5 & hardboiled markup (header/footer/section/rel)
# fix indentation (2 spaces?)
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
require 'sinatra/subdomain'
require 'digest/md5'
require 'pony'

# Set the database
set :database, ENV['DATABASE_URL'] || 'postgresql://elliot.dickison:iamaskier@localhost/elliot.dickison'

# Set the views folder
set :views, Proc.new { File.join(root, 'app', 'views') }

# Turn on sessions
enable :sessions

# Require all models
Dir['./app/models/*.rb'].each {|file| require file }

configure do
  set :github_id, 'elliotjames'
  set :twitter_id, 'elliotdickison'
  set :instagram_id, '_elliotjames_'
  set :posts_per_page, 5
  set :contact_email, 'ejdickison@gmail.com'
  set :send_mail, settings.environment == :production
end

# Setup pony mail
Pony.options = case settings.environment
when :development
  {
    via: :sendmail
  }
when :production
  {
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  }
end

register do
  def auth (type)
    condition do
      redirect '/' unless send("#{type}_mode?")
    end
  end
end

helpers do
  def admin_mode?
    @user && @user.is_admin? && subdomain == 'admin'
  end

  def facebook_share_link(link)
    'https://www.facebook.com/sharer/sharer.php?u=' << URI.escape(request.scheme + '://' + request.host + link)
  end

  def twitter_share_link(link)
    'https://twitter.com/share?url=' << URI.escape(request.scheme + '://' + request.host + link)
  end
end

before do
  begin
    if settings.environment == :development
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

not_found do
  redirect '/404.html'
end
