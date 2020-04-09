#!/usr/bin/env bats

load test_helper

# `hosts remove` #################################################################

@test "\`remove\` with no arguments exits with status 1." {
  run "${_HOSTS}" remove
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`remove\` with no argument does not change the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" remove
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`remove\` with no arguments prints help information." {
  run "${_HOSTS}" remove
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts remove (<ip> | <hostname> | <search string>) [--force]" ]]
}

# `hosts remove <invalid> --force` ############################################

@test "\`remove <invalid> --force\` exits with status 1." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }

  run "${_HOSTS}" remove 127.0.0.3 --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`remove <invalid> --force\` prints error message." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }

  run "${_HOSTS}" remove 127.0.0.3 --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${output} == "No matching records found." ]]
}

# `hosts remove <ip> --force` #################################################

@test "\`remove <ip> --force\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }

  run "${_HOSTS}" remove 127.0.0.2 --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`remove <ip> --force\` updates the hosts file." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" remove 127.0.0.2 --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" =~ 0.0.0.0[[:space:]]+example.com ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" =~ 0.0.0.0[[:space:]]+example.net ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "" ]]
}

@test "\`remove <ip>\` removes all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 0.0.0.0 example.dev
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable example.dev
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" remove 0.0.0.0 --force
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
127.0.0.2	example.com"
  _compare "'${_expected}'" "'$(cat "${HOSTS_PATH}")'"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(cat "${HOSTS_PATH}")" == "${_expected}" ]]
}

@test "\`remove <ip>\` prints feedback." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }

  run "${_HOSTS}" remove 127.0.0.2 --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Removed:" ]]
  [[ "${lines[1]}" =~ 127.0.0.2[[:space:]]+example.com ]]
}

# `hosts remove <hostname> --force` ###########################################

@test "\`remove <hostname> --force\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }

  run "${_HOSTS}" remove example.com --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`remove <hostname> --force\` updates the hosts file." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" remove example.com --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" =~ 0.0.0.0[[:space:]]+example.net ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "" ]]
}

@test "\`remove <hostname>\` removes all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 0.0.0.0 example.dev
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable example.dev
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" remove example.com --force
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
0.0.0.0		example.net
#disabled: 0.0.0.0		example.dev"
  _compare "'${_expected}'" "'$(cat "${HOSTS_PATH}")'"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(cat "${HOSTS_PATH}")" == "${_expected}" ]]
}

@test "\`remove <hostname>\` prints feedback." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
  }

  run "${_HOSTS}" remove example.com --force
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
Removed:
0.0.0.0		example.com
127.0.0.2	example.com"
  [[ "${output}" == "${_expected}" ]]
}

# help ########################################################################

@test "\`help remove\` exits with status 0." {
  run "${_HOSTS}" help remove
  [[ ${status} -eq 0 ]]
}

@test "\`help remove\` prints help information." {
  run "${_HOSTS}" help remove
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts remove (<ip> | <hostname> | <search string>) [--force]" ]]
}
