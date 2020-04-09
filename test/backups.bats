#!/usr/bin/env bats

load test_helper

# `hosts backups` #############################################################

@test "\`backups\` with no backups and no arguments exits with status 0." {
  run "${_HOSTS}" backups
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`backups\` with backups and no arguments exits with status 0." {
  {
    run "${_HOSTS}" backups create
  }

  run "${_HOSTS}" backups
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`backups\` with no backups and no arguments prints message." {
  run "${_HOSTS}" backups
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
No backups found. Create a new backup:
 hosts backups create"
  [[ "${output}" == "${_expected}" ]]
}

@test "\`backups\` with backups and no arguments prints list of backups." {
  {
    run "${_HOSTS}" backups create
    sleep 1
    run "${_HOSTS}" backups create
  }

  run "${_HOSTS}" backups
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${lines[0]}" =~ hosts_test ]]
  [[ "${lines[0]}" =~ '--backup-' ]]
  [[ "${lines[1]}" =~ hosts_test ]]
  [[ "${lines[1]}" =~ '--backup-' ]]
}

# `hosts backups create` ######################################################

@test "\`backups create\` exits with status 0." {
  run "${_HOSTS}" backups create
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`backups create\` creates backup." {
  run "${_HOSTS}" backups create
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
  printf "\${_backup_path}: '%s'\\n" "${_backup_path}"
  [[ -e "${_backup_path}" ]]
}

@test "\`backups create\` prints message." {
  run "${_HOSTS}" backups create
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${output} =~ 'Backed up to' ]]
}

# `hosts backups compare` #####################################################

@test "\`backups compare\` with valid backup exits with status 1 and prints." {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
    run "${_HOSTS}" add 0.0.0.0 example.com
  }

  run "${_HOSTS}" backups compare "${_backup_basename}" --diff
  printf "\${output}: '%s'\\n" "${output}"
  printf "\${lines[1]}: '%s'\\n" "${lines[1]}"
  [[ ${status} -eq 1 ]]
  [[ "${lines[2]}" == '@@ -8,4 +8,3 @@' ]]
}

@test "\`backups compare\` with missing backup exits with status 1" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
    run "${_HOSTS}" add 0.0.0.0 example.com
  }

  run "${_HOSTS}" backups compare --diff
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
  [[ "${lines[0]}" =~ 'Usage' ]]
}

@test "\`backups compare\` with invalid backup exits with status 1" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
    run "${_HOSTS}" add 0.0.0.0 example.com
  }

  run "${_HOSTS}" backups compare "invalid-backup-name" --diff
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
  [[ ${output} =~ 'Backup not found' ]]
}

# `hosts backups delete` ######################################################

@test "\`backups delete\` with valid backup exits with status 0 and deletes backup" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
  }

  run "${_HOSTS}" backups delete "${_backup_basename}"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
  [[ ! -e "${_backup_path}" ]]
  [[ ${output} =~ 'Backup deleted' ]]
}

@test "\`backups delete\` with invalid backup exits with status 1" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
  }

  run "${_HOSTS}" backups delete "invalid-backup-name"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
  [[ -e "${_backup_path}" ]]
  [[ ${output} =~ 'Backup not found' ]]
}

# `hosts backups restore` #####################################################

@test "\`backups restore\` with valid backup exits with status 0 and restores" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
    run "${_HOSTS}" add 0.0.0.0 example.com
    sleep 1
  }

  run "${_HOSTS}" backups restore "${_backup_basename}"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  printf "\${lines[0]}: '%s'\\n" "${lines[0]}"
  [[ ${status} -eq 0 ]]
  [[ "${lines[0]}" =~ 'Backed up to' ]]
  [[ "${lines[1]}" =~ 'Restored from backup' ]]

  _new_backup_path="$(echo "${lines[0]}" | sed -e 's/.*\(\/tmp.*\)/\1/')"

  _new_backup_content="$(cat "${_new_backup_path}")"
  _old_backup_content="$(cat "${_backup_path}")"
  _current_content="$(cat "${HOSTS_PATH}")"

  [[ "${_new_backup_content}" != "${_current_content}" ]]
  [[ "${_old_backup_content}" == "${_current_content}" ]]
}

@test "\`backups restore --skip-backup\` with valid backup exits with status 0 and restores" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
    run "${_HOSTS}" add 0.0.0.0 example.com
    _replaced_content="$(cat "${HOSTS_PATH}")"
    sleep 1
  }

  run "${_HOSTS}" backups restore "${_backup_basename}" --skip-backup
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  printf "\${lines[0]}: '%s'\\n" "${lines[0]}"
  [[ ${status} -eq 0 ]]
  [[ "${lines[0]}" =~ 'Restored from backup' ]]

  _old_backup_content="$(cat "${_backup_path}")"
  _current_content="$(cat "${HOSTS_PATH}")"

  [[ "${_replaced_content}"   != "${_current_content}" ]]
  [[ "${_old_backup_content}" == "${_current_content}" ]]
}

@test "\`backups restore\` with invalid backup exits with status 1" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
  }

  run "${_HOSTS}" backups restore "invalid-backup-name"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
  [[ ${output} =~ 'Backup not found' ]]
}

# `hosts backups show` ########################################################

@test "\`backups show\` with valid backup exits with status 0 and prints." {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
  }

  run "${_HOSTS}" backups show "${_backup_basename}"
  printf "\${output}: '%s'\\n" "${output}"
  printf "\${lines[6]}: '%s'\\n" "${lines[6]}"
  [[ ${status} -eq 0 ]]
  [[ "${lines[6]}" == '127.0.0.1	localhost' ]]
}

@test "\`backups show\` with invalid backup exits with status 1" {
  {
    run "${_HOSTS}" backups create
    _backup_path="$(echo "${output}" | sed -e 's/.*\(\/tmp.*\)/\1/')"
    _backup_basename="$(basename "${_backup_path}")"
  }

  run "${_HOSTS}" backups show "invalid-backup-name"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 1 ]]
  [[ ${output} =~ 'Backup not found' ]]
}
