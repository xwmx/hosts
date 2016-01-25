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
