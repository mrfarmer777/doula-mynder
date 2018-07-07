require './config/environment'
require 'rack-flash'

class ApplicationController<Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, "app/views"
    enable :sessions
    set :session_secret, "gigijuju"
    use Rack::Flash
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
      if @user.id.nil?
        flash[:message]="That username is already in use by another user. Please select another."
        redirect "/signup"
      else
        session[:user_id]=@user.id
        redirect "/dashboard"
      end
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

  post "/login" do
    @user=User.find_by(username:params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id]=@user.id
      redirect "/dashboard"
    else
      flash[:message]="Incorrect username or password. Please try again"
      redirect "/login"
    end
  end

  #doula dashboard view
  get "/dashboard" do
    if logged_in?
      @user=current_user
      erb :'users/dashboard'
    else
      redirect "/login"
    end
  end

  #public profile view
  get "/users/:id" do
    if logged_in?
      @user=User.find(params[:id])
      erb :'users/profile'
    else
      flash[:message]="Please log in to see all available doulas."
      redirect "/login"
    end
  end

  get "/users" do
    if logged_in?
      erb :'users/index'
    else
      redirect "/login"
    end
  end

  #update action
  #update action
get "/users/:id/edit" do
  if current_user.id==params[:id].to_i
    erb :'users/edit'
  else
    redirect "/login"
  end
end

patch "/users/:id" do
  if current_user.id==params[:id].to_i
    @user=User.find(params[:id])
    @user.update(name:params[:name],email:params[:email],company_name:params[:company_name])
    @user.save #?redundant?
    redirect "/dashboard"
  else
    flash[:message]="Cannot edit others' profiles."  #?passing this to further calls?
    redirect "/login"
  end
end

  get "/logout" do
    session.delete(:user_id)
    redirect "/"
  end

  #//////////////CLIENT ACTIONS///////////

  #Create
  get "/clients/new" do
    if logged_in?
      erb :'clients/new'
    else
      redirect "/login"
    end
  end

  post "/clients" do
    if !params[:client][:name].empty?
      @client=Client.create(params[:client])
      @client.user_id=current_user.id
      @client.save
      redirect "/dashboard"
    else
      flash[:message]="New clients must have a name"
      redirect "/clients/new"
    end
  end

  #Read
  get "/clients/:id" do
    @client=Client.find(params[:id])
    if logged_in? && current_user==@client.user
      erb :"clients/view"
    else
      flash[:message]="Error: You may only view your own clients"
      redirect "/dashboard"
    end
  end

  #update
  get "/clients/:id/edit" do
    @client=Client.find(params[:id])
    if logged_in? && current_user==@client.user
      erb :"clients/edit"
    else
      flash[:message]="Error: You may only edit your own clients"
      redirect "/dashboard"
    end
  end

  patch "/clients/:id" do
    @client=Client.find(params[:id])
    if logged_in? && current_user==@client.user
      if params[:client][:name].empty?
        flash[:message]="Client must have a name"
        redirect "/clients/#{@client.id}/edit"
      else
        @client.update(params[:client])
        @client.save
      end
    end
    redirect "/dashboard"
  end

  #Delete
  delete "/clients/:id" do
    @client=Client.find(params[:id])
    if logged_in? && current_user==@client.user
      client_name=@client.name
      @client.destroy
      flash[:message]="Client #{client_name} deleted!"
    else
      flash[:message]="Cannot delete a client that is not yours."
    end
    redirect "/dashboard"
  end

  #//////////////HELPERS/////////////////
  helpers do
    def logged_in?
      !!session[:user_id] #! First '!'' checks if its falsey, second one flips the boolean.
    end

    def current_user
      User.find(session[:user_id])
    end

    def get_progress(client)
      if !client.due_date.nil?
        progress=42-(client.due_date.cweek-DateTime.now.cweek+(52*(client.due_date.year-DateTime.now.year)))
      else
        progress=0
      end
      "#{progress} weeks"
    end

    def get_sorted_clients(user)
      sorted=user.clients.sort_by {|client| client["due_date"]}
      sorted
    end
  end


end
