get '/blog/tags' do
  @page_title = '<i class="fa fa-tags"></i> Tags'
  @selected_tab = :blog
  @tags = Tag.all
  erb :'tags/index'
end

get '/blog/tags/:id' do
  @tag = Tag.find(params[:id])
  @page_title = "<i class='fa fa-tag'></i> #{@tag.name}"
  @selected_tab = :blog
  erb :'tags/tag'
end
