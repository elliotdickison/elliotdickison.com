
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

helpers do
  def admin_mode?
    @user && @user.is_admin?
  end

  def facebook_share_link(link)
    'https://www.facebook.com/sharer/sharer.php?u=' << URI.escape(request.scheme + '://' + request.host + link)
  end

  def twitter_share_link(link)
    'https://twitter.com/share?url=' << URI.escape(request.scheme + '://' + request.host + link)
  end

  def nice_list(arr, separator = ', ', connector = ' and ', oxford_comma = true)
    if arr.empty?
      ''
    elsif arr.size == 1
      arr.first.to_s
    else
      connector = (separator << connector).gsub!(/ +/, ' ') if oxford_comma and arr.size > 2
      [arr[0...-1].join(separator), arr.last].join(connector)
    end
  end

  def get_message(target = nil)
    if @user_message and @user_message_target == target
      message = @user_message
    elsif cookies[:message] and cookies[:message_target] == target
      message = cookies[:message]
    end

    if message
      '<div class="message cf">' << message << '<a href="#" class="js-close right">Close</a></div>'
    else
      ''
    end
  end

  def set_tmp_cookie(opts)
    opts.each do |(k, v)|
      cookies[k.to_sym] = v
      @tmp_cookie_keys.push k.to_sym
    end
  end

  def build_error_message(model, attribute_aliases = {})
    message = 'Uh oh, that didn\'t quite work. '
    model.errors.messages.each do |(attr, errors)|
      message << "#{(attribute_aliases[attr] || attr).capitalize} #{nice_list errors}. "
    end
    message << 'Please try again.'
  end
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

# Require all validators
Dir['./app/validators/*.rb'].each {|file| require file }

# Require all models
Dir['./app/models/*.rb'].each {|file| require file }

# Require all controllers
Dir['./app/controllers/*.rb'].each {|file| require file }

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

# Old style blog post links...
get %r{/blog/([0-9]{4})/(.+)} do
  redirect "/blog/#{params[:captures].last}", 301 # Moved Permanently
end

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
