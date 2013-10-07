get '/contact' do
  @page_title = 'Contact'
  @selected_tab = :contact
  erb :contact
end

post '/contact' do
  
  if settings.send_mail
		begin
			Pony.mail({
		  	from: "#{params[:name]} <#{params[:email]}>",
		  	to: settings.contact_email,
		  	subject: "Contact Form at elliotjam.es",
		    body: params[:body]
		  })
		  @message = "Thanks, I'll get back to you as soon as I can.";
		rescue
			# Error message below
		end
	end

	@page_title = 'Contact'
	@selected_tab = :contact
	@message ||= 'Sorry, seems a mouse has chewed through the wires someplace. Please try again later.'
	@message_target = 'contact_form'
  erb :contact
end