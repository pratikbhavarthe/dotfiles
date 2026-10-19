# Cheatsheet

Day-to-day keys and commands for this setup. Full details: [README.md](README.md).

**Start here:** new tab → `Ctrl-R` (history) → `repo` (jump to a project) → `gs` (git status).

---

## Moving around

| You want to… | Type |
|---|---|
| Jump to a project | `repo` · `repo pilot` |
| Jump to a folder you've been to | `z pilot` · `zi` (pick from list) |
| cd into any subfolder here | `⌥C` (left Option) |
| Go up 1 / 2 / 3 folders | `..` · `...` · `....` |
| List files | `ls` · `ll` (long + git status) · `lt` (tree) |
| cd and list | `cx <dir>` |
| Accept the grey suggestion | `→` or `Ctrl-E` · one word: `⌥→` |

## History — atuin

| | |
|---|---|
| `Ctrl-R` | Search everything you've ever run |
| `Ctrl-R` (again, inside) | Cycle scope: global → host → session → **this directory** |
| `Enter` / `Tab` | Run it now / put it on the line to edit |
| ` command` (leading space) | Not saved to history — use for secrets |
| `atuin stats` | Most-used commands |

## Finding things in code

| | |
|---|---|
| `rgf <pattern>` | ripgrep → preview → `Enter` opens Neovim at that line |
| `fv [q]` | Fuzzy-open a file in Neovim |
| `fcp [q]` | Copy a file's absolute path |
| `Ctrl-T` | Insert a file path into the current command |

## Git

| | |
|---|---|
| `gs` · `gd` · `gds` | status · diff · staged diff (delta, Vesper colors) |
| `gl` · `gp` | pull · push |
| `gb` · `gsw [q]` | branches by recency · fuzzy switch branch |
| `glg` · `glog` | one-line graph · two-line graph with date/author |
| `lg` | lazygit (stage, commit, rebase, resolve) |
| `gdash` | GitHub dashboard: my PRs, needs review, Pluto, issues (`?` for keys) |
| `git as` · `git as personal\|work\|admin` (run inside a repo) | Show / switch which GitHub account this repo commits, signs and pushes as (also switches `gh`) |

## Ghostty — tabs & splits (default workflow)

| | |
|---|---|
| `⌘T` · `⌘N` · `⌘W` | New tab · new window · close |
| `⌘1…9` · `⌘⇧[` `⌘⇧]` | Go to tab · previous/next tab |
| `⌘D` · `⌘⇧D` | Split right · split down |
| `⌘⌥ ← ↑ ↓ →` · `⌘[` `⌘]` | Move between splits |
| `⌘⇧↵` · `⌘⌃=` | Zoom split · equalize splits |
| `⌘F` · `⌘G` / `⌘⇧G` | Search scrollback · next / previous match |
| `⌘↑` · `⌘↓` | Jump to previous / next command |
| `⌘K` | Clear screen |
| `⌘+` `⌘-` `⌘0` | Font size |
| `⌘⇧,` · `⌘⇧P` | Reload config · command palette |

## tmux — when sessions must survive

Use for dev servers, long jobs, and SSH. Start: `tmux new -s name` · reattach: `tmux attach`.

**Prefix is `Ctrl-A`** — press it, release, then the key.

| `Ctrl-A` then | |
|---|---|
| `d` | Detach (keeps running) |
| `o` | Session picker (zoxide + ~/Pluto) |
| `S` | List sessions |
| `v` · `s` | Split side-by-side · stacked |
| `h` `j` `k` `l` | Move between panes |
| `z` | Zoom pane |
| `Ctrl-C` · `H` / `L` | New window · previous / next window |
| `Ctrl-A` | Last window |
| `p` | Floating scratch pane |
| `u` | Open a URL from the screen |
| `[` → `v` … `y` | Copy mode: select, yank to clipboard |
| `r` · `c` | Rename window · close pane (asks) |
| `a` | Send a literal `Ctrl-A` (start of line) |
| `R` · `I` · `U` | Reload config · install plugins · update plugins |

Sessions auto-save every 15 min and restore when tmux starts.

## Neovim (LazyVim)

Open: `nvim .` or `v file`. **Press `Space` and wait** — which-key shows everything.

| | |
|---|---|
| `jj` / `jk` | Leave insert mode |
| `Space Space` · `Space /` | Find file · search project |
| `Space e` · `Space fm` | File tree · mini.files |
| `Space ,` | Switch buffer |
| `gd` · `gr` · `K` | Definition · references · hover docs |
| `Space ca` · `Space cr` | Code action · rename symbol |
| `Space cf` | Format file |
| `]d` / `[d` | Next / previous diagnostic |
| `Space H` · `Space h` · `Space 1…5` | Harpoon: pin file · menu · jump |
| `gsa` · `gsd` · `gsr` | Surround add / delete / replace |
| `s` | Flash jump (type 2 chars) |
| `Space gg` | lazygit |
| `Space d…` | Debugger |
| `:Lazy` · `:Mason` · `:LazyExtras` | Plugins · language tools · language packs |
| `:w` · `:q` · `:wq` | Save · quit · both |

New to Vim: `:Tutor` (≈20 min).

## Project & infra helpers

| | |
|---|---|
| `proj dev\|test\|build\|lint` | Runs cargo / go / bun / pnpm / yarn / npm for the current project |
| `dlogs [q]` · `dps` · `dpa` · `dx <c> sh` | Follow container logs · running · all · exec |
| `dc` · `dcu` · `dcd` | docker compose · up · down |
| `kctx [ctx]` · `kcns <ns>` | Switch kube context (warns on prod) · set namespace |
| `kg` · `kd` · `kl` · `ke` | kubectl get · describe · logs -f · exec -it |
| `awsp [profile]` | Switch AWS profile for this shell (warns on prod) |
| `fnm list` · `fnm use 20` | Node versions (auto-switches on `.nvmrc`) |
| `uv venv` · `uv pip install -r requirements.txt` | Python project env in `.venv` |
| `uv run script.py` · `uv python install 3.13` | Run in project env · add a Python version |
| `pluto-tunnel` | Restore ADB reverse tunnels |

## Reading the prompt

```
( ~/Pluto/pluto-pilot) ( feat/x ↑1 ~3 ?2 +1) ( 22.23.3)
3s  ✘ 1  pratik ❯
```

| | |
|---|---|
| amber name | Repo root |
| `↑` `↓` | Commits ahead / behind remote |
| `~` `?` `+` | Modified · untracked · staged |
| stash icon + number | Stash count |
| version bubbles | Only for tools the project uses |
| `3s` | Last command took > 0.5 s |
| `✘ 1` · red `❯` | Last command failed (exit code) |
| red **PROD** | Production AWS profile or kube context — careful |

## Maintenance

```sh
cd ~/dotfiles && git add -A && git commit -m "…" && git push   # configs are symlinked here
brew bundle --file=~/dotfiles/Brewfile                          # install/update tools
ZPROF=1 zsh -i -c exit                                          # profile shell startup
starship explain                                                # what's in the prompt and why
```
