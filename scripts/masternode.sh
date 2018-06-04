#!/bin/bash

clear
cd ~
echo "███████████████████████████████████████████████████████████████████████████████"
echo "█████████████████████████████▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████████████████████████"
echo "██████████████████████████▓█▒█▒▒▒█▓▓▓▓▓▓▓▓▓▓▓█▓▓▓█▓█▓██████████████████████████"
echo "█████████████████████████▓▓█▒▒█▒▒▒▒▒██▓▓▓██▓▓▓▓▓█▓▓█▓▓█████████████████████████"
echo "████████████████████████▓▓▓█▒▒▒▒▒▒▒▒▒▒███▓▓▓▓▓▓█▓▓▓█▓▓▓████████████████████████"
echo "███████████████████████▓▓▓▓█▒▒▒▒▒██████▓██████▓▓▓▓▓█▓▓▓▓███████████████████████"
echo "█████████████████████▓▓▓▓▓▓█▒▒▒████▓▓▓▓▓▓▓▓▓████▓▓▓█▓▓▓▓▓██████████████████████"
echo "████████████████████▓▓▓▓▓▓▓█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓▓▓▓████████████████████"
echo "███████████████████▓▓▓▓▓█▓▒███▓▓▓▓▓▓███████▓▓▓▓▓████▓▓█▓▓▓▓▓███████████████████"
echo "██████████████████▓▓██▒▒▒▒▒███▓▓▓▓██████████████████▓▓▓▓▓██▓▓██████████████████"
echo "██████████████████▓▒▒▒▒▒▒▒▒███▓▓▓▓██████▓▓▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓██████████████████"
echo "██████████████████▒▒▒▒▒▒▒▒▒███▓▓▓▓██████▓▓▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓██████████████████"
echo "██████████████████▓▓██▒▒▒▒▒███▓▓▓▓███████████▓▓▓▓███▓▓▓▓▓██▓▓██████████████████"
echo "███████████████████▓▓▓▓██▒▒███▓▓▓▓▓▓███████▓▓▓▓▓▓███▓▓█▓▓▓▓▓███████████████████"
echo "████████████████████▓▓▓▓▓▓▓█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓▓▓▓████████████████████"
echo "██████████████████████▓▓▓▓▓█▓▓▓████▓▓▓▓▓▓▓▓▓█████▓▓█▓▓▓▓▓▓█████████████████████"
echo "███████████████████████▓▓▓▓█▓▓▓▓▓██████▓██████▓▓▓▓▓█▓▓▓▓███████████████████████"
echo "████████████████████████▓▓▓█▓▓▓▓▓▒▒▒▒▓███▓░░░░▒▓▓▓▓█▓▓▓████████████████████████"
echo "█████████████████████████▓▓█▓▓█▒▒▒▒▒▓█▒▒▒██░░░░░█▓▓█▓▓█████████████████████████"
echo "██████████████████████████▓█▓█▒▒▒██▒▒▒▒▒▒▒▒▒██░░░█▓█▓██████████████████████████"
echo "█████████████████████████████▓█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓█████████████████████████████"
echo "███████████████████████████████████████████████████████████████████████████████"
echo && echo && echo
sleep 3
## This script is a compilation of Work from around the internet, and changed around accordingly to suit this project.
## Thank you to everyone for the work you have done in this space and I hope this helps another project out there.
# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you using Ubuntu 16.04?"  >&2; exit 1; }

# Gather input from user
read -e -p "Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h) : " key
if [[ "$key" == "" ]]; then
    echo "WARNING: No private key entered, exiting!!!"
    echo && exit
fi
read -e -p "Hello! Please input your VPS Server IP Address and Masternode Port(11010) " ip
echo && echo "Pressing ENTER will use default values for the next prompts. It's ok, you can click enter. Seriously, just click enter for each."
echo && sleep 3
read -e -p "Add swap space? (Recommended) [Y/n] : " add_swap
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    read -e -p "Swap Size [2G] : " swap_size
    if [[ "$swap_size" == "" ]]; then
        swap_size="2G"
    fi
fi    
read -e -p "Install Fail2ban? (Recommended) [Y/n] : " install_fail2ban
read -e -p "Install UFW and configure ports? (Recommended) [Y/n] : " UFW

# Add swap if needed
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    if [ ! -f /swapfile ]; then
        echo && echo "Adding some swap space..."
        sleep 3
        sudo fallocate -l $swap_size /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
        sudo sysctl vm.swappiness=10
        sudo sysctl vm.vfs_cache_pressure=50
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
    else
        echo && echo "Swap file detected, we don't need it- skipping the swap!"
        sleep 3
    fi
fi

# Update system 
echo && echo "Some system upgrades"
sleep 3
sudo apt-get -y update
sudo apt-get -y upgrade

# Add Berkely PPA
echo && echo "BA BA BA Bitcoin PPA..."
sleep 3
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:bitcoin/bitcoin
sudo apt-get -y update

# Install required packages
echo && echo "We need to download and install some stuff"
sleep 3
sudo apt-get -y install \
build-essential \
libtool \
autotools-dev \
automake \
pkg-config \
libssl-dev \
bsdmainutils \
software-properties-common \
libzmq3-dev \
libevent-dev \
libboost-dev \
libboost-chrono-dev \
libboost-filesystem-dev \
libboost-program-options-dev \
libboost-system-dev \
libboost-test-dev \
libboost-thread-dev \
libdb4.8-dev \
libdb4.8++-dev \
libminiupnpc-dev \
python-virtualenv

# Install fail2ban if needed
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
    echo && echo "fail2ban to BANHAMMER"
    sleep 3
    sudo apt-get -y install fail2ban
    sudo service fail2ban restart 
fi

# Install firewall if needed
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    echo && echo "UFW so we can forward ports"
    sleep 3
    sudo apt-get -y install ufw
    echo && echo "Configuring ports..."
    sleep 3
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow 11000/tcp
    sudo ufw allow 11010/tcp
    echo "y" | sudo ufw enable
    echo && echo "Ports Ready =D"
fi

#Download pre-compiled Gravium and run
cd
#Select OS architecture
    if [ `getconf LONG_BIT` = "64" ]
        then
            wget https://github.com/Gravium/gravium/releases/download/v1.0.1/graviumcore-1.0.1-linux64.tar.gz
            tar -zxvf graviumcore-1.0.1-linux64.tar.gz
    else
        wget https://github.com/Gravium/gravium/releases/download/v1.0.1/graviumcore-1.0.1-linux32.tar.gz
        tar -zxvf graviumcore-1.0.1-linux32.tar.gz
    fi
    
cd /root/graviumcore-1.0.1/bin
chmod +x graviumd
chmod +x gravium-cli
chmod +x gravium-tx

# Move binaries do lib folder
sudo mv gravium-cli /usr/bin/gravium-cli
sudo mv gravium-tx /usr/bin/gravium-tx
sudo mv graviumd /usr/bin/graviumd

sleep 10

# Create config
echo && echo "Making a config for Gravium"
sleep 3
cd
sudo mkdir /root/.graviumcore
rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
rpcpassword=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
sudo touch /root/.graviumcore/gravium.conf
echo '
rpcuser='$rpcuser'
rpcpassword='$rpcpassword'
rpcallowip=127.0.0.1
listen=1
server=1
rpcport=11000
daemon=0 # required for systemd
logtimestamps=1
maxconnections=256
externalip='$ip'
masternodeprivkey='$key'
masternode=1
' | sudo -E tee /root/.graviumcore/gravium.conf

#run daemon
graviumd -daemon

# Download and install sentinel
echo && echo "Installing Sentinel..."
sleep 3
cd
sudo apt-get -y install python3-pip
sudo pip3 install virtualenv
sudo apt-get install screen
sudo git clone https://github.com/Gravium/sentinel.git /root/sentinel
cd /root/sentinel
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
export EDITOR=nano
(crontab -l -u root 2>/dev/null; echo '* * * * * cd /root/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1') | sudo crontab -u root -

# Create a cronjob for making sure graviumd runs after reboot
if ! crontab -l | grep "@reboot graviumd -daemon"; then
  (crontab -l ; echo "@reboot graviumd -daemon") | crontab -
fi

cd ~

echo && echo "Gravium Masternode Setup Complete!"

echo && echo "Please let the chain sync 5 minutes then start alias in wallet then run 'gravium-cli masternode status'. If get error: incorrect rpcuser or rpcpassword do 'killall graviumd' then 'graviumd -daemon' "
