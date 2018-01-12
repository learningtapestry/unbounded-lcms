#!/bin/bash

# prepare environment for services
export ENVFILE=/var/.cloud66-environment-variables
sed -e 's/^export //' < /var/.cloud66_env > $ENVFILE

DIR=$STACK_PATH/.cloud66/systemd/${RAILS_ENV:-$ENVIRONMENT}

for service in `ls -1 $DIR`; do
  # substitute environment variables in service definition
  envsubst < $DIR/$service > /etc/systemd/system/$service
  # reload systemd with updated definition and restart the service
  systemctl daemon-reload
  systemctl restart $service
done
