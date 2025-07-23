# 🗂️ Dotfiles

---

## 🚀 Quick Start

Here’s how to get up and running:

### 1. Get Zellij (Terminal Multiplexer)

Download Zellij from [zellij.dev](https://zellij.dev/) and place the binary in your local bin:

```bash
mkdir -p ~/bin
# Move the Zellij binary into ~/bin
```

Make sure `~/bin` is in your `PATH`.

### 2. Install Foot Terminal

I prefer the [Foot terminal](https://codeberg.org/dnkl/foot):

```bash
sudo dnf install foot
```

### 3. Set Up Zsh

Install Zsh:

```bash
sudo dnf install zsh
```

Make it your default shell:

```bash
chsh -s $(which zsh)
```

### 4. Install Starship Prompt

You'll need [Starship](https://starship.rs/) for that sweet prompt setup:

```bash
curl -sS https://starship.rs/install.sh | sh
```

### 5. Dependencies

This Zsh config uses some Lua-powered extensions, so you’ll need Lua:

```bash
sudo dnf install lua
```

and these packages;

```bash
sudo dnf install bat fzf lsd zoxide
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

### Fonts

- ['Iosevka', 'Iosevka Term'](https://github.com/be5invis/Iosevka) for [VS Code](https://code.visualstudio.com/download)

- [MesloLGLDZNerdFont](https://www.nerdfonts.com/font-downloads) for [foot](https://codeberg.org/dnkl/foot)
