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

get '/blog/archive' do
  @page_title = '<i class="fa fa-archive"></i> Archive'
  @selected_tab = :blog
  @posts = Post.where('published_at IS NOT NULL').order('published_at DESC')
  erb :'posts/archive'
end

get '/blog/search' do
  @search_term = params[:q].strip
  @page_title = 'Blog'
  @selected_tab = :blog
  @searching = true
  
  # HACK: Match using regexp
  # TODO: Look into fulltext searching
  regexp_term = @search_term
    .split(' ')
    .select { |term| not term.empty? }
    .map { |term| Regexp.escape(term) }
    .join('.*')
  @posts = Post.where('published_at IS NOT NULL').where('title ~* (:regexp) OR body ~* (:regexp)', regexp: regexp_term).order('published_at DESC')

  # Match based on tag
  @tags = Tag.where('LOWER(name) = ?', @search_term.downcase)
  @tags.each do |tag|
    @posts.concat tag.posts.where('published_at IS NOT NULL').order('published_at DESC')
  end

  @posts = @posts.uniq { |post| post.id }

  erb :'posts/search', layout: !request.xhr?
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

  # Create the post
  @post = Post.new(params[:post])

  # If the new post was created successfully...
  if @post.save

    # Publish it if requested
    @post.publish! if params[:publish] == 'on'

    # Tag it
    if params[:tags]
      @post.tags = params[:tags].split(',').map do |tag|
        tag = tag.strip
        Tag.find_by_name(tag) || Tag.create({name: tag})
      end
      @post.save
    end

    # View it
    redirect "/posts/#{@post.id}"
  else

    # Show a generic error message (passed via cookie)
    set_tmp_cookie message: settings.generic_error_message

    # Head back to the form...
    redirect '/posts/new'
  end
end

put '/posts/:id', :auth => :admin do
  @post = Post.find(params[:id])
  halt 404 if !@post

  # Update the post with all of the vanilla attributes (title, body, etc.)
  if @post.update_attributes(params[:post])

    # Publish the post if requested
    @post.publish! if params[:publish] == 'on'
      
    # Tag the post
    if params[:tags]
      @post.tags = params[:tags].split(',').map do |tag|
        tag = tag.strip
        Tag.find_by_name(tag) || Tag.create({name: tag})
      end
      @post.save
    end

    # Redirect to the post
    redirect "/posts/#{@post.id}"
  else

    # Show a generic error message (passed via cookie)
    set_tmp_cookie message: settings.generic_error_message

    # Head back to the form
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

# Old style blog post links...
get %r{/blog/([0-9]{4})/(.+)} do
  redirect "/blog/#{params[:captures].last}", 301 # Moved Permanently
end

# Throw this last so it doesn't catch any built-in routes
get '/:slug' do
  @selected_tab = :blog
  @post = Post.find_by slug: params[:slug]
  halt 404 if !@post
  @page_title = @post.title
  erb :'posts/show'
end