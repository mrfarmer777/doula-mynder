require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise "Migrations are pending. Run 'rake db:migrate' to resolve the issue."
end

use Rack::MethodOverride #allows for delete and patch request from within forms
run ApplicationController #mount the application controller
