#!/usr/bin/env bats

load test_helper

# `hosts disable` #############################################################

@test "\`disable\` with no arguments exits with status 1." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
  }

  run "$_HOSTS" disable
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 1 ]]
}

@test "\`disable\` with no argument does not change the hosts file." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" disable
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "$(cat "${HOSTS_PATH}")" == "${_original}" ]]
}

@test "\`disable\` with no arguments prints help information." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
  }

  run "$_HOSTS" disable
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts disable ( <ip> | <hostname> | <search string> )" ]]
}

# `hosts disable <ip>` ########################################################

@test "\`disable <ip>\` exits with status 0." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.net
  }

  run "$_HOSTS" disable 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`disable <ip>\` updates the hosts file." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" disable 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "127.0.0.1	example.net" ]]
}

@test "\`disable <ip>\` disables all matches." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" disable 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.net" ]]
}

@test "\`disable <ip>\` prints feedback." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.net
  }

  run "$_HOSTS" disable 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Disabling:" ]]
  [[ "${lines[1]}" == "0.0.0.0	example.com" ]]
}

# `hosts disable <hostname>` ##################################################

@test "\`disable <hostname>\` exits with status 0." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.net
  }

  run "$_HOSTS" disable example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`disable <hostname>\` updates the hosts file." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.net
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" disable example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "127.0.0.1	example.net" ]]
}

@test "\`disable <hostname>\` disables all matches." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.com
  }
  _original="$(cat "${HOSTS_PATH}")"

  run "$_HOSTS" disable example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  _compare "${_original}" "$(cat "${HOSTS_PATH}")"
  [[ "$(sed -n '11p' "${HOSTS_PATH}")" == "#disabled: 0.0.0.0	example.com" ]]
  [[ "$(sed -n '12p' "${HOSTS_PATH}")" == "#disabled: 127.0.0.1	example.com" ]]
}

@test "\`disable <hostname>\` prints feedback." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 127.0.0.1 example.net
  }

  run "$_HOSTS" disable example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Disabling:" ]]
  [[ "${lines[1]}" == "0.0.0.0	example.com" ]]
}
