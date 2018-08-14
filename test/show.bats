#!/usr/bin/env bats

load test_helper

# `hosts show` ##############################################################

@test "\`show\` with no arguments exits with status 1." {
  run "${_HOSTS}" show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

@test "\`show\` with no arguments prints help information." {
  run "${_HOSTS}" show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts show (<ip> | <hostname> | <search string>)" ]]
}

# `hosts show <ip>` #########################################################

@test "\`show <ip>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" show 0.0.0.0
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <ip>\` shows all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" show 0.0.0.0
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${lines[0]}" == "0.0.0.0	example.net" ]]
  [[ "${lines[1]}" == "disabled: 0.0.0.0	example.com" ]]
}

# `hosts show <hostname>` #####################################################

@test "\`show <hostname>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" show example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <hostname>\` shows all matches." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.2 example.com
    run "${_HOSTS}" disable 0.0.0.0
  }

  run "${_HOSTS}" show example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${lines[0]}" == "127.0.0.2	example.com" ]]
  [[ "${lines[1]}" == "disabled: 0.0.0.0	example.com" ]]
}

# `hosts show <search string>` ################################################

@test "\`show <search string>\` exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" show example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`show <search string>\` prints list of matching records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" show example.com
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.com" ]]
  [[ "${lines[1]}" == "127.0.0.1	example.com" ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`show <search string>\` prints records with matching comments." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net "Example Comment"
    run "${_HOSTS}" add 127.0.0.1 example.com
  }

  run "${_HOSTS}" show "Comment"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.net	# Example Comment" ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`show <search string>\` prints disabled records with matching comments." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net "Example Comment"
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" add 127.0.0.1 example.biz "Example Comment"
    run "${_HOSTS}" disable example.biz
  }

  run "${_HOSTS}" show "Comment"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "0.0.0.0	example.net	# Example Comment" ]]
  [[ "${lines[1]}" == "disabled: 127.0.0.1	example.biz	# Example Comment" ]]
  [[ "${lines[2]}" == "" ]]
}

# help ########################################################################

@test "\`help show\` exits with status 0." {
  run "${_HOSTS}" help show
  [[ ${status} -eq 0 ]]
}

@test "\`help show\` prints help information." {
  run "${_HOSTS}" help show
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts show (<ip> | <hostname> | <search string>)" ]]
}
