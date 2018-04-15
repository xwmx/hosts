#!/usr/bin/env bats

load test_helper

# `hosts enabled` #############################################################

@test "\`enabled\` with no arguments exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`enabled\` with no arguments prints list of enabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "127.0.0.1	localhost" ]]
  [[ "${lines[1]}" == "255.255.255.255	broadcasthost" ]]
  [[ "${lines[2]}" == "::1             localhost" ]]
  [[ "${lines[3]}" == "fe80::1%lo0	localhost" ]]
  [[ "${lines[4]}" == "127.0.0.2	example.com" ]]
}

# help ########################################################################

@test "\`help enabled\` exits with status 0." {
  run "${_HOSTS}" help enabled
  [[ ${status} -eq 0 ]]
}

@test "\`help enabled\` prints help information." {
  run "${_HOSTS}" help enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts enabled" ]]
}
