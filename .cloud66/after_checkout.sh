cd $STACK_PATH
npm set color=false
npm set progress=false
npm set loglevel=error
npm install

chgrp -R ubuntu node_modules
chown -R ubuntu node_modules
chmod -R 775 node_modules
chmod -R g+s node_modules

chgrp -R ubuntu /home/ubuntu/.npm
chown -R ubuntu /home/ubuntu/.npm
chmod -R 775 /home/ubuntu/.npm
chmod -R g+s /home/ubuntu/.npm
