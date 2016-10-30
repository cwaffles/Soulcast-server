#!/bin/bash

$HOMEDIR = echo $HOME
#need this for loading up environment variables
echo "Please enter in the url for the dotenv file (look in Google Sheets): "
read $dotenv
echo "Please enter in the url for the the nginx config (look in Google Sheets): "
read $nginx_config
echo "You entered dotenv = $dotenv"
echo "You entered nginx_config = $nginx_config"

#Setting up rails on a new system
sudo apt-get update -qq && sudo apt-get upgrade --yes #installs updates on server
sudo apt-get install curl

###install nodejs (required for rails)
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install dotenv

###install and setup nginx
sudo add-apt-repository ppa:nginx/stable
sudo apt-get update
sudo apt-get install nginx-light

sudo wget $nginx_config -O /etc/nginx/sites-available/soulcast.ml.conf

sudo ln -s /etc/nginx/sites-available/soulcast.ml.conf /etc/nginx/sites-enabled/soulcast.ml.conf
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx start

###install postgres #libpq-dev for pg gem
sudo apt-get install postgresql libpq-dev
sudo -u postgres createuser -s soulcast-dev
sudo -u postgres psql
echo "\password soulcast-dev\nsoulcast-dev\nsoulcast-dev\n\q\n"

###this installs RVM and Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install rails
gem install puma

###make new web folder
mkdir ~/soulcast.ml && cd ~/soulcast.ml

###set up deploy script
echo "#Deploy and start script
git pull https://github.com/cwaffles/soulcast-server.git
wget $dotenv -O ~/soulcast.ml/soulcast-server/.env
wget $dotenv -O ~/soulcast.ml/soulcast-server/.env.production
#################################FIX THIS for dotenv

/etc/init.d/soulcast-server-startup.sh
sudo update-rc.d soulcast-server-startup defaults
bundle install
rake db:reset RAILS_ENV=production
rake assets:clobber RAILS_ENV=production
rake assets:precompile RAILS_ENV=production

#make new tmux session for running 'rails server'
tmux new -d -c ~/soulcast.domain/soulcast-server -s rails_server 'pumactl start'
tmux new -s rails-server -c ~/soulcast.domain/soulcast-server" > ~/deploy.sh

~/deploy.sh #run deployment to start downloading everything
