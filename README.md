# 🗂️ Dotfiles

[![GNU](https://img.shields.io/badge/GNU-Stow-000000?logo=gnu&logoColor=white)](#)
[![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)](#)
[![Fedora](https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=fff)](#)
[![Mint](https://img.shields.io/badge/Linux_Mint-87CF3E?logo=linuxmint&logoColor=fff)](#)

## 🚀 Quick Start

Here’s how to get up and running:

### 1. Install Fish and Dependencies

Install Fish shell:

```bash
sudo dnf install fish
```

Install CLI tools:

```bash
sudo dnf install unzip unrar 7zip
sudo dnf install stow
```

### 2. Set Fish as Your Default Shell

```bash
chsh -s $(which fish)
```

> Running the above line again would upgrade Starship

---

## 📦 Dotfiles Installation

```bash
cd  ~
git  clone  https://github.com/ashik-maybe/dotfiles  ~/dotfiles
cd  ~/dotfiles
stow  .
```

---

## 🗄️ Programs

```bash
mkdir -p ~/bin
```

> ⚠ Keep the binaries into `~/bin` and make sure `~/bin` is in your `PATH`.

<!--
### [mise-en-place](https://mise.jdx.dev/)

_The front-end to your dev env_

```bash
curl https://mise.run | sh
```
-->

---

#### Fonts

> Store fonts in **`~/.local/share/fonts`** or **`~/.fonts`** and run `fc-cache -fv`

<!--[Commit Mono](https://commitmono.com/)-->
<!--[JetBrains Mono](https://www.jetbrains.com/lp/mono/)-->
<!--[Maple Mono](https://github.com/subframe7536/Maple-font)-->

---
