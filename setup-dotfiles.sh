#!/usr/bin/bash

REPO_URL="https://github.com/NossaGTS/dotfiles2.git"
REPO_NAME="dotfiles2"

is_stow_installed() {
  pacman -Qi "stow" &>/dev/null
}

if ! is_stow_installed; then
  echo "stow is not installed. Please install stow first."
  exit 1
fi

cd ~ || exit

if [ -d "$REPO_NAME" ]; then
  echo "Repository already exists. Please remove it first."
else
  git clone "$REPO_URL"
fi

if [ $? -eq 0 ]; then
  cd "$REPO_NAME" || exit
  cp -r ./zsh/.zshrc ~/.zshrc
  cp -r ./zsh/.oh-my-zsh ~/.oh-my-zsh/
  cp -r ./ghostty ~/.config/ghostty
  cp -r ./nvim ~/.config/nvim
  cp -r ./i3 ~/.config/i3
  cp -r ./polybar ~/.config/polybar
  cp -r ./rofi ~/.config/rofi
  cp ./tmux/.tmux.conf ~/.tmux.conf
  cp -r ./tmux ~/.tmux
else
  echo "Failed to clone the repository"
  exit 1
fi
