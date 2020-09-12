#!/usr/bin/env bats

load test_helper

# `hosts disabled` ############################################################

@test "\`disabled\` with no arguments exits with status 0." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`disabled\` with no arguments prints list of disabled records." {
  {
    run "${_HOSTS}" add 0.0.0.0 example.com
    run "${_HOSTS}" add 0.0.0.0 example.net
    run "${_HOSTS}" add 127.0.0.1 example.com
    run "${_HOSTS}" disable example.com
  }

  run "${_HOSTS}" disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ 0\.0\.0\.0[[:space:]]+example\.com ]]
  [[ "${lines[1]}" =~ 127\.0\.0\.1[[:space:]]+example\.com ]]
  [[ "${lines[2]}" == "" ]]
}

@test "\`disabled\` exits with status 1 when no matching entries found." {
  run "${_HOSTS}" disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
}

# help ########################################################################

@test "\`help disabled\` exits with status 0." {
  run "${_HOSTS}" help disabled
  [[ ${status} -eq 0 ]]
}

@test "\`help disabled\` prints help information." {
  run "${_HOSTS}" help disabled
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts disabled" ]]
}
