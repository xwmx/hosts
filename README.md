        __               __
       / /_  ____  _____/ /______
      / __ \/ __ \/ ___/ __/ ___/
     / / / / /_/ (__  ) /_(__  )
    /_/ /_/\____/____/\__/____/

# Hosts

A command line program for managing hosts file entries.

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

## Usage

```text
Usage:
  hosts
  hosts add <ip> <hostname> [<comment>]
  hosts block <hostname>
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
  hosts unblock <hostname>
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

## `hosts add`

```text
Usage:
  hosts add <ip> <hostname> [<comment>]

Description:
  Add a given IP address and hostname pair, along with an optional comment.
```

### `hosts block`

```text
Usage:
  hosts block <hostname>

Description:
  Block a given hostname by adding new entries assigning it to `127.0.0.1`
  for IPv4 and both `fe80::1%lo0` and `::1` for IPv6.
```

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
  hosts unblock <hostname>

Description:
  Unblock a given hostname by removing its entries from the hosts file.
```

### `hosts version`

```text
Usage:
  hosts (version | --version)

Description:
  Display the current program version.
```

## Tests

To run the test suite, install [Bats](https://github.com/sstephenson/bats) and
run `bats test` in the project root directory.

## Acknowledgements

Based on prior work by:

- https://github.com/nddrylliog
  - https://gist.github.com/nddrylliog/1368532
- https://github.com/dfeyer
  - https://gist.github.com/dfeyer/1369760

Original idea and interface (since changed) via:

https://github.com/macmade/host-manager
