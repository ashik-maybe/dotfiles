### Dotfiles  
Minimal GNU Stow-managed dotfiles setup  

---

#### 🧰 Install  
```bash
# Install dependencies  
sudo dnf install git stow  

# Clone repo  
git clone https://github.com/YOUR_USERNAME/dotfiles ~/.dotfiles  

# Apply configs  
cd ~/.dotfiles  
stow .  

# Install Starship (if needed)  
curl -sS https://starship.rs/install.sh | sh  

# Reload shell  
source ~/.zshrc  
```

---

#### 🔁 Revert  
```bash  
# Remove symlinks  
cd ~/.dotfiles  
stow -D .  

# Delete repo (optional)  
rm -rf ~/.dotfiles  
```  

---

#### 📁 Structure  
- `.zshrc` (Zinit/Zsh config)  
- `.config/foot/foot.ini`  
- `.fonts/` (Fonts like Bengali, Windows11 etc.)  

---

#### ⚠️ Notes  
- Back up existing files before `stow` (e.g., `~/.zshrc.bak`)  
- Fonts require `fc-cache -fv` after install  
- Add new configs to `~/dotfiles/`, then rerun `stow .`  
- No fluff. Just works.