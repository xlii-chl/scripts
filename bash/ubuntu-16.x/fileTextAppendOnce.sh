#!/usr/bin/env bash

fileTextAppendOnce() {
  FILE=${1}
  LINE=${2}
  findExactLine=$(wexample fileLineExists ${FILE} "${LINE}")

  if [ "${findExactLine}" != true ]; then
    wexample fileTextAppend "$@"
  fi
}