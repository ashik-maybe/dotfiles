# 🗂️ Dotfiles

## 🚀 Quick Start

Here’s how to get up and running:

### 1. Get [Zellij](https://zellij.dev/)

_A terminal workspace with batteries included._

```bash

mkdir  -p  ~/bin

```

⚠ Move the Zellij binary into `~/bin`

> Make sure `~/bin` is in your `PATH`.

### 2. Install [Alacritty](https://alacritty.org/index.html)

_Alacritty is a modern terminal emulator that comes with sensible defaults, but allows for extensive configuration._

```bash

sudo dnf install alacritty

```

### 3. Dependencies

This Zsh config uses some Lua-powered extensions, so;

```bash

sudo  dnf  install  lua

```

and these packages;

```bash

sudo  dnf  install  bat dust  fd-find  fzf  lsd  ripgrep  zoxide

```

### 4. Set Up Zsh

```bash

sudo  dnf  install  zsh

```

Make it the default shell;

```bash

chsh  -s $(which  zsh)

```

### 5. Install [Starship](https://starship.rs/) Prompt

```bash

curl  -sS  https://starship.rs/install.sh  |  sh

```

> Running the above line again would upgrade Starship

---

## 📦 Dotfiles Installation

```bash

cd  ~

sudo  dnf  install  git  stow

git  clone  https://github.com/ashik-maybe/dotfiles  ~/dotfiles

cd  ~/dotfiles

stow  .

source  ~/.zshrc

```

---

#### ▪ Fonts

- [Monaspace Variable](https://monaspace.githubnext.com/) for [VS Code](https://code.visualstudio.com/download)

- [MesloLGLDZNerdFont](https://www.nerdfonts.com/font-downloads) for [Alacritty](https://alacritty.org/index.html)

⚠ Store these fonts in **`~/.local/share/fonts`**

> If the `fonts` directory is not in `share` then create it
