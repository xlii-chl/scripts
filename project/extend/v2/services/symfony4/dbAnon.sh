#!/usr/bin/env bash

symfony4DbAnon() {
  # Change admin password
  wex site/exec -c="cd /var/www/html/project && php bin/console fos:user:change-password admin password"

  # Set same password for everyone,
  # using admin copy avoid escaping problems in query.
  wex db/exec -c="UPDATE user SET user.password = (SELECT password FROM (SELECT * FROM user as user3) as user2 WHERE user2.username = 'admin')"
}