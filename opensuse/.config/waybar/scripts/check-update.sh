#!/bin/bash

# Refresh and check for updates
updates=$(zypper --non-interactive --quiet refresh >/dev/null &&
  zypper --non-interactive --quiet list-updates | grep -E '^[a-zA-Z]' | awk '{print $3, $5}')

update_count=$(echo "$updates" | grep -v '^$' | wc -l)

alt="has-updates"
if [ "$update_count" -eq 0 ]; then
  alt="updated"
else
  tooltip=$(echo "$updates" | sed ':a;N;$!ba;s/\n/\\n/g')
fi

echo "{ \"text\": \"$update_count\", \"tooltip\": \"${tooltip:-No updates}\", \"alt\": \"$alt\" }"
