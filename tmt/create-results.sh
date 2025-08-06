#!/bin/bash
set -euo pipefail

cd "$TMT_TEST_DATA"

cp "$TMT_TREE/tests/playwright/output/junit-results.xml" .

if [ "$1" -eq 0 ]; then 
  cat <<EOF > ./results.yaml
- name: /tests/$2
  result: pass
  note: 
    - "Playwright end-to-end tests completed successfully."
  log:
    - ../output.txt
    - junit-results.xml
EOF

elif [ "$1" -eq 255 ]; then

  if [ -d "$TMT_TREE/tests/playwright/output/traces" ]; then
    cp -r "$TMT_TREE/tests/playwright/output/traces" .
  fi

  if [ -d "$TMT_TREE/tests/playwright/output/videos" ]; then 
    cp -r "$TMT_TREE/tests/playwright/output/videos" .
  fi

  cat <<EOF > ./results.yaml
- name: /tests/$2
  result: fail
  note: 
    - "Playwright tests failed."
  log:
    - ../output.txt
    - junit-results.xml
    - videos
    - traces
EOF

else
  echo "Unexpected exit code: $1"
  exit 1
fi
