#!/usr/bin/env bats

load test_helper

# `hosts search` #############################################################

@test "\`search\` with no arguments exits with status 1." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" search
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`search\` with no arguments prints help information." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" search
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
Usage:
  hosts search <search string>

Description:
  Search entries for <search string>."
  _compare "'${_expected}'" "'${output}'"
  [[ "${output}" == "${_expected}" ]]
}

# `hosts search enabled` ######################################################

@test "\`search enabled\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" search enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`search enabled\` prints list of enabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" search enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "127.0.0.1	localhost" ]]
  [[ "${lines[1]}" == "255.255.255.255	broadcasthost" ]]
  [[ "${lines[2]}" == "::1             localhost" ]]
  [[ "${lines[3]}" == "fe80::1%lo0	localhost" ]]
  [[ "${lines[4]}" == "127.0.0.2	example.com" ]]
}

# `hosts search disabled` #######################################################

@test "\`search disabled\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" search disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`search disabled\` prints list of disabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" search disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.com" ]]
  [[ "${lines[1]}" == "127.0.0.1	example.com" ]]
  [[ "${lines[2]}" == "" ]]
}

# `hosts search <search string>` ################################################

@test "\`search <search string>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" search example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`search <search string>\` prints list of matching records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" search example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.com" ]]
  [[ "${lines[1]}" == "127.0.0.1	example.com" ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`search <search string>\` prints records with matching comments." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net "Example Comment"
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" search "Comment"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.net	# Example Comment" ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`search <search string>\` prints disabled records with matching comments." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net "Example Comment"
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" add 127.0.0.1 example.biz "Example Comment"
    run "${_HOSTS}" disable example.biz
  }

  run "${_HOSTS}" search "Comment"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.net	# Example Comment" ]]
  [[ "${lines[1]}" == "disabled: 127.0.0.1	example.biz	# Example Comment" ]]
  [[ "${lines[2]}" == "" ]]
}

# help ########################################################################

@test "\`help search\` exits with status 0." {
  run "${_HOSTS}" help search
  [[ ${status} -eq 0 ]]
}

@test "\`help search\` prints help information." {
  run "${_HOSTS}" help search
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts search <search string>" ]]
}
