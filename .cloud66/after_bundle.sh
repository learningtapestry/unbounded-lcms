curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g npm@latest
cd $STACK_PATH
test -f package.json && sudo -u ubuntu npm install
