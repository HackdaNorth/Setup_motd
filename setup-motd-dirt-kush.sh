#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try: sudo $0"
    exit 1
fi

# Update package lists
apt update -y

# Install dependencies
apt install -y curl wget fontconfig neofetch unzip

# Install Oh My Posh
su -c "curl -s https://ohmyposh.dev/install.sh | bash -s" $SUDO_USER

# Download Oh My Posh theme
su -c "wget -q https://raw.githubusercontent.com/HackdaNorth/Setup_motd/refs/heads/main/Dirt_kush.json -O ~/dirt_kush.omp.json" $SUDO_USER

# Set up Oh My Posh in .profile
su -c "echo 'eval \"\$(oh-my-posh init bash --config ~/dirt_kush.omp.json)\"' >> ~/.profile" $SUDO_USER

# Download Neofetch theme and apply it
wget -q https://raw.githubusercontent.com/HackdaNorth/Setup_motd/refs/heads/main/chick2d.conf -O /tmp/config2.conf
mkdir -p /home/$SUDO_USER/.config/neofetch
rm -f /home/$SUDO_USER/.config/neofetch/config.conf
mv /tmp/config2.conf /home/$SUDO_USER/.config/neofetch/config.conf
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/neofetch

# Download Neofetch ASCII art
wget -q https://raw.githubusercontent.com/HackdaNorth/Setup_motd/refs/heads/main/logo -O /home/$SUDO_USER/.config/neofetch/logo
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
