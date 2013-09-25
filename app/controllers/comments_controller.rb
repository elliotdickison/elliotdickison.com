post '/comments' do
  @comment = Comment.new(params[:comment])
  if @comment.save
    redirect "#{@comment.post.link}#comments"
  else
    redirect '/blog'
  end
end

delete '/comments/:id', :auth => :admin do
  @comment = Comment.find(params[:id])
  @comment.destroy
  redirect "#{@comment.post.link}#comments"
end