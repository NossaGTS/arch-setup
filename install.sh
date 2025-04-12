#!/usr/bin/bash

#Exit on any error
set -e
show_logo() {
  cat <<"EOF"
        .------..------..------..------.       .------..------..------..------..------..------..------..------..------.
        |A.--. ||R.--. ||C.--. ||H.--. | .-.   |I.--. ||N.--. ||S.--. ||T.--. ||A.--. ||L.--. ||L.--. ||E.--. ||R.--. |
        | (\/) || :(): || :/\: || :/\: |((5))  | (\/) || :(): || :/\: || :/\: || (\/) || :/\: || :/\: || (\/) || :(): |
        | :\/: || ()() || :\/: || (__) | '-.-. | :\/: || ()() || :\/: || (__) || :\/: || (__) || (__) || :\/: || ()() |
        | '--'A|| '--'R|| '--'C|| '--'H|  ((1))| '--'I|| '--'N|| '--'S|| '--'T|| '--'A|| '--'L|| '--'L|| '--'E|| '--'R|
        `------'`------'`------'`------'   '-' `------'`------'`------'`------'`------'`------'`------'`------'`------'
EOF
}
clear
show_logo

#source helper scripts and packages
#ensure packages.conf exists
if [ ! -f "packages.conf" ]; then
  echo "Error packages.conf not found!"
  exit 1
fi
source packages.conf
#ensure utils.sh script exists.
if [ ! -f "utils.sh" ]; then
  echo "Error utils.sh not found!"
  exit 1
fi

source utils.sh

#configure the system
configure_system
#update the system packages
update_system
#install packages system utils
install_packages "${SYSTEM_UTILS[@]}"
#install developer tools
install_packages "${DEV_TOOLS[@]}"
#install desktop environment
install_packages "${DESKTOP[@]}"
#install media players
install_packages "${MEDIA[@]}"
#install system fonts
install_packages "${FONTS[@]}"
#install yay packaage manager
install_yay
#install packages from AUR
install_yay_packages "${YAY[@]}"
#setup grub
#install flatpack packages
#. flatpacks.sh
. setup-dotfiles.sh

#enable important services
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &>/dev/null; then
    echo "Enabling $service.."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled."
  fi
done

sudo mkinitcpio -P

echo "Setup complete! Please reboot your system."
