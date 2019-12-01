# Hosts

Hosts is a script that helps managing the hosts file entries.

## Installation

### bpkg

To install with [bpkg](http://www.bpkg.sh/):

```bash
bpkg install hnioche/hosts
```

### Manual

To install manually, simply add the `hosts` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/hnioche/hosts/master/hosts \
  -o ~/bin/hosts && chmod +x ~/bin/hosts
```
## Usage

```text
Usage:
  hosts set <hostname> <ip address>
  hosts rm <hostname>
  hosts group <group name> set <hostname 1> <hostname 2> ... <hostname n>
  hosts group <group name> + <hostname 1> <hostname 2> ... <hostname n>
  hosts group <group name> - <hostname 1> <hostname 2> ... <hostname n>
  hosts group <group name> rm
  hosts group <group name> <ip address>
  hosts group <group name> reset
  hosts group <group name>
  hosts -h | --help
  hosts --version

Options:
  --auto-sudo  Run write commands with `sudo` automatically.

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

## Acknowledgements

- https://gist.github.com/nddrylliog/1368532
- https://gist.github.com/dfeyer/1369760
- https://github.com/macmade/host-manager
- https://github.com/alphabetum/hosts

