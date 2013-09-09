get '/files' do
  @files = UserFile.order('created_at DESC')
  erb :'files/index'
end

get '/files/new' do
  erb :'files/new'
end

post '/files' do
  @file = UserFile.new

  if params[:file]
    info = params[:file][:filename].split('.')
    @file.name = info.first
    @file.extension = info.last
    @file.content = params[:file][:tempfile].read
  end

  if @file.save
    redirect "files/#{@file.id}"
  else
    redirect 'files/new'
  end
end

get '/files/:id' do
  #todo - cache this
  @file = UserFile.find(params[:id])
  content_type 'image/jpg'
  @file.content
end