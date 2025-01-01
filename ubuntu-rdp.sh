#!/bin/bash

# Desktop Setup
echo "Updating system..."
sudo apt-get update && sudo apt-get -y upgrade
sleep 2

echo "Installing essential utilities..."
sudo apt-get install -y mc git htop make rsync telnet whiptail ubuntu-gnome-desktop gnome-software
sleep 2

echo "Enabling GDM3 and XRDP..."
sudo systemctl enable --now gdm3
sudo apt-get install -y xrdp
sudo systemctl enable --now xrdp
sudo systemctl start xrdp
sleep 2

# System Configuration
echo "Configuring system settings..."
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w net.core.wmem_max=8388608
echo "net.core.wmem_max = 8388608" | sudo tee /etc/sysctl.d/xrdp.conf > /dev/null
sudo sysctl --system
sleep 2

# Modify XRDP settings
echo "Configuring XRDP settings..."
sudo sed -i 's/^port=3389/port=3388/' /etc/xrdp/xrdp.ini
sudo sed -i 's/^#tcp_send_buffer_bytes=32768/tcp_send_buffer_bytes=8388608/' /etc/xrdp/xrdp.ini
sudo sed -i '1 a session required pam_env.so readenv=1 user_readenv=0' /etc/pam.d/xrdp-sesman
sudo sed -i '4 i\export XDG_CURRENT_DESKTOP=ubuntu:GNOME' /etc/xrdp/startwm.sh
sudo sed -i '4 i\export GNOME_SHELL_SESSION_MODE=ubuntu' /etc/xrdp/startwm.sh
sudo sed -i '4 i\export DESKTOP_SESSION=ubuntu' /etc/xrdp/startwm.sh

export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg

echo "export XAUTHORITY=${HOME}/.Xauthority" | tee -a ~/.xsessionrc
echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc
echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc

sudo systemctl restart xrdp
sleep 2

# GNOME Settings
echo "Setting GNOME configurations..."
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/desktop-base/joy-theme/wallpaper/gnome-background.xml'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.interface enable-animations false
sudo systemctl restart xrdp
sleep 2

# Chrome Setup
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
sudo apt-get install -y preload
sudo apt-get autoremove -y
sudo apt-get clean
sleep 2

# Docker Setup
echo "Setting up Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
sudo groupadd docker || true
sudo usermod -aG docker $USER
echo 'root:Adm1234#' | sudo chpasswd
sleep 2

# Add Users
echo "Adding new users..."
for user in junior senior test titan wren; do
  sudo useradd -m -s /bin/bash "$user"
  echo "$user:Adm1234#" | sudo chpasswd
  sudo usermod -aG docker "$user"
  sudo usermod -aG sudo "$user"
  echo "export XAUTHORITY=${HOME}/.Xauthority" | sudo tee -a /home/"$user"/.xsessionrc
  echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | sudo tee -a /home/"$user"/.xsessionrc
  echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | sudo tee -a /home/"$user"/.xsessionrc
done

# VSCode
echo "Installing Visual Studio Code..."
sudo apt-get install -y software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update
sudo apt-get install -y code
sleep 2

# JetBrains Toolbox Setup
echo "Installing JetBrains Toolbox..."
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.2.31487.tar.gz
sudo tar -xzf jetbrains-toolbox-2.3.2.31487.tar.gz -C /opt
/opt/jetbrains-toolbox-*/jetbrains-toolbox &
sleep 2

sudo snap install phpstorm --classic
sleep 2

# Allow ingress
echo "Flushing iptables..."
sudo iptables -F
