require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/rbenv'

set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'
server 'theboosters.ru', user: 'deploy', roles: %w{app db web}

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=PRODUCTION"
  end
end
# If you are using rvm add these lines:
# require 'capistrano/rvm'
# set :rvm_type, :user
# set :rvm_ruby_version, '2.5.1'