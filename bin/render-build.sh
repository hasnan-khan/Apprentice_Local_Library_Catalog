#!/usr/bin/env bash

set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Migrate all db
bundle exec rails db:prepare
# Specific 18-book seed for demo
bundle exec rails db:seed