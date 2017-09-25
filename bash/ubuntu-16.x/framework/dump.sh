#!/usr/bin/env bash

frameworkDumpArgs() {
  _ARGUMENTS=(
    [0]='dump_dir d "Target directory for dumps" true'
    [1]='prefix px "Prefix for final file" false'
    [2]='zip zip "Use ZIP" false'
    [3]='zip_only zo "Remove original file after ZIP it" false'
    [4]='host H "Database host server" false'
    [5]='port P "Database host port" false'
    [6]='database db "Database name" false'
    [7]='user u "Database username" false'
    [8]='password p "Database password" false'
  )
}

frameworkDump() {

  # Get database connexion global settings.
  wex framework/settings ${SITE_DIR}

  # Get locally defined settings if not defined.
  if [[ -z "${HOST+x}" ]]; then
    HOST=${WEBSITE_SETTINGS_HOST}
  fi;

  if [[ -z "${PORT+x}" ]]; then
    PORT=${WEBSITE_SETTINGS_PORT}
  fi;

  if [[ -z "${DATABASE+x}" ]]; then
    DATABASE=${WEBSITE_SETTINGS_DATABASE}
  fi;

  if [[ -z "${USER+x}" ]]; then
    USER=${WEBSITE_SETTINGS_USERNAME}
  fi;

  if [[ -z "${PASSWORD+x}" ]]; then
    PASSWORD=${WEBSITE_SETTINGS_PASSWORD}
  fi;

  # Add -p option only if password is defined and not empty.
  # Adding empty password will prompt user instead.
  if [ "${PASSWORD}" != "" ]; then
    PASSWORD=-p"${PASSWORD}"
  fi;

  # Build dump name.
  DUMP_FILE_NAME=${PREFIX}${DATABASE}"-"$(wex date/timeFileName)".sql"
  DUMP_FULL_PATH=${DUMP_DIR}"/"${DUMP_FILE_NAME}

  mysqldump -h${HOST} -P${PORT} -u${USER} ${PASSWORD} ${DATABASE} > ${DUMP_FULL_PATH}

  if [[ ${ZIP} == true ]]; then
    zip ${DUMP_FULL_PATH}".zip" ${DUMP_FULL_PATH} -q -j

    # Expect only zipped file
    # Remove original.
    if [[ ! -z "${ZIP_ONLY+x}" ]]; then
      rm -rf ${DUMP_FULL_PATH}
      # Return the zipped file name.
      echo ${DUMP_FULL_PATH}".zip"
      return
    fi;
  fi

  # Return dump file name.
  echo ${DUMP_FULL_PATH}
}