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

### 3. Install [Starship](https://starship.rs/) Prompt

```bash
curl  -sS  https://starship.rs/install.sh  |  sh
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

**▪ Fonts**
<!--
- [JetBrains Mono](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip)

- [Hack](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip) for _Terminal_
-->

- [Intel One Mono](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IntelOneMono.zip)

⚠ Store these fonts in **`~/.local/share/fonts`**

> If the `fonts` directory is not in `share` then create it

_Or just paste this in your terminal;_

```bash
mkdir -p ~/.local/share/fonts/IntelOneMonoNerdFont && \
cd /tmp && \
curl -fLo IntelOneMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IntelOneMono.zip && \
unzip IntelOneMono.zip -d ~/.local/share/fonts/IntelOneMonoNerdFont && \
fc-cache -fv
```

- [Windows Fonts](https://github.com/ashik-maybe/fonts-windows)
- [Bangla Fonts](https://github.com/ashik-maybe/fonts-bengali)
