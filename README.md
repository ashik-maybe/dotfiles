# 🗂️ Dotfiles

Fish shell, terminal, and editor configuration for Fedora and Linux Mint. Managed with GNU Stow.

## Prerequisites

| Program | Purpose |
|---|---|
| fish | Shell |
| stow | Symlink manager |
| git | Version control |
| eza, bat, dust, duf, fdfind, tealdeer, tokei, yazi, zoxide, tree, less | Used by `functions/*.fish` |
| mise (optional) | Tool versions and project tasks |
| gh (optional) | GitHub pull-request abbreviations |
| podman, podman-compose (optional) | Container abbreviations |
| yt-dlp, aria2c, mpv (optional) | Download and media abbreviations |

## Install

```bash
sudo dnf install fish stow git
chsh -s "$(which fish)"
cd ~
git clone https://github.com/ashik-maybe/dotfiles ~/dotfiles
cd ~/dotfiles
stow .
```

On Linux Mint, replace `dnf` with `apt` and install the same programs.

## Apps

| App | Config | Theme | Font |
|---|---|---|---|
| fish | `.config/fish/` | — | — |
| alacritty | `.config/alacritty/` | Eye Care Night | JetBrainsMono Nerd Font Mono |
| kitty | `.config/kitty/` | Eye Care Night | JetBrainsMono Nerd Font Mono |
| foot | `.config/foot/` | Eye Care Night | JetBrainsMono Nerd Font Mono |
| zellij | `.config/zellij/` | Eye Care Night / Eye Care Day by OS | — |
| btop | `.config/btop/` | Eye Care Night | — |
| lazygit | `.config/lazygit/` | Eye Care Night | — |
| mpv | `.config/mpv/` | — | Roboto (subtitles) |
| VSCodium | `.config/VSCodium/User/settings.json`, `.config/VSCodium/product.json` | Modern Light / Modern Dark by OS | JetBrainsMono Nerd Font Mono |
| Zed | `.config/zed/` | Eye Care Day / Eye Care Night by OS | JetBrainsMono Nerd Font Mono |

Alternative themes are kept in each app's `themes/` directory. Select one in the app config to switch.

## Fonts

Fonts live in `.fonts/` and reach `~/.fonts` through Stow. Fontconfig picks them up without extra steps. Run `fc-cache -fv` only if a terminal does not see the font.

## Tools

Keep personal binaries in `~/bin` and add `~/bin` to `PATH`. Fish already adds it.

## Troubleshooting

- **Config not applied:** run `stow .` again, then open a new shell.
- **Stow conflict:** back up the existing file in `~/.config/`, then run `stow .` again.
- **Missing command in Fish:** install the program from the Prerequisites table.
