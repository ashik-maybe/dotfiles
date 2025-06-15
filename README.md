# 🗂️ Dotfiles by ashik-maybe

This repo contains my personal dotfiles. They're designed for a **fresh Linux installation** (Fedora in particular), and reflect my preferred terminal, shell, fonts, and more.

> ⚠️ **Note:** These configs are pretty specific to my setup — tweak as needed for your own!

---

## 🚀 Quick Start

Here’s how to get up and running:

### 1. Install Nerd Font (Hack)

Download the [Hack Nerd Font](https://www.nerdfonts.com/font-downloads) and place it in your fonts directory:

```bash
mkdir -p ~/.local/share/fonts
# Move the downloaded font file into this directory
```

### 2. Get Zellij (Terminal Multiplexer)

Download Zellij from [zellij.dev](https://zellij.dev/) and place the binary in your local bin:

```bash
mkdir -p ~/bin
# Move the Zellij binary into ~/bin
```

Make sure `~/bin` is in your `PATH`.

### 3. Install Foot Terminal

I prefer the [Foot terminal](https://codeberg.org/dnkl/foot):

```bash
sudo dnf install foot
```

### 4. Set Up Zsh

Install Zsh:

```bash
sudo dnf install zsh
```

Make it your default shell:

```bash
chsh -s $(which zsh)
```

### 5. Install Starship Prompt

You'll need [Starship](https://starship.rs/) for that sweet prompt setup:

```bash
curl -sS https://starship.rs/install.sh | sh
```

### 6. Lua Dependency

My Zsh config uses some Lua-powered extensions, so you’ll need Lua:

```bash
sudo dnf install lua
```

---

## 📦 Dotfiles Installation

Now for the fun part — cloning and stowing:

```bash
cd ~
sudo dnf install git stow
git clone https://github.com/ashik-maybe/dotfiles ~/.dotfiles
cd ~/.dotfiles
stow .
source ~/.zshrc
```

---

## 📌 Notes

* These dotfiles are designed for **Fedora**, but can be adapted for other distros.
* You’ll want to tweak some things if your environment differs (e.g., paths, shells, fonts).
