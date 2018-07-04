ENV["SINATRA_ENV"] = "test"  #creates a separate test environment

#requiring test-only gems
require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'

#checking to see if the right database is built and properly migrated.
if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

#turns off activerecord logger
ActiveRecord::Base.logger = nil

#configures Rspec gem before use
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true  #?not sure
  config.filter_run :focus  #no idea
  config.include Rack::Test::Methods  #including test methods from rack, whatever they are.
  config.include Capybara::DSL  #including the Domain Specific Language from Capybara gem
  DatabaseCleaner.strategy = :truncation  #no idea

  config.before do
    DatabaseCleaner.clean  #perhaps, start with a fresh database every time to keep testing reliable.
  end

  config.after do
    DatabaseCleaner.clean #clearn the database after each run to keep it reliable
  end

  config.order = 'default' #dunno

  # Capybara.current_driver = :selenium

end

def app
  Rack::Builder.parse_file('config.ru').first   #rack up the app (mount the controller)
end

Capybara.app = app  #run that ish.
