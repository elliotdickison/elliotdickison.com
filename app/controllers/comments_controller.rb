post '/comments' do
  @comment = Comment.new(params[:comment])

  if @comment.invalid?
    
    # Throw together a readable error message
    param_names = {commenter: 'name', email: 'email', website: 'website', body: 'comment'}
    message = 'Uh oh, that didn\'t quite work. '
    @comment.errors.messages.each do |(param, errors)|
      message << "The #{param_names[param]} field #{nice_list errors}. "
    end
    message << 'Please try again.'

    # Pass the error message along via a cookie
    set_tmp_cookie message: message, message_target: 'comment_form'

    # Pass along the current values so we can re-populate the form
    set_tmp_cookie params[:comment]

    @post = Post.find(params[:comment][:post_id])
    redirect "#{@post.link}#comment_form"

  elsif @comment.save
  	
  	if settings.send_mail
  		Pony.mail({
		  	from: "#{@comment.commenter} <#{@comment.email}>",
		  	to: settings.contact_email,
		  	subject: "Comment #{@comment.id} at elliotjam.es",
		    body: "#{@comment.body}\n\nadmin.#{request.host}/posts/#{@comment.post.id}#comment#{@comment.id}"
		  })
  	end

    redirect "#{@comment.post.link}#comment#{@comment.id}"
  else
    redirect '/blog'
  end
end

delete '/comments/:id', :auth => :admin do
  @comment = Comment.find(params[:id])
  @comment.destroy
  redirect "#{@comment.post.link}#comments"
end