get '/contact' do
  @page_title = 'Contact'
  @selected_tab = :contact
  erb :contact
end

post '/contact' do
  case settings.environment
  when :development
  	Pony.mail({
	  	from: params[:email],
	  	to: settings.contact_email,
	  	via: :sendmail,
	    subject: params[:name] << " via elliotjam.es",
	    body: params[:body]
	  })
  when :production
	  Pony.mail({
	  	from: params[:email],
	  	to: settings.contact_email,
	    subject: params[:name] << " via elliotjam.es",
	    body: params[:body],
	    :via => :smtp,
	    :via_options => {
	      :address => 'smtp.sendgrid.net',
	      :port => 25,
	      :authentication => :plain,
	      :user_name => ENV['SENDGRID_USERNAME'],
	      :password => ENV['SENDGRID_PASSWORD'],
	      :domain => ENV['SENDGRID_DOMAIN'] }
	  })
	end

	@message = "Thanks, I'll get back to as soon as I can.";
  erb :contact
end