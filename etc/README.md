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

## `hosts completions`

The `hosts completions` subcommand can be used for installing and uninstalling
completion scripts. Depending on your configuration, you might need to use
`sudo` to install completion scripts easily:

```bash
> sudo hosts completions check
Completion scripts not found.

> sudo hosts completions install
Completion script installed: /usr/share/bash-completion/completions/hosts
Completion script installed: /usr/local/share/zsh/site-functions/_hosts

> sudo hosts completions check
Exists: /usr/share/bash-completion/completions/hosts
Exists: /usr/local/share/zsh/site-functions/_hosts

> sudo hosts completions uninstall
Completion script removed: /usr/share/bash-completion/completions/hosts
Completion script removed: /usr/local/share/zsh/site-functions/_hosts
```

If you installed `hosts` manually by downloading just the `hosts` script,
the completion scripts won't be immediately available for
`hosts completions install`. You can try installing the completions with
the `--download` flag, which will get the latest version from GitHub:

```bash
sudo hosts completions install --download
```

`hosts completions` will try to determine the completion script directories
from your environment. If `hosts completions` isn't able to install
the completion scripts, you can try installing them manually.

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
