#!/usr/bin/env bats

load test_helper

# `hosts list` #############################################################

@test "\`list\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list\` prints lists of enabled and disabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  _expected="\
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
fe80::1%lo0	localhost
127.0.0.2	example.com

Disabled:
0.0.0.0	example.com
0.0.0.0	example.net"
  _compare "'${_expected}'" "'${output}'"
  [[ "${output}" == "${_expected}" ]]
}

# `hosts list enabled` ########################################################

@test "\`list enabled\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list enabled
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list enabled\` prints list of enabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list enabled
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ "${lines[0]}" == "127.0.0.1	localhost" ]]
  [[ "${lines[1]}" == "255.255.255.255	broadcasthost" ]]
  [[ "${lines[2]}" == "::1             localhost" ]]
  [[ "${lines[3]}" == "fe80::1%lo0	localhost" ]]
  [[ "${lines[4]}" == "127.0.0.2	example.com" ]]
}

# `hosts list disabled` #######################################################

@test "\`list disabled\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" list disabled
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list disabled\` prints list of disabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" list disabled
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.com" ]]
  [[ "${lines[1]}" == "127.0.0.1	example.com" ]]
  [[ "${lines[2]}" == "" ]]
}

# `hosts list <search string>` ################################################

@test "\`list <search string>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" list example.com
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list <search string>\` prints list of matching records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" list example.com
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.com" ]]
  [[ "${lines[1]}" == "127.0.0.1	example.com" ]]
  [[ "${lines[2]}" == "" ]]
}

# help ########################################################################

@test "\`help list\` exits with status 0." {
  run "${_HOSTS}" help list
  [[ ${status} -eq 0 ]]
}

@test "\`help list\` prints help information." {
  run "${_HOSTS}" help list
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts list [enabled | disabled | <search string>]" ]]
}
