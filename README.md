# dotfiles

macOS (Apple Silicon) terminal setup: **Ghostty · Vesper · zsh · Starship · Neovim (LazyVim) · tmux · atuin**.
Everything is themed with [Vesper](https://github.com/raunofreiberg/vesper).
Shell startup ≈ 155 ms. Neovim, tmux, atuin and gh-dash adapted from [omerxx/dotfiles](https://github.com/omerxx/dotfiles).

**Daily keys and commands: [CHEATSHEET.md](CHEATSHEET.md)**

## Layout

| Folder | Installs to |
|---|---|
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` |
| `zsh/zshrc`, `zprofile`, `zshenv` | `~/.zshrc`, `~/.zprofile`, `~/.zshenv` |
| `zsh/modules/` (`env` `completion` `plugins` `aliases` `functions`) | `~/.config/zsh/` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `nvim/` | `~/.config/nvim/` |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` (plugins via TPM, not committed) |
| `atuin/` | `~/.config/atuin/` |
| `gh-dash/config.yml` | `~/.config/gh-dash/config.yml` |
| `git/gitconfig` | included from `~/.gitconfig` (identity stays local) |
| `Brewfile` | `brew bundle` |

## Install

```sh
git clone https://github.com/pratikbhavarthe/dotfiles ~/dotfiles
cd ~/dotfiles
brew bundle --file=Brewfile
./install.sh --dry-run   # preview
./install.sh             # symlink; existing files go to ~/.config/shell-backups/install-<time>/
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm   # then prefix I inside tmux
nvim                     # first launch installs plugins
```

Machine-specific shell settings go in `~/.config/zsh/local.zsh` (git-ignored).

---

## Ghostty shortcuts (macOS defaults, verified on 1.3.1)

| Keys | Action |
|---|---|
| ⌘T / ⌘N / ⌘W | New tab / window / close |
| ⌘D / ⌘⇧D | Split right / down |
| ⌘⌥ ← ↑ ↓ → | Move between splits |
| ⌘[ / ⌘] | Previous / next split |
| ⌘⇧↵ · ⌘⌃= | Zoom split · equalize splits |
| ⌘1…9 · ⌘⇧[ / ⌘⇧] | Go to tab · prev/next tab |
| ⌘F · ⌘G / ⌘⇧G · ⌘E | Search scrollback · next/prev · search selection |
| ⌘↑ / ⌘↓ | Jump to previous / next prompt |
| ⌘K | Clear screen and scrollback |
| ⌘+ / ⌘- / ⌘0 | Font size |
| ⌘⇧, | Reload config |
| ⌘⇧P | Command palette |

Full list: `/Applications/Ghostty.app/Contents/MacOS/ghostty +list-keybinds`

## Shell shortcuts and helpers

| | |
|---|---|
| ^R | atuin history search (^R again cycles global/host/session/dir; Enter runs, Tab edits) |
| ^T / ⌥C | fzf insert file / cd into dir |
| → or ^E / ⌥→ | Accept suggestion / one word |
| `fv [q]` · `fcp [q]` · `cx <dir>` | Fuzzy-open file in nvim · copy a file's path · cd + list |
| `..` `...` `....` · `v` | Up 1/2/3 dirs · nvim |
| `glog` | Two-line graph log (date, author) |
| `gdash` | gh-dash: My PRs / Needs review / Pluto org / Involved |
| `kg kd kl ke kgpo kgd kcns` | kubectl get/describe/logs -f/exec/pods/deployments/set namespace |
| `dx dpa` | docker exec -it / ps -a |
| `z foo` / `zi` | zoxide jump / interactive |
| `repo [q]` | Jump to a git repo under ~/Pluto, ~/Developer, ~/Projects |
| `gsw [q]` | Switch branch (local or remote), most recent first |
| `rgf <pattern>` | ripgrep → fzf preview → open in `$EDITOR` (default nvim) at the line |
| `dlogs [q]` | Follow logs of a running container |
| `kctx [ctx]` | Show / switch kube context (warns on `*prod*`) |
| `awsp [profile]` | Set `AWS_PROFILE` for this shell (warns on `*prod*`) |
| `proj dev\|test\|build\|lint` | Runs cargo / go / bun / pnpm / yarn / npm as appropriate |
| `gs gd gds gb glg gl gp lg` | git status/diff/staged/branches/log/pull/push, lazygit |
| `ls ll lt` | eza: plain / long with git status / tree |
| ` cmd` (leading space) | Not saved to history — use for anything containing secrets |

Prompt warnings: `k8s PROD <ctx>` (red) in k8s dirs when the context matches `prod`;
`⚠ PROD` when `AWS_PROFILE` matches `prod`. The default `pratik-pluto` profile is hidden;
any other profile shows as `aws <name>`.

## Neovim (LazyVim)

`nvim` / `v`. Leader is Space; press it and wait for which-key to list everything.
Languages: Go, Rust, TypeScript, Docker, Helm, YAML, JSON, TOML, Terraform, Markdown.
LSPs/formatters/debuggers come from Mason (`:Mason`); parsers from treesitter.

| Keys | Action |
|---|---|
| `jj` / `jk` | Leave insert mode |
| `<leader><space>` · `<leader>/` | Find files · grep |
| `<leader>e` · `<leader>fm` | File explorer · mini.files |
| `<leader>H` · `<leader>1…5` | Harpoon: mark file · jump to mark |
| `gsa` / `gsd` / `gsr` | Surround add / delete / replace |
| `<leader>gg` | lazygit |
| `<leader>d…` | Debugger (dap) |
| `:Lazy` · `:Mason` · `:LazyExtras` | Plugins · tools · enable/disable language packs |

Differences from omerxx: Vesper theme (italics on comments only), Rust + TOML added,
opencode/Codeium plugins left out, surround kept on LazyVim's `gs` prefix (his `sa`/`sd`
collide with flash's `s`).

## tmux (on demand)

Ghostty tabs/splits stay primary; start `tmux` for persistent sessions (SSH, long jobs).
Sessions auto-save every 15 min and restore when the tmux server starts.

| Keys (after ^A) | Action |
|---|---|
| `o` | sessionx — fuzzy session picker (zoxide + ~/Pluto) |
| `p` | floax — floating scratch pane |
| `u` | fzf-url — open a URL from the screen |
| `v` / `s` | Split side-by-side / stacked (keeps cwd) |
| `h j k l` · `H` / `L` | Move between panes · prev/next window |
| `^C` · `^A` · `z` | New window · last window · zoom pane |
| `c` | Kill pane (asks first) |
| `[` then `v`…`y` | Copy mode, select, yank to clipboard |
| `a` | Send a literal ^A (shell beginning-of-line) |
| `R` · `I` / `U` | Reload config · install / update plugins |

## atuin

History lives in a local SQLite DB (`~/.local/share/atuin`); sync and update checks are off.
Commands that look like secrets are not recorded (`secrets_filter` + `history_filter`).
`atuin stats` shows usage; `atuin search <q>` works non-interactively.

## Node (fnm)

- `fnm default 22` is the global default; `.nvmrc` / `.node-version` switch automatically on `cd`.
- v18/v20/v24 are symlinks to the old nvm installs (globals preserved). nvm itself is no longer loaded.
- `~/.nvm/versions/node/v20.19.4/bin` is appended to PATH (last) only so `clawdbot`, `devcontainer`,
  `pluto-icons`, `expo-internal` keep working. Reinstall them under fnm (`npm i -g …`) and drop that line.
- `fnm install 24`, `fnm use 20`, `fnm list`.

