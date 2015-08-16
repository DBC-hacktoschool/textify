enable :sessions

get '/' do
  redirect '/login' if !session[:id]
  redirect '/home'
end

get '/login' do
  if session[:remember_me]
    @placeholder_username = session[:remember_me]
  else
    @placeholder_username = 'username'
  end
  erb :"users/login"
end

get '/home' do
  redirect '/login' if !session[:id]

  redirect "/users/#{current_user.id}/playlists"
end

# Log user in if they are in DB
post '/login' do
  user = current_user(params[:username])
  if user && password_match?(user: user, password_attempt: params[:password_attempt])
    session[:id] = user.id
    # if params[:remember_me]
    #   session[:remember_me] = params[:username]
    # else
    #   session[:remember_me] = nil
    # end
    redirect "/users/#{user.id}/playlists"
   #else
    # redirect "/users/#{current_user.id}/playlists"
  else
    p "*"*100
    p params
    flash[:notice] = "Incorrect password or username!"
    redirect '/login?error=true'
  end
end

# Create user if not in DB
post '/users' do
  @user = User.create(username: params[:username],
                      password: params[:password],
                      email: params[:email])
  if @user
    session[:id] = user.id
    redirect "/users/#{current_user.id}/playlists"
  else
    flash[:notice] = "Incorrect password or username!"
    # redirect '/signup?error=true'
  end
end

# Log user out
get '/logout' do
  logout!

  redirect '/'
end

get '/signup' do
  redirect '/home' if logged_in?

  erb :"users/login"
end

get '/users/:id' do
  @user = User.find(params[:id])

  erb :"users/profile_page"
end
