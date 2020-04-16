# `hosts` Tab Completion

## Homebrew

Installing via Homebrew with `brew install xwmx/taps/hosts` will also
install the completion scripts.

A one-time setup might be needed to [enable completion for all Homebrew
programs](https://docs.brew.sh/Shell-Completion).

## npm, bpkg, Make

When `hosts` is installed with `npm`, `bpkg`, or Make, an install hook will
check the environment and attempt to install completions. If it's successful,
you should see a message similar to:

```bash
Completion installed: /usr/local/etc/bash_completion.d/hosts
Completion installed: /usr/local/share/zsh/site-functions/_hosts
```

If completion is working after installing through any of these methods, then
you don't need to do anything else.

## `scripts/hosts-completion`

`hosts` includes a script for installing and uninstalling `hosts` completions
that is used in installation hooks:
[hosts-completion](../scripts/hosts-completion)

To run this script directly, navigate to this directory in your terminal, and
run:

```bash
./hosts-completion
```

To install completions:

```bash
./hosts-completion install
```

To uninstall:

```bash
./hosts-completion uninstall
```

Use the `check` subcommand to determine if completion scripts are installed:

```bash
> ./hosts-completion check
Exists: /usr/local/etc/bash_completion.d/hosts
Exists: /usr/local/share/zsh/site-functions/_hosts
```

This script will try to determine the completion installation
locations from your environment. If completion doesn't work, you might
need to try installing manually.

## Manual Installation

### bash

#### Linux

On a current Linux OS (in a non-minimal installation), bash completion should
be available.

Place the completion script in `/etc/bash_completion.d/`:

```bash
sudo curl -L https://raw.githubusercontent.com/xwmx/hosts/master/hosts-completion.bash -o /etc/bash_completion.d/hosts
```

#### macOS

If you aren't installing with homebrew, source the completion script in
`.bash_profile`:

```sh
if [[ -f /path/to/hosts-completion.bash ]]
then
  source /path/to/hosts-completion.bash
fi
```

### zsh

Place the completion script in your `/path/to/zsh/completion` (typically
`~/.zsh/completion/`):

```bash
$ mkdir -p ~/.zsh/completion
$ curl -L https://raw.githubusercontent.com/xwmx/hosts/master/hosts-completion.zsh > ~/.zsh/completion/_hosts
```
Include the directory in your `$fpath` by adding in `~/.zshrc`:

```bash
fpath=(~/.zsh/completion $fpath)
```

Make sure `compinit` is loaded or do it by adding in `~/.zshrc`:

```bash
autoload -Uz compinit && compinit -i
```

Then reload your shell:

```bash
exec $SHELL -l
```
