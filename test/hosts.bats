#!/usr/bin/env bats

load test_helper

@test "when passed no arguments exit with status 0" {
  run "$_HOSTS"
  [ "$status" -eq 0 ]
}

@test "when passed no arguments print enabled rules." {
  run "$_HOSTS"
  [[ "${lines[0]}" == "127.0.0.1	localhost" ]]
  [[ "${lines[1]}" == "255.255.255.255	broadcasthost" ]]
  [[ "${lines[2]}" == "::1             localhost" ]]
  [[ "${lines[3]}" == "fe80::1%lo0	localhost" ]]
  [[ "${lines[4]}" == "" ]]
}
