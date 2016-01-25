#!/usr/bin/env bats

load test_helper

@test "\`file\` exits with status 0." {
  run "$_HOSTS" file
  [ "$status" -eq 0 ]
}

@test "\`file\` prints file contents." {
  run "$_HOSTS" file
  [[ "${lines[0]}" == "##" ]]
  [[ "${lines[1]}" == "# Host Database" ]]
  [[ "${lines[2]}" == "#" ]]
  [[ "${lines[3]}" == "# localhost is used to configure the loopback interface" ]]
  [[ "${lines[4]}" == "# when the system is booting.  Do not change this entry." ]]
  [[ "${lines[5]}" == "##" ]]
  [[ "${lines[6]}" == "127.0.0.1	localhost" ]]
  [[ "${lines[7]}" == "255.255.255.255	broadcasthost" ]]
  [[ "${lines[8]}" == "::1             localhost" ]]
  [[ "${lines[9]}" == "fe80::1%lo0	localhost" ]]
  [[ "${lines[10]}" == "" ]]
}
