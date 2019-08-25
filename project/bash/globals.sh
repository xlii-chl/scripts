#!/usr/bin/env bash

WEX_DIR_BASH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/
WEX_DIR_ROOT=$(dirname ${WEX_DIR_BASH})"/"
WEX_DIR_INSTALL=$(dirname ${WEX_DIR_ROOT})"/"

export WEX_CORE_VERSION=3
export WEX_DIR_BASH
export WEX_DIR_ROOT
export WEX_DIR_INSTALL
export WEX_DIR_EXTEND=${WEX_DIR_ROOT}extend/
export WEX_NAMESPACE_DEFAULT="default"
export WEX_NAMESPACE_APP="app"
export BASHRC_PATH=~/.bashrc

_wexBashCheckVersion() {
  # Check bash version.
  if [ -z ${WEX_BASH_VERSION+x} ]; then
    WEX_BASH_VERSION_MIN='4'
    WEX_BASH_VERSION=$(sed -n "s/\([[:digit:]]\{0,\}\)\([\.].\{0,\}\)/\1/p" <<< ${BASH_VERSION})
    if [ ${WEX_BASH_VERSION} -lt ${WEX_BASH_VERSION_MIN} ]; then
      _wexError "Wex error, need to run on bash version "${WEX_BASH_VERSION_MIN} "Your current version is ${WEX_BASH_VERSION}"
      exit
    fi;
  fi;
}

_wexError() {
  . ${WEX_DIR_BASH}/colors.sh
  printf "${WEX_COLOR_RED}[wex] Error : ${1}${WEX_COLOR_RESET}\n"

  # Complementary information or description for extra text
  if [ "${2}" != "" ];then
    printf "      ${WEX_COLOR_CYAN}${2}${WEX_COLOR_RESET}\n"
  fi

  # Extra text
  if [ "${3}" != "" ];then
    printf "      ${3}\n"
  fi
}

# Used both in core and autocomplete
_wexFindNamespace() {
  export WEX_NAMESPACE_TEST=
  # Allow specified context.
  if [[ ${1} == *"::"* ]]; then
    SPLIT=($(echo ${1}| tr ":" "\n"))
    export WEX_NAMESPACE_TEST=${SPLIT[0]}
    export WEX_SCRIPT_CALL_NAME=${SPLIT[1]}
  # Check if we are on a "wexample" context (.wex file in calling folder).
  elif [ -f ${PWD}"/.wex" ]; then
    export WEX_NAMESPACE_TEST=${WEX_NAMESPACE_APP}
  fi;
}

_wexFindScriptFile() {
  export WEX_SCRIPT_DIR=${WEX_DIR_BASH}${WEX_NAMESPACE_TEST}/${WEX_SCRIPT_CALL_NAME}
  export WEX_SCRIPT_FILE=${WEX_SCRIPT_DIR}.sh
  export WEX_SCRIPT_METHOD_NAME=$(_wexMethodName ${WEX_SCRIPT_CALL_NAME})
  export WEX_SCRIPT_METHOD_ARGS_NAME=${WEX_SCRIPT_METHOD_NAME}"Args";

  # Use main script if still not exists.
  if [ -f ${WEX_SCRIPT_FILE} ] || [ -d ${WEX_SCRIPT_DIR} ]; then
    export WEX_NAMESPACE=${WEX_NAMESPACE_TEST}
  else
    export WEX_NAMESPACE=${WEX_NAMESPACE_DEFAULT}
    # Search into wexample local folder.
    export WEX_SCRIPT_FILE=${WEX_DIR_BASH}${WEX_NAMESPACE_DEFAULT}/${WEX_SCRIPT_CALL_NAME}.sh
  fi;

  # Load namespace init file.
  . "${WEX_DIR_BASH}${WEX_NAMESPACE}/init.sh"
}

_wexMessage() {
  . ${WEX_DIR_BASH}/colors.sh
  printf "${WEX_COLOR_YELLOW}[wex] ${1}${WEX_COLOR_RESET}\n"

  # Complementary information or description for extra text
  if [ "${2}" != "" ];then
    printf "      ${WEX_COLOR_CYAN}${2}${WEX_COLOR_RESET}\n"
  fi

  # Extra text
  if [ "${3}" != "" ];then
    printf "      ${3}\n"
  fi
}

_wexMethodName() {
  local SPLIT=(${1//// })
  echo ${SPLIT[0]}$(_wexUpperCaseFirstLetter ${SPLIT[1]})
}

_wexUpperCaseFirstLetter() {
  echo $(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}
}

_wexBashCheckVersion