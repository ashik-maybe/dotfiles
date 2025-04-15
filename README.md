# Dotfiles - Personal Linux Setup

This repository contains my personal dotfiles, configurations, and setup scripts for a clean and minimal Linux environment. The configuration covers various aspects of my system, including terminal setup, system optimizations, fonts, custom scripts, and theming.

## 📦 Contents

- **`setup.sh`**: Main script for setting up and configuring dotfiles.
- **`install-deps.sh`**: Script to install required dependencies.
- **`theme-setup.sh`**: A separate script for installing and setting up the WhiteSur icon theme and Phinger cursors.
- **`bin/`**: Custom scripts for daily tasks and automation.
- **`fonts/`**: Fonts used in the setup.
- **`config/`**: Configuration files for various applications like foot, etc.

## 🎨 Theme Setup

The `theme-setup.sh` script allows you to easily install the **WhiteSur icon theme** and **Phinger cursors** on your system. You can choose from a variety of color variants and configure the icons with bold and alternative options. Additionally, the script checks for the presence of GNOME Tweaks and installs it if necessary for GNOME users.

### 🛠️ Usage

1. Clone this repository:
    ```bash
    git clone https://github.com/ashik-maybe/dotfiles.git
    cd dotfiles
    ```

2. Run the theming setup script:
    ```bash
    ./theme-setup.sh
    ```

   This will install the WhiteSur icon theme and Phinger cursors, with options for customizing the icon theme and cursors.

### 🌈 Icon Theme Customization

During installation, you will be prompted to choose:
- **Color variant**: Select from options like default, purple, pink, red, orange, yellow, green, grey, or all.
- **Alternative icons**: Whether to install redesigned MacOS default icons.
- **Bold panel icons**: Whether to install bold icons, recommended for high-resolution displays.

### 🖱️ Cursor Installation

You can also opt to install **Phinger cursors**, which are available through the script.

### 📦 Sources
- WhiteSur Icons: [GitHub - WhiteSur Icons](https://github.com/vinceliuice/WhiteSur-icon-theme)
- WhiteSur GTK Theme: [GitHub - WhiteSur GTK](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- Phinger Cursors: [GitHub - Phinger Cursors](https://github.com/phisch/phinger-cursors)

## 🚀 Installation

You can use the provided installation scripts to easily configure your Linux system, install dependencies, set up icons, and customize your environment.

---

## ✨ Contributions

Feel free to fork this repository, contribute improvements, or submit issues for any bugs or suggestions.

---

Happy theming!
