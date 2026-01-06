# 🗂️ Dotfiles

[![GNU](https://img.shields.io/badge/GNU-Stow-000000?logo=gnu&logoColor=white)](#)
[![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)](#)
[![Fedora](https://img.shields.io/badge/Fedora-51A2DA?logo=fedora&logoColor=fff)](#)

## 🚀 Quick Start

Here’s how to get up and running:

### 1. Install [foot](https://codeberg.org/dnkl/foot)

```bash
sudo dnf install foot
```

### 2. Install Fish and Dependencies

Install Fish shell:

```bash
sudo dnf install fish
```

Install CLI tools:

```bash
sudo dnf install bat btop dust duf fastfetch fd-find fzf lsd ripgrep zoxide stow
```

### 3. Set Fish as Your Default Shell

```bash
chsh -s $(which fish)
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
git  clone  https://github.com/ashik-maybe/dotfiles  ~/dotfiles
cd  ~/dotfiles
stow  .
```

---

## 🗄️ Programs

```bash
mkdir -p ~/bin
```

> Make sure `~/bin` is in your `PATH`.

### [Zellij](https://zellij.dev/)

_A terminal workspace with batteries included._

Download the **x86_64-unknown-linux-musl** binary from [here](https://github.com/zellij-org/zellij/releases/)

<small> ⚠ Move the `zellij` binary into `~/bin` </small>

### [Zed](https://zed.dev/)

_Zed is a minimal code editor crafted for speed and collaboration with humans and AI._

```bash
curl -f https://zed.dev/install.sh | sh
```

### [bun](https://bun.sh/)

_Bun is a fast, incrementally adoptable all-in-one JavaScript, TypeScript & JSX toolkit._

```bash
curl -fsSL https://bun.sh/install | bash
```

### [mise-en-place](https://mise.jdx.dev/)

_The front-end to your dev env_

```bash
curl https://mise.run | sh
```

### [uv](https://docs.astral.sh/uv/)

_An extremely fast Python package and project manager, written in Rust._

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

<!--### [Helium Browser](https://helium.computer/)

_Internet without interruptions_

Download the [Linux AppImage (64-bit)](https://helium.computer/) and move the `helium.AppImage` into `~/bin/appimages` and make it executable with `chmod +x ~/bin/appimages/helium.AppImage`

<small> ⚠ Get the icon for the `.desktop` from [here](https://github.com/imputnet/helium/blob/main/resources/branding/product_logo.svg), put that `.svg` in `~/.local/share/icons/` and the `.desktop` should be made at `~/.local/share/applications/` </small>-->

### [Jujutsu](https://www.jj-vcs.dev/latest/)

_A version control system_

Download the **x86_64-unknown-linux-musl**
binary from from [here](https://github.com/jj-vcs/jj/releases/latest)

<small> ⚠ Move the `jj` binary into `~/bin` </small>

### [Lazygit](https://github.com/jesseduffield/lazygit)

_A simple terminal UI for git commands_

Download the **linux_x86_64**
binary from from [here](https://github.com/jesseduffield/lazygit/releases/)

<small> ⚠ Move the `lazygit` binary into `~/bin` </small>

### [Lazydocker](https://github.com/jesseduffield/lazydocker)

_A simple terminal UI for both docker and docker-compose, written in Go with the gocui library._

Download the **linux_x86_64**
binary from from [here](https://github.com/jesseduffield/lazydocker/releases/)

<small> ⚠ Move the `lazydocker` binary into `~/bin` </small>

---

**▪ Fonts**

<!-- - [JetBrains Mono](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip) for _VS Code_ -->

<!-- - [Hack](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip) for _Terminal_ -->

- [Intel One Mono](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IntelOneMono.zip)

⚠ Store these fonts in **`~/.local/share/fonts`**

> If the `fonts` directory is not in `share` then create it

_Or just paste this in your terminal;_

```bash
mkdir -p ~/.local/share/fonts && \
cd /tmp && \
curl -fLo IntelOneMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IntelOneMono.zip && \
unzip IntelOneMono.zip -d ~/.local/share/fonts && \
fc-cache -fv
```

- [Windows Fonts](https://github.com/ashik-maybe/fonts-windows)
- [Bangla Fonts](https://github.com/ashik-maybe/fonts-bengali)
