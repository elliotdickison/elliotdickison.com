get '/blog/tags' do
  @page_title = '<i class="fa fa-tags"></i> Tags'
  @selected_tab = :blog
  @tags = Tag
  	.joins('JOIN taggings ON tags.id = taggings.tag_id AND taggings.taggable_type = \'Post\'')
  	.joins('JOIN posts ON posts.id = taggings.taggable_id AND posts.published_at IS NOT NULL')
  	.group('tags.id')
  	.order('tags.name ASC')
  erb :'tags/index'
end

get '/blog/tags/:id' do
  @tag = Tag.find(params[:id])
  @page_title = "<i class='fa fa-tag'></i> #{@tag.name}"
  @selected_tab = :blog
  erb :'tags/show'
end
