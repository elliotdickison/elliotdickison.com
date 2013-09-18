get '/' do
  redirect '/blog'
end

get '/blog' do
  @selected_tab = :blog

  cur_page = params[:page].to_i
  posts_per_page = 5
  page_offset = cur_page * posts_per_page

  @posts = Post.limit(posts_per_page).offset(page_offset).order('created_at DESC')
  
  @newer_page = cur_page - 1 if cur_page > 0
  @older_page = cur_page + 1 if page_offset + posts_per_page < Post.count

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

get '/posts/new', :auth => :admin do
  @selected_tab = :blog
  @post = Post.new
  erb :'posts/new'
end

get '/posts/:id' do
  @selected_tab = :blog
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
    redirect '/blog'
  else
    redirect "/posts/#{@post.id}"
  end
end

get '/posts/:id/edit' do
  @selected_tab = :blog
  @post = Post.find(params[:id])
  erb :'posts/edit'
end