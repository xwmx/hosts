setup() {
  # `$_HOSTS`
  #
  # The location of the `hosts` script being tested.
  export _HOSTS="${BATS_TEST_DIRNAME}/../hosts"

  export HOSTS_PATH="${BATS_TEST_DIRNAME}/tmp/hosts"
  cp "${BATS_TEST_DIRNAME}/fixtures/hosts" "${BATS_TEST_DIRNAME}/tmp/hosts"
}

teardown() {
  rm "${BATS_TEST_DIRNAME}/tmp/hosts"
}
