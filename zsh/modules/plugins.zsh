# plugins.zsh — tool hooks and zsh plugins. Order matters; syntax highlighting is last.

# Source a tool's generated init script, regenerating it only when the binary changes.
# Avoids spawning fnm/zoxide/starship/fzf on every shell start.
_cached_init() {
  local name=$1; shift
  local bin=$commands[$1] cache=$HOME/.cache/zsh/init-$name.zsh
  [[ -n $bin ]] || return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    "$@" >| $cache 2>/dev/null
  fi
  source $cache
}

# fnm — Node versions; auto-switches on cd when a .nvmrc/.node-version is found.
# Not cached: `fnm env` creates a per-shell multishell path.
# --log-level=quiet: no "Using Node vX" on cd; the prompt's node bubble shows it.
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --log-level=quiet --shell zsh)"

_cached_init zoxide   zoxide init zsh               # z <dir>, zi (interactive)
_cached_init fzf      fzf --zsh                     # ^T files, ⌥C cd (^R is taken by atuin below)
_cached_init atuin    atuin init zsh --disable-up-arrow   # ^R history search; ↑ stays normal
_cached_init starship starship init zsh --print-full-init

# Production AWS warning for the prompt (pure zsh, no subprocess).
_aws_prod_warning() {
  if [[ $AWS_PROFILE == *prod* ]]; then export AWS_PROD_WARNING="⚠ PROD"; else unset AWS_PROD_WARNING; fi
}
autoload -Uz add-zsh-hook && add-zsh-hook precmd _aws_prod_warning

# zsh-autosuggestions — accept with → or ^E, accept word with ⌥→
# Deliberately overwrites the "atuin" strategy that atuin's init prepends:
# it spawns `atuin search` on every keystroke.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#505050'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^E' autosuggest-accept   # falls back to end-of-line when there is no suggestion

# zsh-syntax-highlighting — Vesper-toned, deliberately quiet. Must be sourced last.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF8080'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FFC799'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#FFC799,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#A0A0A0'
ZSH_HIGHLIGHT_STYLES[path]='underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#99FFE4'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#99FFE4'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#99FFE4'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#505050'
