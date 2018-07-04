ENV["SINATRA_ENV"] ||= "development" #required development environment

require "bundler/setup"
Bundler.require(:default, ENV['SINATRA_ENV'])

#connect to database...
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3', #...using Sqlite3 adapter
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite" #to the appropriate database based upon the environment, found in the db folder.
)
