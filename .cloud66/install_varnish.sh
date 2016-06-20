echo "Installing varnish"

curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add -
echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0" > /etc/apt/sources.list.d/varnish-cache.list
apt-get update -y
apt-get install varnish -y

echo "Copying varnish configuration"

cp $STACK_PATH/.cloud66/varnish/default.vcl /etc/varnish/default.vcl
cp $STACK_PATH/.cloud66/varnish/varnish.service /etc/default/varnish

echo "Restarting varnish"
service varnish restart
