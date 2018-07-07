source "http://www.rubygems.org"

gem 'sinatra' #for handling of routing and server actions
gem 'activerecord', '4.2.7.1', :require => 'active_record' #for ORM
gem 'sinatra-activerecord', :require => 'sinatra/activerecord' #enabling AR to interact with Sinatra
gem 'pry' #for debugging
gem 'rake' #for task automation
gem 'tux' #for ORM debugging
gem 'require_all' #for environment.rb requiring
gem 'sqlite3' #for database management
gem 'thin' #basic server for shotgun
gem 'shotgun' #for live view of running app
gem 'bcrypt' #for password encryption
gem 'rack-flash3' #for flash messages

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
end
