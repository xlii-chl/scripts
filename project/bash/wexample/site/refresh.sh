#!/usr/bin/env bash

siteRefresh() {
  # Update hosts list if IP changed.
  wex hosts/update
  # Update local host file.
  wex hosts/updateLocal
  # Refresh services (ex apache restart)
  wex service/exec -c=refresh -nw
}