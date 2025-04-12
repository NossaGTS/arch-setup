#!/bin/bash

update_system() {
  echo "Updating pacman..."
  sudo -k pacman -Syu --noconfirm
}

install_yay() {
  if ! pacman -Qs | grep -q "yay"; then
    echo "Installing yay onto the system."
    cd "$HOME/Documents/" || exit
    git clone https://aur.archlinux.org/yay.git
    cd "yay" || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf "yay"
  else
    echo "Yay is alreading installed."
  fi
}

install_packages() {
  local packages=("$@")
  for package in "${packages[$@]}"; do
    if ! pacman -Qs | grep -q "$package"; then
      echo "Installing $package..."
      sudo pacman -S "$package" --noconfirm
    else
      echo "$package is already installed."
    fi
  done
}

install_yay_packages() {
  local packages=("$@")
  for package in {packages[$@]}; do
    if ! pacman -Qs | grep -q "$package"; then
      echo "installing package"
      sudo pacman -S "$package" --noconfirm
    else
      echo "$package is already installed."
    fi
  done
}

configure_system() {
  echo "setting timezone to Eastern Standard Time"
  sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
  sudo hwclock --systohc

  #generate locale
  sudo locale-gen
  echo "LANG=en_US.UTF-8" | sudo tee -a /etc/locale.conf

  #configure hostname
  read -p "Enter your hostname: " hostname
  echo $hostname | sudo tee -a /etc/hostname

  #install xorg
  sudo pacman -S xorg-server xorg-xinit xorg-xsetroot xorg-xrandr xorg-xset xorg-xkill --noconfirm

  #install graphics drivers
  read -p "which type of graphics card do you have nvidia or amd? " graphicscard
  if [[ $graphicscard -eq "nvidia" ]]; then
    echo "Installing nvidia drivers"
    read -p "Do you wan't opensource or proprietary drivers? " driver
    if [[ $driver -eq "proprietary" ]]; then
      sudo pacman -S nvidia nvidia-utils nvidia-settings --noconfirm
    elif [[ $driver -eq "opensource" ]]; then
      sudo pacman -S nouveau --noconfirm
    else
      echo "Invalid input"
    fi
  elif [[ $graphicscard -eq "amd" ]]; then
    echo "Installing AMD drivers"
    read -p "Do you wan't opensource or proprietary drivers? " driver
    if [[ $driver -eq "proprietary" ]]; then
      sudo pacman -S amdgpu-pro --noconfirm
    elif [[ $driver -eq "opensource" ]]; then
      sudo pacman -S amdgpu --noconfirm
    else
      echo "Invalid input"
    fi
  else
    echo "Invalid input"
  fi
}
