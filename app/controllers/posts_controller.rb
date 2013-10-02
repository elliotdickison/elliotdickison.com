get '/' do
  redirect '/blog'
end

get '/blog' do
  @page_title = 'Blog'
  @selected_tab = :blog
  @current_page = params[:page].to_i
  page_offset = @current_page * settings.posts_per_page
  @show_more_link = (Post.where('published_at IS NOT NULL').count.to_f / settings.posts_per_page.to_f).ceil > page_offset + 1

  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC').offset(page_offset).limit(settings.posts_per_page)

	erb :'posts/index', layout: @current_page == 0
end

get '/blog/*/*' do |year, reference_id|
  @selected_tab = :blog
  @post = Post.where("date_part('year', published_at) = ? AND reference_id = ?", year, reference_id).first
  @page_title = @post.reference_id
  erb :'posts/show'
end

post '/posts', :auth => :admin do
  @post = Post.new(params[:post])
  if @post.save
    @post.publish if params[:publish] == 'on'
    redirect "/posts/#{@post.id}"
  else
    redirect '/posts/new'
  end
end

get '/posts', :auth => :admin do
  @posts = Post.all.order('id ASC')
  @selected_tab = :blog
  @page_title = 'All Posts'
  erb :'posts/list'
end

get '/posts/new', :auth => :admin do
  @selected_tab = :blog
  @post = Post.new
  erb :'posts/form'
end

get '/posts/:id', :auth => :admin do
  @selected_tab = :blog
  @post = Post.find(params[:id])
  erb :'posts/show'
end

put '/posts/:id', :auth => :admin do
  @post = Post.find(params[:id])
  if @post.update_attributes(params[:post])
    @post.publish if params[:publish] == 'on'
    erb :'posts/show'
  else
    redirect "/posts/#{@post.id}/edit"
  end
end

delete '/posts/:id', :auth => :admin do
  if Post.find(params[:id]).destroy
    redirect '/posts'
  else
    redirect "/posts/#{@post.id}"
  end
end

get '/posts/:id/edit', :auth => :admin do
  @selected_tab = :blog
  @post = Post.find(params[:id])
  erb :'posts/form'
end