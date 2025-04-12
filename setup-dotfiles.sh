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
  echo "linking config files"
  ln -s ./zsh/.zshrc ~/.zshrc
  ln -s ./zsh/.oh-my-zsh ~/.oh-my-zsh/
  ln -s ./ghostty ~/.config/ghostty
  ln -s ./nvim ~/.config/nvim
  ln -s ./i3 ~/.config/i3
  ln -s ./polybar ~/.config/polybar
  ln -s ./rofi ~/.config/rofi
  ln -s ./tmux/.tmux.conf ~/.tmux.conf
  ln -s ./tmux ~/.tmux
  ln -s ./local/bin/scripts ~/.local/bin/scripts
else
  echo "Failed to clone the repository"
  exit 1
fi
