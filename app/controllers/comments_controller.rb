post '/comments' do
  @comment = Comment.new(params[:comment])
  if @comment.save
    redirect "#{@comment.post.link}#comments"
  else
    redirect '/blog'
  end
end