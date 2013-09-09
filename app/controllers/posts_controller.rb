get '/' do
  redirect '/posts'
end

get '/posts' do
  @selected_tab = :posts
	@posts = Post.order('created_at DESC')
	erb :'posts/index'
end

post '/posts' do
  @post = Post.new(params[:post])
  if @post.save
    redirect "/posts/#{@post.id}"
  else
    redirect '/posts/new'
  end
end

get '/posts/new' do
  @selected_tab = :posts
  @post = Post.new
  erb :'posts/new'
end

get '/posts/:id' do
  @selected_tab = :posts
  @post = Post.find(params[:id])
  erb :'posts/show'
end

put '/posts/:id' do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    erb :'posts/show'
  else
    redirect "/posts/#{@post.id}/edit"
  end
end

delete '/posts/:id' do
  if Post.find(params[:id]).destroy
    redirect '/posts'
  else
    redirect "/posts/#{@post.id}"
  end
end

get '/posts/:id/edit' do
  @selected_tab = :posts
  @post = Post.find(params[:id])
  erb :'posts/edit'
end