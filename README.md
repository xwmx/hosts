        __               __
       / /_  ____  _____/ /______
      / __ \/ __ \/ ___/ __/ ___/
     / / / / /_/ (__  ) /_(__  )
    /_/ /_/\____/____/\__/____/

# Hosts

`hosts` is a command line program for managing [hosts file](https://en.m.wikipedia.org/wiki/Hosts_\(file\)) entries.

`hosts` works with existing hosts files and entries, making it easier to add, remove, comment, and search hosts file entries using simple, memorable commands.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew tap alphabetum/taps && brew install alphabetum/taps/hosts
```

### bpkg

To install with [bpkg](http://www.bpkg.io/):

```bash
bpkg install alphabetum/hosts
```

### Manual

To install manually, simply add the `hosts` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/alphabetum/hosts/master/hosts \
  -o ~/bin/hosts && chmod +x ~/bin/hosts
```

A package for Arch users is also [available in the AUR](https://aur.archlinux.org/packages/hosts/).

## Usage

```text
Usage:
  hosts [<search string>]
  hosts add <ip> <hostname> [<comment>]
  hosts backups [create | [compare | delete | restore | show] <filename>]
  hosts block <hostname>...
  hosts disable (<ip> | <hostname> | <search string>)
  hosts disabled
  hosts edit
  hosts enable (<ip> | <hostname> | <search string>)
  hosts enabled
  hosts file
  hosts list [enabled | disabled | <search string>]
  hosts search <search string>
  hosts show (<ip> | <hostname> | <search string>)
  hosts remove (<ip> | <hostname> | <search string>) [--force]
  hosts unblock <hostname>...
  hosts --auto-sudo
  hosts -h | --help
  hosts --version

Options:
  --auto-sudo  Run write commands with `sudo` automatically.
  -h --help    Display this help information.
  --version    Display version information.

Help:
  hosts help [<command>]
```

For full usage, run:

```text
hosts help
```

For help with a particular command, try:

```text
hosts help <command name>
```

## Commands

### `hosts`

```text
Usage:
  hosts [<search string>]

Description:
  List the existing IP / hostname pairs, optionally limited to a specified
  state. When provided with a seach string, all matching enabled records will
  be printed.

  Alias for `hosts list`
```

### `hosts add`

```text
Usage:
  hosts add <ip> <hostname> [<comment>]

Description:
  Add a given IP address and hostname pair, along with an optional comment.
```

### `hosts backups`

```text
Usage:
  hosts backups
  hosts backups create
  hosts backups compare <name>
  hosts backups delete  <name>
  hosts backups restore <name> --skip-backup
  hosts backups show    <name>

Subcommands:
  backups           List available backups.
  backups create    Create a new backup of the hosts file.
  backups compare   Compare a backup file with the current hosts file.
                    The diff tool configured for git will be used if
                    one is set.
  backups delete    Delete the specified backup.
  backups restore   Replace the contents of the hosts file with a
                    specified backup. The hosts file is automatically
                    backed up before being overwritten unless the
                    '--skip-backup' flag is specified.
  backups show      Show the contents of the specified backup file.
```

### `hosts block`

```text
Usage:
  hosts block <hostname>...

Description:
  Block one or more hostnames by adding new entries assigned to \`127.0.0.1\`
  for IPv4 and both \`fe80::1%lo0\` and \`::1\` for IPv6.
```

#### Blocklists

- [jmdugan/blocklists](https://github.com/jmdugan/blocklists)
- [notracking/hosts-blocklists](https://github.com/notracking/hosts-blocklists)

### `hosts commands`

```text
Usage:
  hosts commands [--raw]

Options:
  --raw  Display the command list without formatting.

Description:
  Display the list of available commands.
```

### `hosts disable`

```text
Usage:
  hosts disable (<ip> | <hostname> | <search string>)

Description:
  Disable one or more records based on a given ip address, hostname, or
  search string.
```

### `hosts disabled`

```text
Usage:
  hosts disabled

Description:
  List all disabled records. This is an alias for `hosts list disabled`.
```

### `hosts edit`

```text
Usage:
  hosts edit

Description:
  Open the /etc/hosts file in your $EDITOR.
```

### `hosts enable`

```text
Usage:
  hosts enable (<ip> | <hostname> | <search string>)

Description:
  Enable one or more disabled records based on a given ip address, hostname,
  or search string.
```

### `hosts enabled`

```text
Usage:
  hosts enabled

Description:
  List all enabled records. This is an alias for `hosts list enabled`.
```

### `hosts file`

```text
Usage:
  hosts file

Description:
  Print the entire contents of the /etc/hosts file.
```

### `hosts help`

```text
Usage:
  hosts help [<command>]

Description:
  Display help information for hosts or a specified command.
```

### `hosts list`

```text
Usage:
  hosts list [enabled | disabled | <search string>]

Description:
  List the existing IP / hostname pairs, optionally limited to a specified
  state. When provided with a seach string, all matching enabled records will
  be printed.
```

### `hosts remove`

```text
Usage:
  hosts remove (<ip> | <hostname> | <search string>) [--force]
  hosts remove <ip> <hostname>

Options:
  --force  Skip the confirmation prompt.

Description:
  Remove one or more records based on a given IP address, hostname, or search
  string. If an IP and hostname are both provided, only records matching the
  IP and hostname pair will be removed.
```

### `hosts search`

```text
Usage:
  hosts search <search string>

Description:
  Search entries for <search string>.
```

### `hosts show`

```text
Usage:
  hosts show (<ip> | <hostname> | <search string>)

Description:
  Print entries matching a given IP address, hostname, or search string.
```

### `hosts unblock`

```text
Usage:
  hosts unblock <hostname>...

Description:
  Unblock one or more hostnames by removing the entries from the hosts file.
```

### `hosts version`

```text
Usage:
  hosts (version | --version)

Description:
  Display the current program version.
```

## Options

### `--auto-sudo`

When specified, all write operations that require `sudo` will automatically
rerun the command using `sudo` when the current user does not have write
permissions for the hosts file.

To have this option always enabled, add the following line to your shell
configuration (`.bashrc`, `.zshrc`, or similar):

```bash
alias hosts="hosts --auto-sudo"
```

### `-h` `--help`

Display help information.

### `--version`

Display version information.

## Tests

To run the test suite, install [Bats](https://github.com/sstephenson/bats) and
run `bats test` in the project root directory.

## Acknowledgements

- https://gist.github.com/nddrylliog/1368532
- https://gist.github.com/dfeyer/1369760
- https://github.com/macmade/host-manager

