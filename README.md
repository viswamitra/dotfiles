# dotfiles

My terminal setup: zsh + [oh-my-zsh](https://ohmyz.sh/), [starship](https://starship.rs/)
prompt, [kitty](https://sw.kovidgoyal.net/kitty/) terminal, all themed with
Catppuccin Frappe.

Includes: `eza`, `bat`, `ripgrep`, `fd`, `fzf`, `zoxide`, `lazygit`, `btop`,
`git-delta`, `zsh-syntax-highlighting`, `zsh-autosuggestions`.

## Setup on a new machine

```sh
git clone git@github.com:viswamitra/dotfiles.git ~/codeground/dotfiles
cd ~/codeground/dotfiles
./install.sh
```

This installs Homebrew (if missing), everything in `Brewfile`, starship,
oh-my-zsh, then symlinks all the config files into place. Anything it would
overwrite gets moved to `~/.dotfiles-backup/<timestamp>/` first, nothing is
deleted.

Re-run it any time — it's idempotent.

## Layout

| Path              | Links to                                    |
|-------------------|----------------------------------------------|
| `zsh/zshrc`       | `~/.zshrc`                                    |
| `zsh/zprofile`    | `~/.zprofile`                                 |
| `git/gitconfig`   | `~/.gitconfig`                                |
| `git/ignore`      | `~/.config/git/ignore`                        |
| `kitty/*`         | `~/.config/kitty/*`                           |
| `starship/starship.toml` | `~/.config/starship.toml`               |
| `bat/*`           | `~/.config/bat/*`                             |
| `lazygit/config.yml` | `~/.config/lazygit/config.yml`             |
