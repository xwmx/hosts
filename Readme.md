# Hosts

A command line program with shortcuts for managing hosts file entries.

## Installation

To get started, add the `hosts` script to your path.

### Homebrew

To install with homebrew, use the following command:

    brew install alphabetum/taps/hosts

## Usage

    Usage:
      hosts
      hosts add <ip> <hostname>
      hosts remove ( <ip> | <hostname> | <search string> ) [--force]
      hosts list [enabled | disabled | <search string>]
      hosts show ( <ip> | <hostname> | <search string> )
      hosts disable ( <ip> | <hostname> | <search string> )
      hosts disabled
      hosts enable ( <ip> | <hostname> | <search string> )
      hosts enabled
      hosts edit
      hosts file

For full usage, run:

    hosts help

For help with a particular command, try:

    hosts help <command name>

## Commands

###### `hosts add <ip> <hostname>`

Add a given IP address and hostname pair.

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
