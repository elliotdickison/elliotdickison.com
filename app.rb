
# Set the database
set :database, ENV['DATABASE_URL']

# Set the views folder
set :views, Proc.new { File.join(root, 'app', 'views') }

# Turn on sessions
enable :sessions

# Config
config_file 'config/sinatra.yml'
configure do
  set :send_mail, settings.environment == :production
end

# Dump errors
set :dump_errors, true if settings.environment == :development

# Debug logging
LogBuddy.init(
  :logger => Logger.new("./tmp/debug.log"),
  :disabled => settings.environment == :production  
)

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

# Setup a markdown renderer (this is most likely *not* the best place to do this)
class HtmlWithGoodies < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  def block_code(code, language)
    require 'pygments'
    
    d language
    Pygments.highlight code, options: {
      lexer: language,
      startinline: true,
      linenos: "inline",
      lineseparator: "<br>"
    }
  end
end

set :auth do |type|
  condition do
    redirect('/login') unless send("#{type}_mode?")
  end
end

require './app/helpers'
helpers do
  include Helpers
end

before do

  begin
    @user = User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    @user = nil
  end

  @tmp_cookie_keys = [];
end

after do
  cookies.delete_if do |k|
    not @tmp_cookie_keys.include? k.to_sym
  end
end

# Require all models
Dir['./app/models/*.rb'].each {|file| require file }

# Let the Post class know what we've got for bitly settings
Post.bitly_api_address = settings.bitly_api_address
Post.bitly_access_token = settings.bitly_access_token

# Go to the blog by default
get '/' do
  redirect '/blog'
end

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

get '/pong' do
  File.read 'code/pong/index.html'
end

# Old style blog post links...
get %r{/blog/([0-9]{4})/(.+)} do
  puts 
  redirect "/#{params[:captures].last}", 301 # Moved Permanently
end

# Require all other routes
Dir['./app/routes/*.rb'].each {|file| require file }

# Throw this last so it doesn't catch any built-in routes
get '/:slug' do
  @selected_tab = :blog
  @post = Post.find_by slug: params[:slug]
  halt 404 if !@post
  @page_title = @post.title
  erb :'posts/show'
end

not_found do
  redirect '/404.html'
end
