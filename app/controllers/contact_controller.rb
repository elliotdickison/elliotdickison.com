get '/contact' do
  @page_title = 'Contact'
  @selected_tab = :contact
  erb :contact
end

post '/contact' do
  
	# TODO: Fix mail on develop
	if settings.environment == :production
		Pony.mail({
	  	from: params[:name] << "<" << params[:email] << ">",
	  	to: settings.contact_email,
	  	subject: "Contact Form at elliotjam.es",
	    body: params[:body]
	  })
	end

	@page_title = 'Contact'
	@selected_tab = :contact
	@message = "Thanks, I'll get back to you as soon as I can.";
  erb :contact
end