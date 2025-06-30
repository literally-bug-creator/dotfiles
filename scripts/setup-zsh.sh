#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Installing Zsh, Oh My Zsh, Powerlevel10k, and essential tools..."

# 1. Install dependencies
# ttf-meslo-nerd is the recommended font for Powerlevel10k
# bat is for the `cat` alias
echo "--> Installing dependencies: zsh, git, curl, fzf, ttf-meslo-nerd, bat..."
sudo pacman -S --noconfirm --needed zsh git curl fzf ttf-meslo-nerd bat

# 2. Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "--> Oh My Zsh is already installed. Skipping."
else
    echo "--> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Install plugins and theme
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
echo "--> Installing plugins and theme..."

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "  -> zsh-autosuggestions already installed. Skipping."
else
    echo "  -> Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "  -> zsh-syntax-highlighting already installed. Skipping."
else
    echo "  -> Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
fi

# Powerlevel10k theme
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "  -> Powerlevel10k already installed. Skipping."
else
    echo "  -> Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
fi

# 4. Create the .zshrc configuration file
echo "--> Creating .zshrc configuration file..."
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    echo "  -> Found existing .zshrc. Backing up to .zshrc.pre-script-backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.pre-script-backup"
fi

# Note: Using a full path for the sshc alias for robustness.
cat << 'EOF' > "$HOME/.zshrc"
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize Powerlevel10k, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# List of plugins.
# fzf must be loaded before zsh-syntax-highlighting.
# zsh-syntax-highlighting must be the last plugin loaded.
plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# FZF configuration (from Arch package)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# User configuration
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANROFFOPT="-c"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='code'
# fi

# Add ~/.local/bin to the path
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo pacman -Syu'
alias cat='bat --paging=never' # Use bat instead of cat
alias sshc='$HOME/Documents/dotfiles/scripts/ssh-fzf.sh' # SSH connection helper

# Yazi file manager integration
# When you exit yazi, you will be in the directory you were browsing
yazi() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    if [ -f "$tmp" ]; then
        cd "$(cat "$tmp")"
        rm -f "$tmp"
    fi
}
EOF

# 5. Change the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "--> Changing default shell to Zsh. Please enter your password if prompted."
    chsh -s $(which zsh)
    if [ $? -eq 0 ]; then
        echo "--> Shell changed successfully."
    else
        echo "--> Failed to change shell. Please do it manually with: chsh -s $(which zsh)"
    fi
else
    echo "--> Default shell is already Zsh. Skipping."
fi

echo ""
echo "✅ Zsh and Powerlevel10k setup complete!"
echo ""
echo "IMPORTANT NEXT STEPS:"
echo "1. Configure your terminal emulator (e.g., GNOME Terminal, Konsole) to use the"
echo "   'MesloLGS NF' font for Powerlevel10k to render correctly."
echo "2. Close and reopen your terminal. The Powerlevel10k configuration wizard"
echo "   should start automatically. If it doesn't, run 'p10k configure'."
echo ""
echo "You may need to log out and log back in for all changes to apply."
