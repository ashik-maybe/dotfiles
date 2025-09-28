# 🗂️ Dotfiles

## 🚀 Quick Start

Here’s how to get up and running:

### 1. Install [Alacritty](https://alacritty.org/index.html)

_Alacritty is a modern terminal emulator that comes with sensible defaults, but allows for extensive configuration._

```bash

sudo dnf install alacritty

```

### 2. Dependencies

This Zsh config uses some Lua-powered extensions, so;

```bash

sudo  dnf  install  lua

```

and these packages;

```bash

sudo  dnf  install  bat btop dust duf fastfetch fd-find fzf lsd ripgrep zoxide

```

### 3. Set Up Zsh

```bash

sudo  dnf  install  zsh

```

Make it the default shell;

```bash

chsh  -s $(which  zsh)

```

### 4. Install [Starship](https://starship.rs/) Prompt

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

## 🗂️ Binary Files Installation

```bash

mkdir  -p  ~/bin

```

> Make sure `~/bin` is in your `PATH`.

### Get [Zellij](https://zellij.dev/)

_A terminal workspace with batteries included._

Download the **x86_64-unknown-linux-musl** binary from [here](https://github.com/zellij-org/zellij/releases/)

⚠ Move the `zellij` binary into `~/bin`

### Get [asdf](https://asdf-vm.com/)

_Manage all your runtime versions with one tool!_

Download the **linux-amd64** binary from [here](https://github.com/asdf-vm/asdf/releases/)

⚠ Move the `asdf` binary into `~/bin`

#### Get [Lazygit](https://github.com/jesseduffield/lazygit)

_A simple terminal UI for git commands_

Download the **linux_x86_64**
binary from from [here](https://github.com/jesseduffield/lazygit/releases/)

⚠ Move the `lazygit` binary into `~/bin`

#### Get [Lazydocker](https://github.com/jesseduffield/lazydocker)

_A simple terminal UI for both docker and docker-compose, written in Go with the gocui library._

Download the **linux_x86_64**
binary from from [here](https://github.com/jesseduffield/lazydocker/releases/)

⚠ Move the `lazydocker` binary into `~/bin`

---

#### ▪ Fonts

- [Monaspace Variable](https://monaspace.githubnext.com/) for [VS Code](https://code.visualstudio.com/download)

- [MesloLGLDZNerdFont](https://www.nerdfonts.com/font-downloads) for [Alacritty](https://alacritty.org/index.html)

⚠ Store these fonts in **`~/.local/share/fonts`**

> If the `fonts` directory is not in `share` then create it
