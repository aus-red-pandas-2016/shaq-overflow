get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(username: params[:username])

  # before this happens, we need to make sure they input a password
  if user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect "/"
  else
    erb :'users/error'
  end
end

get '/logout' do
  session.delete(:user_id)
  redirect '/'
end



