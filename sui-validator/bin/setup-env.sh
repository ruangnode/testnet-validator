#!/bin/bash
#
#
#
#

USER="gneareth"

apt-get update -y
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
mkdir -p /etc/apt/keyrings
if [ -f /etc/apt/keyrings/docker.gpg ]
then
    echo "GPG Available"
else
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi
if [ -f /etc/apt/sources.list.d/docker.list ]
then
   echo Directory Already Created
else
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi
apt-get update -y
apt-get install docker-compose zsh docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
useradd -m -G admin,docker -U  -s /bin/zsh ${USER}

grep -q "swapfile" /etc/fstab
if [[ ! $? -ne 0 ]]; then
   echo -e '\n\e[42m[Swap] Swap file exist, skip.\e[0m\n'
else
   fallocate -l 4G /swapfile
   dd if=/dev/zero of=/swapfile bs=1K count=4M
   chmod 600 /swapfile
   mkswap /swapfile
   swapon /swapfile
   swapon --show
   echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
fi

su - ${USER} -c 'cd ~/ ; sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";exit 0'
passwd ${USER}
cat > zshrc <<EOF
###### ZSH CONFIG ######
export ZSH="/home/${USER}/.oh-my-zsh"
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
plugins=(git)
source \$ZSH/oh-my-zsh.sh


###### VARIABLE GLOBAL ####
export MUTTER_ALLOW_HYBRID_GPUS=1
export QT_QPA_PLATFORM=wayland
export ARCHFLAGS="-arch x86_64"
export EDITOR='vim'
EOF
chown ${USER}:admin zshrc
mv zshrc /home/$USER/.zshrc
