#!/usr/bin/env bats

load test_helper

# `hosts list` ################################################################

@test "\`list\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list\` prints lists of enabled and disabled entries." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
127.0.0.1	  localhost
255.255.255.255	  broadcasthost
::1		  localhost
fe80::1%lo0	  localhost
127.0.0.2	  example.com

Disabled:
---------
0.0.0.0	  example.com
0.0.0.0	  example.net"
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
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list enabled\` prints list of enabled entries." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" list enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ 127\.0\.0\.1[[:space:]]+localhost           ]]
  [[ "${lines[1]}" =~ 255\.255\.255\.255[[:space:]]+broadcasthost ]]
  [[ "${lines[2]}" =~ \:\:1[[:space:]]+localhost                  ]]
  [[ "${lines[3]}" =~ fe80\:\:1\%lo0[[:space:]]+localhost         ]]
  [[ "${lines[4]}" =~ 127\.0\.0\.2[[:space:]]+example.com         ]]
}

@test "\`list enabled\` exits with status 1 when no matching entries found." {
  {
    run "${_HOSTS}" disable localhost
    run "${_HOSTS}" disable broadcasthost
  }

  run "${_HOSTS}" list enabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
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
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list disabled\` prints list of disabled entries." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" list disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ 0\.0\.0\.0[[:space:]]+example\.com ]]
  [[ "${lines[1]}" =~ 127\.0\.0\.1[[:space:]]+example\.com ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`list disabled\` exits with status 1 when no matching entries found." {
  run "${_HOSTS}" list disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

# `hosts list <search string>` ################################################

@test "\`list <search string>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" list example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`list <search string>\` prints list of matching entries." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" list example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ 0\.0\.0\.0[[:space:]]+example\.com ]]
  [[ "${lines[1]}" =~ 127\.0\.0\.1[[:space:]]+example\.com ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`list <search string>\` prints entries with matching comments." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net "Example Comment"
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" list "Comment"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ 0\.0\.0\.0[[:space:]]+example\.net[[:space:]]+\#\ Example\ Comment ]]
  [[ "${lines[2]}" == "" ]]
}


@test "\`list <search string>\` prints disabled entries with matching comments." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net "Example Comment"
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" add 127.0.0.1 example.biz "Example Comment"
    run "${_HOSTS}" disable example.biz
  }

  run "${_HOSTS}" list "Comment"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ 0\.0\.0\.0[[:space:]]+example\.net[[:space:]]+\#\ Example\ Comment ]]
  [[ "${lines[3]}" =~ 127\.0\.0\.1[[:space:]]+example\.biz[[:space:]]+\#\ Example\ Comment ]]
  [[ "${lines[4]}" == "" ]]
}

@test "\`list <search string>\` exits with status 1 when no matching entries found." {
  run "${_HOSTS}" list query-that-matches-no-entries
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

# help ########################################################################

@test "\`help list\` exits with status 0." {
  run "${_HOSTS}" help list
  [[ ${status} -eq 0 ]]
}

@test "\`help list\` prints help information." {
  run "${_HOSTS}" help list
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts list [enabled | disabled | <search string>]" ]]
}
