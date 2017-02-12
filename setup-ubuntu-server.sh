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
sudo npm install -s apn dotenv

###install and setup nginx
sudo add-apt-repository ppa:nginx/stable
sudo apt-get update
sudo apt-get install nginx-light

sudo wget $nginx_config -O /etc/nginx/sites-available/soulcast.ml.conf
sudo ln -s /etc/nginx/sites-available/soulcast.ml.conf /etc/nginx/sites-enabled/soulcast.ml.conf
sudo rm /etc/nginx/sites-enabled/default

###add ssl support
wget https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated
chmod +x dehydrated
mkdir /etc/dehydrated

echo 'WELLKNOWN="/home/ubuntu/soulcast.ml/soulcast-server/public/.well-known/acme-challenge"
CONTACT_EMAIL="admin@soulcast.ml"
' > /etc/dehydrated/config

echo "soulcast.ml" > /etc/dehydrated/domains.txt

@monthly /usr/bin/letsencrypt.sh -c
sudo service nginx start


###install postgres #libpq-dev for pg gem
sudo apt-get install postgresql libpq-dev
sudo -u postgres createuser -s soulcast
sudo -u postgres psql
echo "\password soulcast\nsoulcastpass\nsoulcastpass\n\q\n"

#for arch
sudo pacman -S postgresql
sudo -H -u postgres bash -c "initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'"
#sudo -u postgres -i
#initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'
systemctl start postgresql.service

#for apple users
brew install postgresql nodejs
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
createuser -s soulcast
psql -d postgres
npm install -s apn

###this installs RVM and Rails
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
gem install rails puma pg

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
rails db:reset RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1
rails assets:clobber RAILS_ENV=production
rails assets:precompile RAILS_ENV=production

#make new tmux session for running 'rails server'
tmux new -d -c ~/soulcast.domain/soulcast-server -s rails_server 'pumactl start'
tmux new -s rails-server -c ~/soulcast.domain/soulcast-server" > ~/deploy.sh

~/deploy.sh #run deployment to start downloading everything
