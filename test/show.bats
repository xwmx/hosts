#!/usr/bin/env bats

load test_helper

# `hosts show` ##############################################################

@test "\`show\` with no arguments exits with status 1." {
  run "$_HOSTS" show
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 1 ]]
}

@test "\`show\` with no arguments prints help information." {
  run "$_HOSTS" show
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts show ( <ip> | <hostname> | <search string> )" ]]
}

# `hosts show <ip>` #########################################################

@test "\`show <ip>\` exits with status 0." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
    run "$_HOSTS" add 127.0.0.2 example.com
    run "$_HOSTS" disable example.com
  }

  run "$_HOSTS" show 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`enable <ip>\` shows all matches." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
    run "$_HOSTS" add 127.0.0.2 example.com
    run "$_HOSTS" disable example.com
  }

  run "$_HOSTS" show 0.0.0.0
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"

  [[ "${lines[0]}" == "0.0.0.0	example.net" ]]
  [[ "${lines[1]}" == "disabled: 0.0.0.0	example.com" ]]
}

# `hosts show <hostname>` #####################################################

@test "\`show <hostname>\` exits with status 0." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
    run "$_HOSTS" add 127.0.0.2 example.com
    run "$_HOSTS" disable 0.0.0.0
  }

  run "$_HOSTS" show example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ $status -eq 0 ]]
}

@test "\`enable <hostname>\` shows all matches." {
  {
    run "$_HOSTS" add 0.0.0.0 example.com
    run "$_HOSTS" add 0.0.0.0 example.net
    run "$_HOSTS" add 127.0.0.2 example.com
    run "$_HOSTS" disable 0.0.0.0
  }

  run "$_HOSTS" show example.com
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"

  [[ "${lines[0]}" == "127.0.0.2	example.com" ]]
  [[ "${lines[1]}" == "disabled: 0.0.0.0	example.com" ]]
}

# help ########################################################################

@test "\`help show\` exits with status 0." {
  run "$_HOSTS" help show
  [[ $status -eq 0 ]]
}

@test "\`help show\` prints help information." {
  run "$_HOSTS" help show
  printf "\$status: %s\n" "$status"
  printf "\$output: '%s'\n" "$output"
  [[ "${lines[0]}" == "Usage:" ]]
  [[ "${lines[1]}" == "  hosts show ( <ip> | <hostname> | <search string> )" ]]
}
