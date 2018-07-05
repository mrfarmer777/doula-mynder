require './config/environment'

class ApplicationController<Sinatra::Base

  configure do
    set :public_folder, 'public' #unused currently
    set :views, "app/views"
    enable :sessions
    set :session_secret, "gigijuju"
  end

  get '/' do
    erb :home
  end



  #////////////USER ACTIONS//////////////
  get "/signup" do
    if !logged_in?
      erb :'users/signup'
    else
      redirect "/dashboard"
    end
  end

  post "/signup" do
    if !params[:username].empty? && !params[:password].empty?
      @user=User.create(params)
      @user.save
      session[:user_id]=@user.id
      redirect "/dashboard"
    else
      redirect "/signup"
    end
  end

  get "/login" do
    if !logged_in?
      erb :'users/login'
    else
      redirect "/dashboard"
    end
  end

  #doula dashboard view
  get "/dashboard" do
    if logged_in?
      @user=current_user
      erb :"users/dashboard"
    else
      redirect "/login"
    end
  end

  #public profile view
  get "/users/:id" do
    if logged_in?
      @user=User.find(params[:id])
      erb :'users/dashboard'
    else
      redirect "/login"
    end
  end

  get "/logout" do
    session.delete(:user_id)
    redirect "/"
  end



  #//////////////HELPERS/////////////////
  helpers do
    def logged_in?
      !!session[:user_id] #! First '!'' checks if its falsey, second one flips the boolean.
    end

    def current_user
      User.find(session[:user_id])
    end
  end


end