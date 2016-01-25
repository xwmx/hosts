#!/usr/bin/env bats

load test_helper

@test "\`file\` exits with status 0." {
  run "$_HOSTS" file
  [ "$status" -eq 0 ]
}

@test "\`file\` prints \$HOSTS_PATH contents." {
  run "$_HOSTS" file
  [[ "$output" == "$(cat $HOSTS_PATH)" ]]
}
