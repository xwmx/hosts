# Hosts

A command line program with shortcuts for managing hosts file entries.

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

or

    hosts help <command name>

## Acknowledgements

Based on prior work by:

- https://github.com/nddrylliog
  - https://gist.github.com/nddrylliog/1368532
- https://github.com/dfeyer
  - https://gist.github.com/dfeyer/1369760

Original idea and interface (since changed) via:

https://github.com/macmade/host-manager
