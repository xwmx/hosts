#!/usr/bin/env bats

load test_helper

@test "\`file\` exits with status 0." {
  run "${_HOSTS}" file
  [ "${status}" -eq 0 ]
}

@test "\`file\` prints \$HOSTS_PATH contents." {
  run "${_HOSTS}" file
  [[ "${output}" == "$(cat ${HOSTS_PATH})" ]]
}

# help ########################################################################

@test "\`help file\` exits with status 0." {
  run "${_HOSTS}" help file
  [[ ${status} -eq 0 ]]
}

@test "\`help file\` prints help information." {
  run "${_HOSTS}" help file
  printf "\${status}: %s\n" "${status}"
  printf "\${output}: '%s'\n" "${output}"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts file" ]]
}
