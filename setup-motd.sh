#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo $0"
    exit 1
fi

# Update package lists
apt update -y

# Install dependencies
apt install -y curl wget fontconfig neofetch

# Install Oh My Posh
su -c "curl -s https://ohmyposh.dev/install.sh | bash -s" $SUDO_USER

# Download Oh My Posh theme
su -c "wget -q https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/powerlevel10k_rainbow.omp.json -O ~/froczh.omp.json" $SUDO_USER

# Set up Oh My Posh in .profile
su -c "echo 'eval \"\$(oh-my-posh init bash --config ~/froczh.omp.json)\"' >> ~/.profile" $SUDO_USER

# Download Neofetch theme and apply it
wget -q https://raw.githubusercontent.com/chick2d/neofetch-themes/refs/heads/main/normal/config2.conf -O /tmp/config2.conf
mkdir -p /home/$SUDO_USER/.config/neofetch
rm -f /home/$SUDO_USER/.config/neofetch/config.conf
mv /tmp/config2.conf /home/$SUDO_USER/.config/neofetch/config.conf
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/neofetch

# Download Neofetch ASCII art
wget -q https://raw.githubusercontent.com/blyxyas/uwu-neofetch-art/refs/heads/main/colored/sailor-moon-cat.txt -O /home/$SUDO_USER/.config/neofetch/logo
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/neofetch/logo

# Set up Neofetch in profile script
echo "neofetch --ascii ~/.config/neofetch/logo --ascii_colors 7 11" > /etc/profile.d/mymotd.sh
chmod +x /etc/profile.d/mymotd.sh

# Install Material Design Icons font
wget -q https://github.com/Templarian/MaterialDesign-Font/blob/master/MaterialDesignIconsDesktop.ttf -O /usr/share/fonts/MaterialDesignIconsDesktop.ttf
fc-cache -fv

# Disable Ubuntu default MOTD
chmod -x /etc/update-motd.d/*

echo "Setup complete! Restart or re-login for changes to take effect."
