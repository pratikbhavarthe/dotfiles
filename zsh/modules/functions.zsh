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

# git-as [personal|work|admin] — choose which GitHub account this repo commits/pushes as.
# The remote's SSH alias decides the account (see ~/.gitconfig); this rewrites the alias and
# switches the gh CLI to match. No argument: show the current account for this repo.
git-as() {
  local top url slug host acct eff
  top=$(git rev-parse --show-toplevel 2>/dev/null) || { print -u2 "git-as: not in a git repo"; return 1; }
  url=$(git remote get-url origin 2>/dev/null) || { print -u2 "git-as: no origin remote"; return 1; }
  case $url in
    https://*) slug=${url#https://*/} ;;
    *:*)       slug=${url#*:} ;;
  esac
  if (( $# == 0 )); then
    eff=$(git ls-remote --get-url origin); host=${${eff#git@}%%:*}
    case $host in
      github-personal)    acct=pratikbhavarthe ;;
      github-pluto-work)  acct=pratik-pluto ;;
      github-pluto-admin) acct=plutomobility ;;
      *)                  acct="$host" ;;
    esac
    print -r -- "repo     ${top:t} ($slug)"
    print -r -- "push as  $acct"
    print -r -- "commits  $(git config user.email)  (signing ${$(git config user.signingkey):t})"
    print -r -- "gh       $(gh api user --jq .login 2>/dev/null || print '?')"
    return
  fi
  case $1 in
    personal) host=github-personal    acct=pratikbhavarthe ;;
    work)     host=github-pluto-work  acct=pratik-pluto ;;
    admin)    host=github-pluto-admin acct=plutomobility ;;
    *) print -u2 "usage: git-as [personal|work|admin]"; return 2 ;;
  esac
  git remote set-url origin "git@$host:$slug" || return
  if [[ $acct == plutomobility ]]; then
    print -u2 "note: gh has no working login for plutomobility; gh unchanged"
  else
    gh auth switch -h github.com -u $acct >/dev/null 2>&1 || print -u2 "note: couldn't switch gh to $acct"
  fi
  [[ -n $(git config --local user.email) ]] && print -u2 "note: this repo has its own user.email ($(git config --local user.email)), which overrides the account identity"
  git-as
}
