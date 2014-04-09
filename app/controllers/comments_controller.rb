post '/comments' do
  @comment = Comment.new(params[:comment])

  if @comment.invalid?

    # Throw together a readable error message
    error_message = build_error_message @comment, {commenter: 'your name', email: 'your email address', website: 'the website field', body: 'the comment body'}
  
  elsif @comment.save
    
    begin
    	if settings.send_mail
    		Pony.mail({
  		  	from: "#{@comment.commenter} <#{@comment.email}>",
  		  	to: settings.contact_email,
  		  	subject: "Comment #{@comment.id} at elliotjam.es",
  		    body: "#{@comment.body}\n\#{request.host}/posts/#{@comment.post.id}#comment#{@comment.id}"
  		  })
    	end
    rescue
      # Fail silently if we can't send an email
    end

    redirect "#{@comment.post.link}#comment-#{@comment.id}"
  else
    error_message = generic_error_message
  end
  
  if error_message
    
    # Pass the error message along via a cookie
    set_tmp_cookie message: error_message, message_target: 'comment_form'

    # Pass along the current values so we can re-populate the form
    set_tmp_cookie params[:comment]

    @post = Post.find(params[:comment][:post_id])
    redirect "#{@post.link}#comment-form"
  end
end

delete '/comments/:id', :auth => :admin do
  @comment = Comment.find(params[:id])
  @comment.destroy if @comment
  redirect "#{@comment.post.link}#comments"
end