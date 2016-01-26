#!/usr/bin/env bats

load test_helper

@test "\`hosts version\` returns with 0 status." {
  run "$_HOSTS" --version
  [[ "$status" -eq 0 ]]
}

@test "\`hosts version\` prints a version number." {
  run "$_HOSTS" --version
  printf "'%s'" "$output"
  echo "$output" | grep -q '\d\+\.\d\+\.\d\+'
}

@test "\`hosts --version\` returns with 0 status." {
  run "$_HOSTS" --version
  [[ "$status" -eq 0 ]]
}

@test "\`hosts --version\` prints a version number." {
  run "$_HOSTS" --version
  printf "'%s'" "$output"
  echo "$output" | grep -q '\d\+\.\d\+\.\d\+'
}
