# ~josh

These are my dotfiles. There are many like them, but these are mine.

## intro

Dotfiles are used to personalize a *NIX system. I use these dotfiles on Linux and Mac OS X systems.

Both the install script (see below) and the repository layout are tailored for management with [yadm](https://yadm.io).

I use the excellent `zsh` for my shell, but most of the aliases, shell functions, etc in `.zshrc` and elsewhere should work just fine in `bash`.

There are comments throughout my dotfiles attributing all known original sources.

## install

You are **strongly encouraged to [inspect the install script for yourself](https://raw.githubusercontent.com/joshdick/dotfiles/main/.dotfiles_utils/install.sh)** before running it like this:

```sh
$ zsh <(curl -fsSL https://raw.githubusercontent.com/joshdick/dotfiles/main/.dotfiles_utils/install.sh)
```

The install script assumes that you are using `zsh` as your shell and requires `curl` and `git` to be installed as prerequisites.

It will not overwrite any of your existing dotfiles.

I take no responsibility for any havoc the install script may wreak on your system...it works for me!

## usage

`~/.localrc` will be sourced if it exists. Anything that should be kept secret/doesn't need to be version controlled should go in this file. It is useful for machine-specific configuration.

`~/.bin` contains git submodules for various utilities I use. These are added to `PATH` as appropriate via the `~/.bin/bin_init.zsh` script. `~/.bin` itself is also added to `PATH`.
