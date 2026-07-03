#!/usr/bin/env bash
# Bootstrap this terminal setup (zsh + oh-my-zsh + starship + kitty + CLI tools)
# on a new macOS machine. Safe to re-run.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

link() {
  local src="$DOTFILES_DIR/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${dest#"$HOME"/}")"
    mv "$dest" "$BACKUP_DIR/${dest#"$HOME"/}"
  fi
  ln -s "$src" "$dest"
  log "linked $dest -> $src"
}

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ---------------------------------------------------------------------------
# 2. CLI tools + kitty + font (see Brewfile)
# ---------------------------------------------------------------------------
log "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ---------------------------------------------------------------------------
# 3. Starship prompt (not a brew formula)
# ---------------------------------------------------------------------------
if ! command -v starship &>/dev/null; then
  log "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ---------------------------------------------------------------------------
# 4. oh-my-zsh
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# ---------------------------------------------------------------------------
# 5. Symlink config files into place (existing files are backed up, not lost)
# ---------------------------------------------------------------------------
log "Linking dotfiles..."
link "zsh/zshrc"                        "$HOME/.zshrc"
link "zsh/zprofile"                     "$HOME/.zprofile"
link "git/gitconfig"                    "$HOME/.gitconfig"
link "git/ignore"                       "$HOME/.config/git/ignore"
link "kitty/kitty.conf"                 "$HOME/.config/kitty/kitty.conf"
link "kitty/current-theme.conf"         "$HOME/.config/kitty/current-theme.conf"
link "kitty/Catppuccin-Frappe.conf"     "$HOME/.config/kitty/Catppuccin-Frappe.conf"
link "starship/starship.toml"           "$HOME/.config/starship.toml"
link "bat/config"                       "$HOME/.config/bat/config"
link "bat/themes/Catppuccin-Frappe.tmTheme" "$HOME/.config/bat/themes/Catppuccin-Frappe.tmTheme"
link "lazygit/config.yml"               "$HOME/.config/lazygit/config.yml"

# Rebuild bat's theme cache so the Catppuccin theme is picked up
if command -v bat &>/dev/null; then
  bat cache --build &>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 6. Make zsh the default shell
# ---------------------------------------------------------------------------
if [[ "$SHELL" != *zsh ]]; then
  log "Setting zsh as default shell..."
  chsh -s "$(command -v zsh)" || true
fi

if [[ -d "$BACKUP_DIR" ]]; then
  log "Existing configs backed up to $BACKUP_DIR"
fi

log "Done. Open a new kitty window (or run 'exec zsh') to see the new setup."
