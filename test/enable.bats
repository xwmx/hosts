#!/usr/bin/env bats

load test_helper

# `hosts enable` ##############################################################

@test "\`enable\` with no arguments exits with status 1." {
  run "${_HOSTS}" enable
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`enable\` with no argument does not change the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" enable
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`enable\` with no arguments prints help information." {
  run "${_HOSTS}" enable
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts enable (<ip> | <hostname> | <search string>)" ]]
}

# `hosts enable <ip>` #########################################################

@test "\`enable <ip>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 127.0.0.2
  }

  run "${_HOSTS}" enable 127.0.0.2
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`enable <ip>\` updates the hosts file." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
    run "${_HOSTS}" disable 127.0.0.2
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" enable 127.0.0.2
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.net" ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "127.0.0.2	example.com" ]]
}

@test "\`enable <ip>\` enables all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
    run "${_HOSTS}" disable 127.0.0.2
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" enable 0.0.0.0
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare \
    "${_original}" \
    "$(cat "${HOSTS_PATH}")"
  _compare \
    "'0.0.0.0	example.com'" \
    "'$(sed -n '11p' "${HOSTS_PATH}")'"
  _compare \
    "'0.0.0.0	example.net'" \
    "'$(sed -n '12p' "${HOSTS_PATH}")'"
  _compare \
    "'#disabled: 127.0.0.2	example.com'" \
    "'$(sed -n '13p' "${HOSTS_PATH}")'"

  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "0.0.0.0	example.net" ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "#disabled: 127.0.0.2	example.com" ]]
}

@test "\`disable <ip>\` prints feedback." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 127.0.0.2
  }

  run "${_HOSTS}" enable 127.0.0.2
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Enabling:" ]]
  [[ "${lines[1]}" == "127.0.0.2	example.com" ]]
}

# `hosts enable <hostname>` ###################################################

@test "\`enable <hostname>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" enable example.net
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`enable <hostname>\` updates the hosts file." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" enable example.net
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "0.0.0.0	example.net" ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "127.0.0.2	example.com" ]]
}

@test "\`enable <hostname>\` enables all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
    run "${_HOSTS}" disable 127.0.0.2
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "${_HOSTS}" enable example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _compare \
    "${_original}" \
    "$(cat "${HOSTS_PATH}")"
  _compare \
    "'0.0.0.0	example.com'" \
    "'$(sed -n '11p' "${HOSTS_PATH}")'"
  _compare \
    "'#disabled: 0.0.0.0	example.net'" \
    "'$(sed -n '12p' "${HOSTS_PATH}")'"
  _compare \
    "'127.0.0.2	example.com'" \
    "'$(sed -n '13p' "${HOSTS_PATH}")'"

  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.net" ]]
  [[ "$(sed -n '13p' "${HOSTS_PATH}")" == "127.0.0.2	example.com" ]]
}

@test "\`disable <hostname>\` prints feedback." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" enable example.net
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Enabling:" ]]
  [[ "${lines[1]}" == "0.0.0.0	example.net" ]]
}

# help ########################################################################

@test "\`help enable\` exits with status 0." {
  run "${_HOSTS}" help enable
  [[ ${status} -eq 0 ]]
}

@test "\`help enable\` prints help information." {
  run "${_HOSTS}" help enable
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts enable (<ip> | <hostname> | <search string>)" ]]
}
