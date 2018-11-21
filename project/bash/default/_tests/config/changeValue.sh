#!/usr/bin/env bash

configChangeValueTest() {

  filePath=$(wexTestSampleInit configSample)
echo wex config/getValue -f="${filePath}" -k="ConfigTestOption"
return
  noSeparator=$(wex config/getValue -f="${filePath}" -k="ConfigTestOption")
  wexTestAssertEqual ${noSeparator} "two"

  # Space separator
  configChangeValueTestItem ${filePath} "ConfigTestOption" " "

  # Strict equal separator
  configChangeValueTestItem ${filePath} "ConfigTestOptionEqual" "="

  # Revert file.
  filePath=$(wexTestSampleInit configSample)

  configChangeValueTestItem ${filePath} "ChallengeResponseAuthentication"

  filePath=$(wexTestSampleInit sshd_config)
  configChangeValueTestItem ${filePath} Port " "
}

configChangeValueTestItem() {
  filePath=${1}
  variableName=${2}
  separator=${3}
  testValue="tested"

  # Backup
  original=$(wex config/getValue -f="${filePath}" -k="${variableName}" -s="${separator}")

  # Set value.
  wex config/changeValue -f=${filePath} -k=${variableName} -v="${testValue}" -s="${separator}"
  # Get value
  changed=$(wex config/getValue -f="${filePath}" -k="${variableName}" -s="${separator}")
  # Check
  wexTestAssertEqual ${changed} "${testValue}"

  # Revert
  wex config/changeValue -f=${filePath} -k=${variableName} -v="${original}" -s="${separator}"
  # Get value
  changed=$(wex config/getValue -f="${filePath}" -k="${variableName}" -s="${separator}")
  # Check
  wexTestAssertEqual ${changed} "${original}"
}
