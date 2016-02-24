#!/usr/bin/env bats

load test_helper

@test "\`hosts version\` returns with 0 status." {
  run "${_HOSTS}" version
  [[ "${status}" -eq 0 ]]
}

@test "\`hosts version\` prints a version number." {
  run "${_HOSTS}" version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}

@test "\`hosts --version\` returns with 0 status." {
  run "${_HOSTS}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`hosts --version\` prints a version number." {
  run "${_HOSTS}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}

# help ########################################################################

@test "\`help version\` exits with status 0." {
  run "${_HOSTS}" help version
  [[ ${status} -eq 0 ]]
}

@test "\`help version\` prints help information." {
  run "${_HOSTS}" help version
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts (version | --version)" ]]
}
