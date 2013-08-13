#!/bin/bash
#
# Procedure for updating the production version
# Usage: sh deploy.sh <production|staging>
BRANCH=$1

git reset --hard
git checkout $BRANCH
git pull origin $BRANCH
rm -rf .bundle vendor/bundle
bundle install
bundle install --deployment
rake db:migrate RAILS_ENV=production
rake db:seed RAILS_ENV=production

chown -R www-data:www-data .
chmod -R 744 .