#!/usr/bin/env bash

bashAddToPath() {
  command="export PATH=${1}"
  # Add now.
  eval ${command}
  # Add to path.
  ${WEX_DIR_CURRENT}wexample.sh fileTextAppend ~/.bashrc ${command}
}