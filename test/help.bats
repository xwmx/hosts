#!/usr/bin/env bats

load test_helper

_HELP_HEADER="$(
  cat <<HEREDOC
    __               __
   / /_  ____  _____/ /______
  / __ \/ __ \/ ___/ __/ ___/
 / / / / /_/ (__  ) /_(__  )
/_/ /_/\____/____/\__/____/
HEREDOC
)"
export _HELP_HEADER

@test "\`help\` with no arguments exits with status 0." {
  run "${_HOSTS}" help
  [ "${status}" -eq 0 ]
}

@test "\`help\` with no arguments prints default help." {
  run "${_HOSTS}" help
  [[ $(IFS=$'\n'; echo "${lines[*]:0:5}") == "${_HELP_HEADER}" ]]
}

@test "\`hosts -h\` prints default help." {
  run "${_HOSTS}" -h
  [[ $(IFS=$'\n'; echo "${lines[*]:0:5}") == "${_HELP_HEADER}" ]]
}

@test "\`hosts --help\` prints default help." {
  run "${_HOSTS}" --help
  [[ $(IFS=$'\n'; echo "${lines[*]:0:5}") == "${_HELP_HEADER}" ]]
}

@test "\`hosts help help\` prints \`help\` subcommand usage." {
  run "${_HOSTS}" help help
  _expected="$(
    cat <<HEREDOC
Usage:
  hosts help [<command>]

Description:
  Display help information for hosts or a specified command.
HEREDOC
  )"
  [[ "${output}" == "${_expected}" ]]
}
