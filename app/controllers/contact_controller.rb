get '/contact' do
  @page_title = 'Contact'
  @selected_tab = :contact
  erb :contact
end

post '/contact' do
  case settings.environment
  when :development
  	Pony.options({
  		via: :sendmail
  	})
  when :production
	  Pony.options({
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
	  })
	end

	Pony.mail({
  	from: params[:email],
  	to: settings.contact_email,
  	subject: params[:name] << " via elliotjam.es",
    body: params[:body]
  })

	@message = "Thanks, I'll get back to as soon as I can.";
  erb :contact
end