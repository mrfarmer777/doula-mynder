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




end
