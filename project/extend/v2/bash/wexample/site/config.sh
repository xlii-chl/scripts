#!/usr/bin/env bash

siteConfigArgs() {
  _ARGUMENTS=(
    [0]='key k "Key of config param to get" true'
    [1]='dir_site d "Root site directory" false'
  )
}

siteConfig() {
  if [ -z "${DIR_SITE+x}" ]; then
    DIR_SITE=./
  fi;

  . .wex

  # Uppercase key.
  KEY=$(echo ${KEY} | tr '[:lower:]' '[:upper:]')

  eval 'echo ${'${KEY}'}'
}
