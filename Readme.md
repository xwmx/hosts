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
      hosts enable ( <ip> | <hostname> | <search string> )
      hosts edit
      hosts file

For full usage, run:

    hosts help

For help with a particular command, try:

    hosts help <command name>

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
