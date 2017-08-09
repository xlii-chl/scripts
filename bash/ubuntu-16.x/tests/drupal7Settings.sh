#!/usr/bin/env bash

drupal7SettingsTest() {
  WEBSITE_SETTINGS_DATABASE=false
  WEBSITE_SETTINGS_USERNAME=false
  WEBSITE_SETTINGS_PASSWORD=false
  wexample drupal7Settings ${_TEST_RUN_DIR_SAMPLES}drupal7/sites/default/settings.php
  # Eval response variables.
  wexampleTestAssertEqual ${WEBSITE_SETTINGS_DATABASE} "mysqlTestDataBase"
  wexampleTestAssertEqual ${WEBSITE_SETTINGS_USERNAME} "mysqlTestUserName"
  wexampleTestAssertEqual ${WEBSITE_SETTINGS_PASSWORD} "mysqlTestPassword"
}
