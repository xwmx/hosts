#!/usr/bin/env bats

load test_helper

# `hosts unblock` #############################################################

@test "\`unblock\` with no arguments exits with status 1." {
  run "${_HOSTS}" unblock
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`unblock\` with no argument does not change the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" unblock
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`unblock\` with no arguments prints help information." {
  run "${_HOSTS}" unblock
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts unblock <hostname>..." ]]
}

# `hosts unblock <invalid>` ###################################################

@test "\`unblock <invalid> \` exits with status 1." {
  {
    run "${_HOSTS}" block example.com
  }

  run "${_HOSTS}" unblock example.net
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`unblock <invalid>\` prints error message." {
  {
    run "${_HOSTS}" block example.com
  }

  run "${_HOSTS}" unblock example.net
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${output} == "${_ERROR_PREFIX}No matching records found." ]]
}

# `hosts unblock <hostname>` ##################################################

@test "\`unblock <hostname>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }

  run "${_HOSTS}" unblock example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`unblock <hostname>\` updates the hosts file." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" unblock example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "0.0.0.0		example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "127.0.0.1	example.net" ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "" ]]
}

@test "\`unblock <hostname>\` removes all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" unblock example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
fe80::1%lo0	localhost
0.0.0.0		example.com
127.0.0.1	example.net"
  _compare "'${_expected}'" "'$(cat "${HOSTS_PATH}")'"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(cat "${HOSTS_PATH}")" == "${_expected}" ]]
}

@test "\`unblock <hostname>\` prints feedback." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }

  run "${_HOSTS}" unblock example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
Removed:
127.0.0.1	example.com
Removed:
fe80::1%lo0	example.com
Removed:
::1		example.com"
  [[ "${output}" == "${_expected}" ]]
}

# `hosts unblock <hostname> <hostname2>` ######################################

@test "\`unblock <hostname> <hostname2>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" block example2.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }

  run "${_HOSTS}" unblock example.com example2.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`unblock <hostname> <hostname2>\` updates the hosts file." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" block example2.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" unblock example.com example2.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "0.0.0.0		example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "127.0.0.1	example.net" ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "" ]]
}

@test "\`unblock <hostname> <hostname2>\` removes all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" block example2.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" unblock example.com example2.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
fe80::1%lo0	localhost
0.0.0.0		example.com
127.0.0.1	example.net"
  _compare "'${_expected}'" "'$(cat "${HOSTS_PATH}")'"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(cat "${HOSTS_PATH}")" == "${_expected}" ]]
}

@test "\`unblock <hostname> <hostname2>\` prints feedback." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" block example.com
    run "${_HOSTS}" block example2.com
    run "${_HOSTS}" add 127.0.0.1 example.net
  }

  run "${_HOSTS}" unblock example.com example2.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
Removed:
127.0.0.1	example.com
Removed:
fe80::1%lo0	example.com
Removed:
::1		example.com
Removed:
127.0.0.1	example2.com
Removed:
fe80::1%lo0	example2.com
Removed:
::1		example2.com"
  _compare "'${output}'" "'${_expected}'"
  diff  <(echo "${output}" ) <(echo "${_expected}")
  [[ "${output}" == "${_expected}" ]]
}

# help ########################################################################

@test "\`help unblock\` exits with status 0." {
  run "${_HOSTS}" help unblock
  [[ ${status} -eq 0 ]]
}

@test "\`help unblock\` prints help information." {
  run "${_HOSTS}" help unblock
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts unblock <hostname>..." ]]
}
