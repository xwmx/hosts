#!/usr/bin/env bats

load test_helper

# `hosts add` #################################################################

@test "\`add\` with no arguments exits with status 1." {
  run "$_HOSTS" add
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 1 ]]
}

@test "\`add\` with no argument does not change the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" add
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`add\` with no arguments prints help information." {
  run "$_HOSTS" add
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts add <ip> <hostname> [comment]" ]]
}

# `hosts add <ip>` ############################################################

@test "\`add <ip>\` exits with status 1." {
  run "$_HOSTS" add 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 1 ]]
}

@test "\`add <ip>\` does not change the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" add 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`add <ip>\` prints help information." {
  run "$_HOSTS" add 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Please include a hostname" ]]
  [[ "${lines[1]}" == "Usage:" ]]
  [[ "${lines[2]}" == "  hosts add <ip> <hostname> [comment]" ]]
}

# `hosts add <ip> <hostname>` #################################################

@test "\`add <ip> <hostname>\` exits with status 0." {
  run "$_HOSTS" add 0.0.0.0 example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`add <ip> <hostname>\` adds the entry to the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" add 0.0.0.0 example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  _compare '0.0.0.0	example.com' "$(sed -n '11p' "${HOSTS_PATH}")"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "0.0.0.0	example.com" ]]
}

@test "\`add <ip> <hostname>\` prints feedback." {
  run "$_HOSTS" add 0.0.0.0 example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Added:" ]]
  [[ "${lines[1]}" == "0.0.0.0	example.com" ]]
}

# `hosts add <ip> <hostname> [comment]` #######################################

@test "\`add <ip> <hostname> [comment]\` exits with status 0." {
  run "$_HOSTS" add 0.0.0.0 example.com 'Comment.'
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`add <ip> <hostname> [comment]\` adds the entry to the hosts file." {
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" add 0.0.0.0 example.com 'Comment.'
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "$(cat "${HOSTS_PATH}")" != "${_original}" ]]
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "0.0.0.0	example.com	# Comment." ]]
}

@test "\`add <ip> <hostname> [comment]\` prints feedback." {
  run "$_HOSTS" add 0.0.0.0 example.com 'Comment.'
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Added:" ]]
  [[ "${lines[1]}" == "0.0.0.0	example.com	# Comment." ]]
}

# help ########################################################################

@test "\`help add\` exits with status 0." {
  run "$_HOSTS" help add
  [[ $status -eq 0 ]]
}

@test "\`help add\` prints help information." {
  run "$_HOSTS" help add
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts add <ip> <hostname> [comment]" ]]
}
