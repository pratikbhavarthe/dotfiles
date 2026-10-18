# aliases.zsh — short, unsurprising aliases. Multi-step logic goes in functions.zsh.

# ── Git ──────────────────────────────────────────────────────────────
alias gs='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch -vv --sort=-committerdate'
alias glg='git log --graph --oneline --decorate -n 30'
# Two-line log with relative date and author (omerxx's format, Vesper colors)
alias glog="git log --graph --topo-order --abbrev-commit --pretty='%w(100,0,6)%C(#FFC799)%h%C(#7E7E7E)%d %C(#99FFE4)%ar %C(#A0A0A0)%an%n%C(#E6E1DA)%s %N'"
alias lg='lazygit'
alias gdash='gh dash'

# ── Files / navigation ───────────────────────────────────────────────
alias ls='eza --group-directories-first'
alias ll='eza -la --git --group-directories-first --time-style=relative'
alias lt='eza --tree --level=2 --git-ignore --group-directories-first'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias v='nvim'
alias cls='clear'

# ── Containers ───────────────────────────────────────────────────────
alias dc='docker compose'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dpa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
alias dx='docker exec -it'

# ── Kubernetes (read-only + exec; nothing that applies or deletes) ──
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs -f'
alias ke='kubectl exec -it'
alias kgpo='kubectl get pods'
alias kgd='kubectl get deployments'
alias kcns='kubectl config set-context --current --namespace'

# ── Pluto ────────────────────────────────────────────────────────────
# Restore ADB reverse tunnels after USB reconnect
alias pluto-tunnel='adb reverse tcp:8081 tcp:8081 && adb reverse tcp:8001 tcp:8001 && adb reverse tcp:8004 tcp:8004 && adb reverse tcp:8005 tcp:8005 && adb reverse tcp:8097 tcp:8097 && echo "✓ All Pluto tunnels active" && adb reverse --list'
