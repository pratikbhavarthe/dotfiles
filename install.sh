#!/bin/zsh
# Symlink these dotfiles into place. Existing files are moved to a backup folder, never deleted.
# Usage: ./install.sh            (from the repo root)
#        ./install.sh --dry-run  (show what would happen)
set -eu

DOTFILES=${0:A:h}
DRY=${1:-}
BACKUP=$HOME/.config/shell-backups/install-$(date +%Y%m%d-%H%M%S)

# repo path → target path
typeset -A links=(
  zsh/zshrc                 ~/.zshrc
  zsh/zprofile              ~/.zprofile
  zsh/zshenv                ~/.zshenv
  zsh/modules               ~/.config/zsh
  starship/starship.toml    ~/.config/starship.toml
  ghostty/config.ghostty    ~/.config/ghostty/config.ghostty
  nvim                      ~/.config/nvim
  tmux/tmux.conf            ~/.config/tmux/tmux.conf
  atuin/config.toml         ~/.config/atuin/config.toml
  atuin/themes              ~/.config/atuin/themes
  gh-dash/config.yml        ~/.config/gh-dash/config.yml
)

for src dst in ${(kv)links}; do
  dst=${~dst}
  if [[ -L $dst && ${dst:A} == $DOTFILES/$src ]]; then
    print "ok       $dst"
    continue
  fi
  if [[ $DRY == --dry-run ]]; then
    if [[ -e $dst || -L $dst ]]; then
      print "link     $dst -> $DOTFILES/$src  (existing file would be backed up)"
    else
      print "link     $dst -> $DOTFILES/$src"
    fi
    continue
  fi
  mkdir -p ${dst:h}
  if [[ -e $dst || -L $dst ]]; then
    mkdir -p $BACKUP
    mv $dst $BACKUP/
    print "backup   $dst -> $BACKUP/"
  fi
  ln -s $DOTFILES/$src $dst
  print "link     $dst -> $DOTFILES/$src"
done

# git: include the shared settings; identity ([user]) stays in your own ~/.gitconfig.
if ! git config --global --get-all include.path | grep -qx "$DOTFILES/git/gitconfig"; then
  if [[ $DRY == --dry-run ]]; then
    print "git      would add include.path = $DOTFILES/git/gitconfig to ~/.gitconfig"
  else
    git config --global --add include.path "$DOTFILES/git/gitconfig"
    print "git      added include.path = $DOTFILES/git/gitconfig"
  fi
fi

print "\nNext: brew bundle --file=$DOTFILES/Brewfile, then open a new terminal."
