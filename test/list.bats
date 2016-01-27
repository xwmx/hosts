#!/usr/bin/env bats

load test_helper

# `hosts list` #############################################################

@test "\`list\` exits with status 0." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
    run "$_HOSTS" add 127.0.0.2 example.com
    run "$_HOSTS" disable 0.0.0.0
  }

  run "$_HOSTS" list
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`list\` prints lists of enabled and disabled records." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
    run "$_HOSTS" add 127.0.0.2 example.com
    run "$_HOSTS" disable 0.0.0.0
  }

  run "$_HOSTS" list
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  _expected="\
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
fe80::1%lo0	localhost
127.0.0.2	example.com

Disabled:
0.0.0.0	example.com
0.0.0.0	example.net"
  _compare "'$_expected'" "'$output'"
  [[ "$output" == "$_expected" ]]
}

# help ########################################################################

@test "\`help list\` exits with status 0." {
  run "$_HOSTS" help list
  [[ $status -eq 0 ]]
}

@test "\`help list\` prints help information." {
  run "$_HOSTS" help list
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts list [enabled | disabled | <search string>]" ]]
}
