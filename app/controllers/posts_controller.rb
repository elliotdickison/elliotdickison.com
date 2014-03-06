get '/' do
  redirect '/blog'
end

get '/feed' do
  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC').limit(10)
  builder :'posts/feed'
end

get '/blog' do
  @page_title = 'Blog'
  @selected_tab = :blog
  @current_page = params[:page].to_i
  page_offset = @current_page * settings.posts_per_page
  @show_more_link = (Post.where('published_at IS NOT NULL').count.to_f / settings.posts_per_page.to_f).ceil > page_offset + 1

  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC').offset(page_offset).limit(settings.posts_per_page)

	erb :'posts/index', layout: !request.xhr?
end

get '/blog/search/:q' do
  @page_title = 'Blog'
  @selected_tab = :blog
  
  terms = params[:q].split(' ').select { |term| not term.empty? }
  @posts = Post.where('LOWER(title) ~* :regexp OR LOWER(body) ~* :regexp', regexp: "(#{terms.join('.*')})").order('published_at DESC').limit(25)

  erb :'posts/search', layout: !request.xhr?
end

get %r{/blog/([0-9]+)/(.*)} do
  @selected_tab = :blog
  @post = Post.where("date_part('year', published_at) = ? AND reference_id = ?", params[:captures].first, params[:captures].last).first
  halt 404 if !@post
  @page_title = @post.title
  erb :'posts/show'
end

get '/blog/archive' do
  @page_title = '<i class="fa fa-archive"></i> Archive'
  @selected_tab = :blog
  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC')
  erb :'posts/archive'
end

get '/posts', :auth => :admin do
  @posts = Post.all.order('id DESC')
  @selected_tab = :blog
  @page_title = 'All Posts'
  erb :'posts/list'
end

get '/posts/new', :auth => :admin do
  @selected_tab = :blog
  @post = Post.new
  @page_title = 'New Post'
  erb :'posts/form'
end

get '/posts/:id', :auth => :admin do
  @selected_tab = :blog
  @post = Post.find(params[:id])
  @page_title = @post.title
  halt 404 if !@post
  erb :'posts/show'
end

post '/posts', :auth => :admin do
  @post = Post.new(params[:post])
  if @post.save
    @post.publish! if params[:publish] == 'on'
    if params[:tags]
      @post.tags = params[:tags].split(',').map do |tag|
        tag = tag.strip
        Tag.find_by_name(tag) || Tag.create({name: tag})
      end
      @post.save
    end
    redirect "/posts/#{@post.id}"
  else
    redirect '/posts/new'
  end
end

put '/posts/:id', :auth => :admin do
  @post = Post.find(params[:id])
  halt 404 if !@post
  if @post.update_attributes(params[:post])
    @post.publish! if params[:publish] == 'on'
    if params[:tags]
      @post.tags = params[:tags].split(',').map do |tag|
        tag = tag.strip
        Tag.find_by_name(tag) || Tag.create({name: tag})
      end
      @post.save
    end
    redirect "/posts/#{@post.id}"
  else
    set_tmp_cookie message: settings.generic_error_message
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
  @page_title = "Edit #{@post.title}"
  halt 404 if !@post
  erb :'posts/form'
end