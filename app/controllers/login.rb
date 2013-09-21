get '/login' do
  erb :login, layout: nil
end

post '/login' do
  @user = User.authenticate(params[:name], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    @error = 'Invalid username or password.'
    erb :login, layout: nil
  end
end