        __               __
       / /_  ____  _____/ /______
      / __ \/ __ \/ ___/ __/ ___/
     / / / / /_/ (__  ) /_(__  )
    /_/ /_/\____/____/\__/____/

# Hosts

A command line program with shortcuts for managing hosts file entries.

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
  hosts add <ip> <hostname> [comment]
  hosts remove ( <ip> | <hostname> | <search string> ) [--force]
  hosts list [enabled | disabled | <search string>]
  hosts show ( <ip> | <hostname> | <search string> )
  hosts disable ( <ip> | <hostname> | <search string> )
  hosts disabled
  hosts enable ( <ip> | <hostname> | <search string> )
  hosts enabled
  hosts edit
  hosts file
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

###### `hosts add <ip> <hostname> [comment]`

Add a given IP address and hostname pair, along with an optional comment.

###### `hosts remove ( <ip> | <hostname> | <search string> ) [--force]`

Remove one or more records based on a given IP address, hostname, or search
string. When the `--force` option is used, the confirmation prompt is
supressed.

###### `hosts list [enabled | disabled | <search string>]`

List the existing IP / hostname pairs, optionally limited to a specified
state. When provided with a seach string, all matching enabled records will
be printed.

###### `hosts show ( <ip> | <hostname> | <search string> )`

Print entries matching a given IP address, hostname, or search string.

###### `hosts disable ( <ip> | <hostname> | <search string> )`

Disable one or more records based on a given ip address, hostname, or
search string.

###### `hosts disabled`

List all disabled records. This is an alias for `hosts list disabled`.

###### `hosts enable ( <ip> | <hostname> | <search string> )`

Enable one or more disabled records based on a given ip address, hostname,
or search string.

###### `hosts enabled`

List all enabled records. This is an alias for `hosts list enabled`.

###### `hosts edit`

Open the hosts file (/etc/hosts) file in your editor.

###### `hosts file`

Print the entire contents of the /etc/hosts file.

## Why

Although it's easy to just edit the hosts file manually, it's nice to
have a structured way to edit it and keep things a little organized.

## Acknowledgements

Based on prior work by:

- https://github.com/nddrylliog
  - https://gist.github.com/nddrylliog/1368532
- https://github.com/dfeyer
  - https://gist.github.com/dfeyer/1369760

Original idea and interface (since changed) via:

https://github.com/macmade/host-manager
