#!/usr/bin/env bash

laravel5Install() {
  . .env
  . .wex

  local STARTED=$(wex site/started)

  if [ ${STARTED} != true ];then
    wex site/start
  fi

  # Composer install
  wex site/exec -l -c="composer install"

  # Yarn
  local OPTION=""
  if [ "${SITE_ENV}" = "prod" ];then
    OPTION="--production"
  fi;
  wex site/exec -l -c="yarn install "${OPTION}

  # Encore.
  if [ "${SITE_ENV}" = "dev" ] && [ $(wex site/exec -c="wex file/exists -f=/var/www/html/project/node_modules/.bin/encore") == true ];then
    wex site/exec -l -c="yarn run encore dev"
  fi

#  # Copy .env file.
#  if [ ! -f ./project/.env ];then
#    cp ./project/.env.example ./project/.env
#  fi

#  . ${WEX_WEXAMPLE_SITE_CONFIG}

# TODO wex site/install should run on already installed instance, create wex site/configure instead.

#  wex site/exec -l -c="php artisan key:generate"

#  # Fill up laravel file with db URL
#  # TODO Don't work properly
#  wex config/setValue -f=./project/.env -s="=" -k=DB_HOST -v="${SITE_NAME_INTERNAL}_mysql"
#  wex config/setValue -f=./project/.env -s="=" -k=DB_PORT -v=3306
#  wex config/setValue -f=./project/.env -s="=" -k=DB_DATABASE -v=${NAME}
#  wex config/setValue -f=./project/.env -s="=" -k=DB_USERNAME -v=root
#  wex config/setValue -f=./project/.env -s="=" -k=DB_PASSWORD -v=${MYSQL_PASSWORD}

  # Rebuild and clear caches.
  wex site/build

  # Give site perms
  wex site/perms

  # Stop site if not already running.
  if [ ${STARTED} != true ];then
    wex site/stop
  fi
}