#!/bin/bash
echo Load Variables
cp .env.template .env
source .env
echo Restore DB
cp db/dump/content.dump.freeze db/dump/content.dump
bundle exec rake db:restore
bundle exec rake db:migrate
echo Preload es
bundle exec rake es:load
echo  Precompile Assets
source $HOME/.nvm/nvm.sh && bundle exec rake assets:precompile
echo Start worker for PDF/GDoc Generation
bundle exec rake resque:work
echo Start Server
bin/rails s