cd $STACK_PATH
sudo npm install > /tmp/npm.log 2>&1
sudo chown -R ubuntu $STACK_PATH/node_modules
sudo chgrp -R ubuntu $STACK_PATH/node_modules
sudo chown -R ubuntu /home/ubuntu/.npm
sudo chgrp -R ubuntu /home/ubuntu/.npm
