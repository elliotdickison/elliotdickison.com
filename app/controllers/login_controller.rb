get '/login' do
  erb :login, layout: nil
end

get '/logout' do
	@user = nil
	session.clear
	redirect '/'
end

post '/login' do
  @user = User.authenticate(params[:name], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/posts'
  else
    @error = 'Invalid username or password.'
    erb :login, layout: nil
  end
end