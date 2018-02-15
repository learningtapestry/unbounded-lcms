#!/usr/bin/env bash

# Disable "Shellcheck" checks until workaround will be found
# https://github.com/koalaman/shellcheck/issues/1119

# checking shell scripts
# shellcheck disable=SC2044
#for file in $(find . -name "*.sh"); do
#  if [[ "${file}" != *node_modules* ]]; then
#    if ! shellcheck "${file}"; then
#      exit 1
#    fi
#  fi
#done

# Checking gems for vulnerabilities
bundler audit check --update

# Checking Security with Brakeman
brakeman -zqA --summary --no-pager

# Setup environment
echo -e 'UNBOUNDED_DOMAIN=unbounded.org' > .env
cp .codeship/database.yml config/database.yml

# Changing port to use PostgreSQL 9.6
sed -i "s|5434|5436|" "config/database.yml"

# Restore integration database
cp db/dump/content.dump.freeze db/dump/content.dump
RAILS_ENV="integration" bundle exec rake db:restore
RAILS_ENV="test" bundle exec rake db:migrate

# Generate translations file
bundle exec rake i18n:js:export

# Installing fresh PhantomJS
curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/phantomjs.sh | bash -s

# Precompiles assets for faster tests
RAILS_ENV="test" bundle exec rake assets:precompile
