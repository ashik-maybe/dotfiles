# Dotfiles

This repo stores shell, terminal, and editor configuration. GNU Stow links these files into your home directory.

## Install

1. Install fish, stow, and git.
2. Change your login shell to fish.
3. Clone this repo to `~/dotfiles`.
4. Run `stow .`.

```bash
sudo dnf install fish stow git
chsh -s "$(which fish)"
cd ~
git clone https://github.com/ashik-maybe/dotfiles ~/dotfiles
cd ~/dotfiles
stow .
```

## Fonts

Fonts live in `.fonts/`. Stow links them to `~/.fonts`. Fontconfig loads them automatically. Run `fc-cache -fv` only if a terminal does not see the font.

## Tools

Keep personal binaries in `~/bin`. Add `~/bin` to `PATH`. Fish already adds it.

## Troubleshooting

- Config not applied: run `stow .` again. Open a new shell.
- Stow conflict: back up the existing file in `~/.config/`. Run `stow --adopt .` again.
- Missing command in Fish: install the program from the Prerequisites table.

<details>
<summary>CONTEXT</summary>

This repo is the source of truth. The source of truth is the master copy.

Stow is a symlink manager. Stow links files from this repo into your home directory.

A tracked file is a file that this repo stores. A runtime file is a file that a tool creates at run time. Runtime files include secrets, tokens, sessions, cache, and logs. The AI does not commit runtime files. The AI does not stow runtime files. `.gitignore` excludes runtime files. `.stow-local-ignore` excludes runtime files from Stow.

</details>
