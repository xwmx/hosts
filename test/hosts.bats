#!/usr/bin/env bats

load test_helper

@test "\`hosts\` with no arguments exits with status 0." {
  run "${_HOSTS}"
  [ "${status}" -eq 0 ]
}

@test "\`hosts\` with no arguments prints enabled rules." {
  run "${_HOSTS}"
  [[ "${#lines[@]}" -eq 4 ]]
  [[ "${lines[0]}" =~ 127.0.0.1[[:space:]]+localhost ]]
  [[ "${lines[1]}" =~ 255.255.255.255[[:space:]]+broadcasthost ]]
  [[ "${lines[2]}" =~ \:\:1[[:space:]]+localhost ]]
  [[ "${lines[3]}" =~ fe80\:\:1\%lo0[[:space:]]+localhost ]]
  [[ "${lines[4]}" == "" ]]
}
