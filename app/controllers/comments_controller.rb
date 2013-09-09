post '/comments' do
  @comment = Comment.new(params[:comment])
  if @comment.save
    redirect "/posts/#{@comment.post.id}#comments"
  else
    redirect '/posts'
  end
end