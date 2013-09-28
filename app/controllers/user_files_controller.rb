get '/files', :auth => :admin do
  @files = UserFile.order('created_at DESC')
  erb :'user_files/index'
end

get '/files/new', :auth => :admin do
  erb :'user_files/new'
end

post '/files', :auth => :admin do
  @file = UserFile.new

  if params[:file]
    info = params[:file][:filename].split('.')
    @file.name = info.first.downcase
    @file.extension = info.last.downcase
    @file.content = params[:file][:tempfile].read
  end

  begin
    @file.save
    redirect "files/#{@file}"
  rescue ActiveRecord::RecordNotUnique
    @message = 'A file with that name already exists!'
    erb :'user_files/new'
  end
end

get '/files/:name.:extension' do

  @file = UserFile.find_by(name: params[:name].downcase, extension: params[:extension].downcase)
  
  if @file
    content_type mime_type(@file.extension)
    cache_control :public, :must_revalidate, max_age: 604800
    @file.content
  else
    halt 404
  end
end