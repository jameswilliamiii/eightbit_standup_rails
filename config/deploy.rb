require 'mina/multistage'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/whenever'
require 'mina/unicorn'
require 'mina/scp'

set :domain, '107.170.28.71'
set :deploy_to, '/home/deploy/apps/eightbit-standup-rails-production'
set :repository, 'git@github.com:jameswilliamiii/eightbit_standup_rails.git'
set :branch, 'master'
set :user, 'deploy'
set :forward_agent, true
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :rails_env, 'production'
set :unicorn_env, "production"


# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml', 'config/application.yml', 'sockets']

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  queue %{
echo "-----> Loading environment"
#{echo_cmd %[source ~/.bashrc]}
}
  invoke :'rbenv:load'
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/application.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/application.yml'."]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]
end

desc "Deploys the current version to the server."
task deploy: :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'unicorn:restart'
    end

    invoke :'whenever:update'

  end
end

# # Sunspot/Solr Tasks
task :solr_start do
  queue "cd #{deploy_to}/#{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:start"
end

task :solr_stop do
  queue "cd #{deploy_to}/#{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:stop"
end

task :solr_reindex do
  queue "cd #{deploy_to}/#{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
end

# Copies nginx.server config into site-enabled
task nginx_copy_config: :environment do
  queue "sudo cp #{deploy_to}/current/config/deploy/nginx-#{rails_env}.server /etc/nginx/sites-available/"
  invoke :nginx_restart
end

task nginx_link_config: :environment do
  queue "sudo ln -s /etc/nginx/sites-available/nginx-#{rails_env}.server /etc/nginx/sites-enabled/nginx-#{rails_env}.server"
end

task :nginx_restart do
  queue "sudo service nginx restart"
end

# Copies application.yml and secrets.yml to the server
namespace :secrets do
  desc "Upload secret configuration files"
  task :upload do
    scp_upload("config/application.yml", "#{deploy_to}/#{shared_path}/config/", verbose: true)
    scp_upload("config/secrets.yml", "#{deploy_to}/#{shared_path}/config/", verbose: true)
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
