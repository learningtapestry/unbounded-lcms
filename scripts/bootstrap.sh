#! /bin/bash

# PROVISIONING SCRIPT

sudo apt-get -y update
sudo apt-get -y upgrade

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl vim htop openjdk-7-jre openjdk-7-jdk libxslt1.1 build-essential libtool checkinstall libxml2-dev python-pip python-dev gcc make sqlite3 fontconfig imagemagick libcurl4-openssl-dev ruby-dev libssl-dev openssl libreadline-dev phantomjs

# setup git
echo "-- SETUP GIT"
sudo apt-get install -y git
git config --global color.ui true

# setup rbenv
echo "-- SETUP RBENV"
git clone git://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# setup ruby-build
echo "-- SETUP RUBY-BUILD"
git clone git://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build

# setup ruby
echo "-- SETUP RUBY"
source /home/vagrant/.bashrc
rbenv install 2.1.5
rbenv global 2.1.5
rbenv rehash
gem install bundler

# setup nvm
echo "-- SETUP NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
export NVM_DIR="/home/vagrant/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# setup nodejs
echo "-- SETUP NODE.JS"
nvm install 5.6
nvm use 5.6

# setup redis
echo "-- SETUP REDIS"
sudo apt-get install -y redis-server

# setup elasticsearch
echo "-- SETUP ELASTICSEARCH"
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
sudo apt-get -y update && sudo apt-get -y install elasticsearch
update-rc.d elasticsearch defaults
sudo service elasticsearch start

# setup postgresql
echo "-- SETUP POSTGRES"
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" | sudo tee -a /etc/apt/sources.list.d/pgdg.list
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc |  sudo apt-key add -
sudo apt-get update

sudo apt-get install -y postgresql-9.4 postgresql-server-dev-9.4 postgresql-contrib postgresql-client-9.4

sudo -u postgres createuser -r -s -d vagrant
sudo -u postgres createdb vagrant -O vagrant
sudo -u postgres createdb unbounded_development -O vagrant
sudo -u postgres createdb unbounded_test -O vagrant
sudo -u postgres psql -c "ALTER USER vagrant WITH PASSWORD 'vagrant';"
sudo -u postgres psql -c "ALTER USER vagrant SUPERUSER;"

echo "-- LINK PROJECT"
cd /home/vagrant/
ln -s /vagrant /home/vagrant/unbounded

echo "-- SETUP PROJECT"

cat << EOF > /home/vagrant/unbounded/.env
ELASTICSEARCH_ADDRESS=http://localhost:9200
POSTGRESQL_DATABASE=unbounded
POSTGRESQL_USERNAME=vagrant
POSTGRESQL_PASSWORD=vagrant
EOF

echo 'POSTGRESQL_DATABASE=unbounded_development' > /home/vagrant/unbounded/.env.development
echo 'POSTGRESQL_DATABASE=unbounded_test' > /home/vagrant/unbounded/.env.test

cd /home/vagrant/unbounded
bundle config --delete bin
bundle
bundle exec rake cloud66:after_bundle
npm i && npm run build

cp db/dump/content.dump.freeze db/dump/content.dump
RAILS_ENV=development bundle exec rake db:restore
RAILS_ENV=integration bundle exec rake db:restore
