post '/comments' do
  @comment = Comment.new(params[:comment])
  if @comment.save
  	
  	if settings.send_mail
  		Pony.mail({
		  	from: "#{@comment.commenter} <#{@comment.email}>",
		  	to: settings.contact_email,
		  	subject: "Comment #{@comment.id} at elliotjam.es",
		    body: "#{@comment.body} <a href='#{request.host}/posts/#{@comment.post.id}#comment#{@comment.id}'>original</a>"
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