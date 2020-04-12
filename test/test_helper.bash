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

  export _HOSTS_TEMP_DIR="/tmp"
  export _HOSTS_TEMP_PATH
  _HOSTS_TEMP_PATH="$(mktemp "${_HOSTS_TEMP_DIR}/hosts_test.XXXXXX")" || exit 1
  cat "${BATS_TEST_DIRNAME}/fixtures/hosts" > "${_HOSTS_TEMP_PATH}"

  export HOSTS_PATH="${_HOSTS_TEMP_PATH}"

  # Use empty `hosts` script in environment to avoid depending on `hosts`
  # being available in `$PATH`.
  export PATH="${BATS_TEST_DIRNAME}/fixtures/bin:${PATH}"
}

teardown() {
  if [[ -n "${_HOSTS_TEMP_PATH}" ]] &&
     [[ -e "${_HOSTS_TEMP_PATH}" ]] &&
     [[ "${_HOSTS_TEMP_PATH}" =~ ^/tmp/hosts_test ]]
  then
    rm -f "${_HOSTS_TEMP_DIR}"/hosts_test.*
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
  printf "expected:\\n%s\\n" "${_expected}"
  printf "actual:\\n%s\\n" "${_actual}"
}
