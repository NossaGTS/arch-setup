PACKAGES=(
  spotify
  discord
)

for pak in "${PACKAGES[@]}"; do
  if flatpak list | grep -q "$pak"; then
    echo "Flatpak $pak is already installed."
  else
    echo "Installing Flatpak $pak..."
    flatpak install flathub "$pak" --noninteractive
  fi
done
