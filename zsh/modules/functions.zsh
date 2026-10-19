# functions.zsh — multi-step helpers. None of these delete, reset, prune, or touch remote state.

# repo [query] — fuzzy-jump to a git repository under the usual roots.
REPO_ROOTS=($HOME/Pluto $HOME/Developer $HOME/Projects)
repo() {
  local dir
  dir=$(fd --hidden --no-ignore --type d --max-depth 3 --prune '^\.git$' ${REPO_ROOTS[@]}(N-/) \
          --exclude node_modules --format '{//}' 2>/dev/null \
        | sort -u \
        | fzf --query="${*:-}" --select-1 --preview 'git -C {} log --oneline -n 10 --color=always') \
    && cd "$dir"
}

# gsw [query] — switch to a local or remote branch, most recent first.
gsw() {
  local branch
  branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads refs/remotes \
             | sed -E 's#^[^/]+/##' | grep -vxE 'HEAD|origin' | awk '!seen[$0]++' \
             | fzf --query="${*:-}" --preview 'git log --oneline -n 15 --color=always {} 2>/dev/null || git log --oneline -n 15 --color=always origin/{}') \
    && git switch "$branch"
}

# rgf <pattern> [rg args] — ripgrep → fzf with preview → open match in $EDITOR at the line.
rgf() {
  (( $# )) || { print -u2 "usage: rgf <pattern> [rg args]"; return 2; }
  local hit
  hit=$(rg --line-number --no-heading --color=always --smart-case "$@" \
        | fzf --ansi --delimiter=: \
              --preview 'bat --color=always --highlight-line {2} {1}' \
              --preview-window '+{2}/2') || return
  ${EDITOR:-nvim} "+${${hit#*:}%%:*}" "${hit%%:*}"
}

# dlogs [query] — pick a running container and follow its logs.
dlogs() {
  local name
  name=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' \
         | fzf --query="${*:-}" --delimiter='\t' --with-nth=1.. | cut -f1) \
    && docker logs --follow --tail 200 "$name"
}

# kctx [context] — show contexts, or switch to one (fzf if no argument). Warns on prod.
kctx() {
  local ctx=$1
  if [[ -z $ctx ]]; then
    ctx=$(kubectl config get-contexts -o name | fzf --header="current: $(kubectl config current-context 2>/dev/null)") || return
  fi
  kubectl config use-context "$ctx" || return
  [[ $ctx == *prod* ]] && print -P "%F{#FF8080}%B⚠ production context: $ctx%b%f"
}

# awsp [profile] — set AWS_PROFILE for this shell only (fzf if no argument).
awsp() {
  local p=$1
  [[ -n $p ]] || p=$(aws configure list-profiles | fzf --header="current: ${AWS_PROFILE:-none}") || return
  export AWS_PROFILE=$p
  [[ $p == *prod* ]] && print -P "%F{#FF8080}%B⚠ production AWS profile: $p%b%f" || print "AWS_PROFILE=$p"
}

# proj <dev|test|build|lint> — run the conventional command for the project in $PWD.
proj() {
  local task=${1:?usage: proj <dev|test|build|lint>}
  local root; root=$(git rev-parse --show-toplevel 2>/dev/null) || root=$PWD
  if [[ -f Cargo.toml ]]; then
    case $task in dev) cargo run ;; test) cargo test ;; build) cargo build ;; lint) cargo clippy --all-targets ;; esac
  elif [[ -f go.mod ]]; then
    case $task in dev) go run . ;; test) go test ./... ;; build) go build ./... ;; lint) go vet ./... ;; esac
  elif [[ -f package.json ]]; then
    local pm=npm
    if [[ -f bun.lock || -f bun.lockb || -f $root/bun.lock || -f $root/bun.lockb ]]; then pm=bun
    elif [[ -f pnpm-lock.yaml || -f $root/pnpm-lock.yaml ]]; then pm=pnpm
    elif [[ -f yarn.lock || -f $root/yarn.lock ]]; then pm=yarn
    fi
    $pm run $task
  else
    print -u2 "proj: no Cargo.toml, go.mod or package.json in $PWD"; return 1
  fi
}

# fv [query] — fuzzy-pick a file (respects .gitignore) and open it in nvim.
fv() {
  local file
  file=$(fd --type f --hidden --exclude .git | fzf --query="${*:-}" \
           --preview 'bat --color=always --style=numbers --line-range=:200 {}') \
    && ${EDITOR:-nvim} "$file"
}

# fcp [query] — fuzzy-pick a file and copy its absolute path to the clipboard.
fcp() {
  local file
  file=$(fd --type f --hidden --exclude .git | fzf --query="${*:-}") \
    && print -rn -- "${file:A}" | pbcopy && print "copied: ${file:A}"
}

# cx <dir> — cd and list.
cx() { cd "$@" && eza -la --git --group-directories-first --time-style=relative; }
