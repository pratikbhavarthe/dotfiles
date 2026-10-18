# env.zsh — shell options, history, interactive environment.

# ── History ──────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       # timestamps
setopt share_history          # live-share across sessions
setopt hist_ignore_dups       # skip consecutive duplicates
setopt hist_ignore_space      # " cmd" is not recorded (use for anything sensitive)
setopt hist_reduce_blanks
setopt hist_verify            # !! expands into the buffer instead of running

# ── Options ──────────────────────────────────────────────────────────
setopt interactive_comments
setopt auto_pushd pushd_ignore_dups pushd_silent
setopt no_beep

# ── Environment ──────────────────────────────────────────────────────
export AWS_PROFILE=pratik-pluto
export DOCKER_CONTEXT=desktop-linux
export EDITOR=nvim VISUAL=nvim    # git commit messages, rgf, fv, etc.

# bat follows the terminal's ANSI palette, so it inherits Vesper.
export BAT_THEME=ansi

# fzf: fd for file/dir sources (respects .gitignore), Vesper colors.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=none --info=inline-right \
--color=bg:-1,bg+:#1C1C1C,fg:#A0A0A0,fg+:#E6E1DA,hl:#FFC799,hl+:#FFC799 \
--color=info:#505050,prompt:#FFC799,pointer:#FFC799,marker:#99FFE4,spinner:#FFC799,header:#505050,border:#232323,gutter:-1"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
