# completion.zsh — one cached compinit, plus completion styles.

fpath=(
  /opt/homebrew/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $HOME/.cache/zsh/completions
  $HOME/.bun(N-/)                 # provides _bun
  $fpath
)

# Docker Desktop ships its completion outside fpath; link it once.
() {
  local src=/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion
  local dst=$HOME/.cache/zsh/completions/_docker
  [[ -r $src && ! -e $dst ]] && mkdir -p ${dst:h} && ln -s $src $dst
}

# kubectl's completion is slow to generate; cache it per kubectl binary.
() {
  local dst=$HOME/.cache/zsh/completions/_kubectl
  (( $+commands[kubectl] )) || return
  [[ -s $dst && $dst -nt $commands[kubectl] ]] && return
  mkdir -p ${dst:h} && kubectl completion zsh >| $dst 2>/dev/null
}

# Full compinit (with security audit) at most once a day; otherwise trust the dump.
autoload -Uz compinit
() {
  local dump=$HOME/.cache/zsh/zcompdump-$ZSH_VERSION
  local -a stale=($dump(N.mh+24))
  if [[ ! -s $dump || -n $stale ]]; then
    compinit -d $dump
    zcompile $dump
  else
    compinit -C -d $dump
  fi
}

# aws uses a bash-style completer.
if (( $+commands[aws_completer] )); then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{#505050}-- %d --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache/zsh/compcache
