#!/usr/bin/env bash
# bin/setup - Bootstrap script

set -e

if [ -f .env.local ]; then
  export $(cat .env.local | xargs)
fi

echo "== Installing dependencies =="
bundle check || bundle install

echo "== Installing JavaScript dependencies =="
yarn install --check-files

echo "== Setting up database =="
rails db:prepare

echo "== Compiling assets =="
rails assets:precompile

echo "== System ready! =="
echo "Run './bin/dev' to start the development server"
