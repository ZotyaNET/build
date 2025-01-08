#!/bin/bash

# Desktop Setup
sudo apt-get update && sudo apt-get -y upgrade
sleep 2

sudo apt-get install mc git htop make rsync telnet dialog whiptail rtkit systemd-oom colord whoopsi geoclue -y
sleep 2

sudo apt-get install -y ubuntu-gnome-desktop gnome-software gnome-tweaks
sleep 2

sudo systemctl enable --now gdm3
sudo apt-get install -y xrdp
sudo systemctl enable --now xrdp
sudo systemctl start xrdp
sleep 2

# System Configuration
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w net.core.wmem_max=8388608
echo "net.core.wmem_max = 8388608" | sudo tee /etc/sysctl.d/xrdp.conf > /dev/null
sudo sysctl --system
sleep 2

# Modify xrdp settings
sudo sed -i 's/^port=3389/port=3388/' /etc/xrdp/xrdp.ini
sudo sed -i 's/^#tcp_send_buffer_bytes=32768/tcp_send_buffer_bytes=8388608/' /etc/xrdp/xrdp.ini
sudo sed -i '1 a session required pam_env.so readenv=1 user_readenv=0' /etc/pam.d/xrdp-sesman
sudo sed -i '4 i\export XDG_CURRENT_DESKTOP=ubuntu:GNOME' /etc/xrdp/startwm.sh
sudo sed -i '4 i\export GNOME_SHELL_SESSION_MODE=ubuntu' /etc/xrdp/startwm.sh
sudo sed -i '4 i\export DESKTOP_SESSION=ubuntu' /etc/xrdp/startwm.sh
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
echo "export XAUTHORITY=${HOME}/.Xauthority" | tee ~/.xsessionrc
echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc
echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc
echo -e '#%PAM-1.0\nauth required pam_env.so readenv=1\nauth required pam_env.so readenv=1 envfile=/etc/default/cache\n@include common-auth\n-auth   optional        pam_colormanagement.so\n-auth   optional        pam_gnome_keyring.so\n-auth   optional        pam_kwallet5.so\n@include common-account\n@include common-session\n-session optional       pam_colormanagement.so auto_start\n-session optional       pam_gnome_keyring.so auto_start\n-session optional       pam_kwallet5.so auto_start\n@include common-password' | sudo tee /etc/pam.d/xrdp-sesman > /dev/null
sudo systemctl restart xrdp
sleep 2

# GNOME Settings
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/desktop-base/joy-theme/wallpaper/gnome-background.xml'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.interface enable-animations false
sudo systemctl restart xrdp
sleep 2

# Chrome Setup
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
sudo apt-get install -y preload
sudo apt-get autoremove -y
sudo apt-get clean
sleep 2

# Docker Setup
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
echo 'root:Adm1234#' | sudo chpasswd
sleep 2

# Add users
sudo useradd -m -s /bin/bash junior 
echo 'junior:Adm1234#' | sudo chpasswd
sudo usermod -aG docker junior
sudo usermod -aG sudo junior
echo "export XAUTHORITY=${HOME}/.Xauthority" | tee ~/.xsessionrc && echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc && echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc
sudo useradd -m -s /bin/bash senior 
echo 'senior:Adm1234#' | sudo chpasswd
sudo usermod -aG docker senior
sudo usermod -aG sudo senior
echo "export XAUTHORITY=${HOME}/.Xauthority" | tee ~/.xsessionrc && echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc && echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc
sudo useradd -m -s /bin/bash test 
echo 'test:Adm1234#' | sudo chpasswd
sudo usermod -aG docker test
sudo usermod -aG sudo test
echo "export XAUTHORITY=${HOME}/.Xauthority" | tee ~/.xsessionrc && echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc && echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc
sudo useradd -m -s /bin/bash titan 
echo 'titan:Adm1234#' | sudo chpasswd
sudo usermod -aG docker titan
sudo usermod -aG sudo titan
echo "export XAUTHORITY=${HOME}/.Xauthority" | tee ~/.xsessionrc && echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc && echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc
sudo useradd -m -s /bin/bash wren 
echo 'wren:Adm1234#' | sudo chpasswd
sudo usermod -aG docker wren
sudo usermod -aG sudo wren
echo "export XAUTHORITY=${HOME}/.Xauthority" | tee ~/.xsessionrc && echo "export GNOME_SHELL_SESSION_MODE=ubuntu" | tee -a ~/.xsessionrc && echo "export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg" | tee -a ~/.xsessionrc

# VSCode
sudo apt-get install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt-get install -y code
sleep 2

# JetBrains Toolbox Setup
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.2.31487.tar.gz
sudo tar -xzf jetbrains-toolbox-2.3.2.31487.tar.gz -C /opt
sudo bash -c '/opt/jetbrains-toolbox-2.3.2.31487/jetbrains-toolbox'
sleep 2

sudo snap install phpstorm --classic
sleep 2

sudo snap install postman
sudo snap install opera
sudo snap install telegram
sudo snap install gimp
sudo snap install smplayer
sudo snap install vlc
sudo snap install ktorrent
sleep 2

# Allow ingress
sudo iptables -F
