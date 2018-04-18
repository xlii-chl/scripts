#!/usr/bin/env bash

configWriteArgs() {
  _ARGUMENTS=(
    [0]='started s "Set the site is started or not" false'
    [1]='no_recreate nr "No recreate if files exists" false'
  )
}


configWrite() {

  # No recreate.
  if [ "${NO_RECREATE}" == true ] &&
    [[ -f ${WEX_WEXAMPLE_SITE_DIR_TMP}config ]] &&
    [[ -f ${WEX_WEXAMPLE_SITE_COMPOSE_BUILD_YML} ]];then
    return
  fi

  # Create temp dirs if not exists.
  mkdir -p ${WEX_WEXAMPLE_DIR_TMP}
  mkdir -p ${WEX_WEXAMPLE_SITE_DIR_TMP}

  if [ "${STARTED}" != true ];then
    # Default space separator
    STARTED=false
  fi;

  # Get site name from wex.json.
  local SITE_NAME=$(wex site/config -k=name)
  local SITE_CONFIG_FILE=""
  local SITE_PATH=$(realpath ./)"/"
  SITE_CONFIG_FILE+="\nSITE_NAME="${SITE_NAME}
  SITE_CONFIG_FILE+="\nSITE_DOMAIN="$(wex site/domains -s=",")
  SITE_CONFIG_FILE+="\nSTARTED="${STARTED}

  local SITES_PATHS=$(cat ${WEX_WEXAMPLE_DIR_PROXY_TMP}sites)
  local FINAL_SITE_PORT_RANGE=0
  local FINAL_SITE_PORT_RANGE_FOUND=false

  # Ports
  for RANGE in $(seq 0 9); do
    # Port range still not found
    if [ "${FINAL_SITE_PORT_RANGE_FOUND}" == false ];then
      USED=false

      # Search into all sites
      for SITE_PATH in ${SITES_PATHS[@]}
      do
        # Config file exists
        if [[ -f ${SITE_PATH}${WEX_WEXAMPLE_SITE_CONFIG} ]];then
          # Load config
          . ${SITE_PATH}${WEX_WEXAMPLE_SITE_CONFIG}
          if [[ ${SITE_PORT_RANGE} == ${FINAL_SITE_PORT_RANGE} ]];then
            USED=true
          fi
        fi
      done

      if [ "${USED}" == false ];then
        # Port range found
        FINAL_SITE_PORT_RANGE_FOUND=true
      else
        # Search next one.
        ((FINAL_SITE_PORT_RANGE++))
      fi
    fi
  done;

  # Save in config.
  SITE_CONFIG_FILE+="\nSITE_PORT_RANGE="${FINAL_SITE_PORT_RANGE}

  local FINAL_SITE_PORT_RANGE_STOP=100
  local LOCAL_COUNTER=10
  local LOCAL_COUNTER_VAR=0
  while [ ${LOCAL_COUNTER} -lt ${FINAL_SITE_PORT_RANGE_STOP} ]; do
    local VAR_NAME="WEX_COMPOSE_PORT_"${LOCAL_COUNTER_VAR}
    # Use a common range.
    local PORT=8${FINAL_SITE_PORT_RANGE}${LOCAL_COUNTER}
    # One Up
    ((LOCAL_COUNTER++))
    ((LOCAL_COUNTER_VAR++))
    # Add to registry.
    SITE_CONFIG_FILE+="\n"${VAR_NAME}"="${PORT}
  done

  # Execute services scripts if exists
  local CONFIG=$(wex service/exec -c="config")
  SITE_CONFIG_FILE+=${CONFIG[@]}
  # Sync images versions to wex.
  SITE_CONFIG_FILE+="\nWEX_IMAGES_VERSION="$(wex wex/version)

  # Save param file.
  echo -e ${SITE_CONFIG_FILE} > ${WEX_WEXAMPLE_SITE_DIR_TMP}config

  # Create docker-compose.build.yml
  wex site/compose -c="config" > ${WEX_WEXAMPLE_SITE_COMPOSE_BUILD_YML}
}