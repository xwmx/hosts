###############################################################################
# test_helper.bash
#
# Test helper for Bats: Bash Automated Testing System.
#
# https://github.com/sstephenson/bats
###############################################################################

setup() {
  # `$_HOSTS`
  #
  # The location of the `hosts` script being tested.
  export _HOSTS="${BATS_TEST_DIRNAME}/../hosts"

  export HOSTS_PATH="$(mktemp /tmp/hosts_test.XXXXXX)" || exit 1
  cat "${BATS_TEST_DIRNAME}/fixtures/hosts" > "${HOSTS_PATH}"
}

teardown() {
  if [[ -n "${HOSTS_PATH}" ]] &&
     [[ -e "${HOSTS_PATH}" ]] &&
     [[ "${HOSTS_PATH}" =~ ^/tmp ]]
  then
    rm "${HOSTS_PATH}"
  fi
}

###############################################################################
# Helpers
###############################################################################

# _compare()
#
# Usage:
#   _compare <expected> <actual>
#
# Description:
#   Compare the content of a variable against an expected value. When used
#   within a `@test` block the output is only displayed when the test fails.
_compare() {
  local _expected="${1:-}"
  local _actual="${2:-}"
  printf "expected:\n%s\n" "${_expected}"
  printf "actual:\n%s\n" "${_actual}"
}
