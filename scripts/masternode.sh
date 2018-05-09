#/bin/bash

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
## This script is a comiplation of Work from around the internet, and changed around accordingly to suit this project.
## Thank you to everyone for the work you have done in this space and I hope this helps another project out there.
# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you using Ubuntu 16.04?"  >&2; exit 1; }

# Gather input from user
read -e -p "Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h) : " key
if [[ "$key" == "" ]]; then
    echo "WARNING: No private key entered, exiting!!!"
    echo && exit
fi
read -e -p "Hello! VPS Server IP Address and Masternode Port : " ip
echo && echo "Pressing ENTER will use the default value for the next prompts. It's ok, you can just click enter."
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
    sudo ufw allow 3385/tcp
    sudo ufw allow 7979/tcp
    echo "y" | sudo ufw enable
    echo && echo "Ports Ready =D"
fi

# Download and install from git
echo && echo "Let's build Gravium"
sleep 3
sudo git clone https://github.com/Gravium/gravium.git
cd gravium
chmod 755 autogen.sh
chmod 755 share/genbuild.sh

# Install
echo && echo "This may take a while, grab a snickers"
sleep 3
./autogen.sh
./configure
make

# Test Gravium
echo && echo "Let's take this baby for a spin =D"
sleep 3
cd src
./graviumd -daemon
./gravium-cli stop

# Create config
echo && echo "Making a config for Gravium"
sleep 3
rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
rpcpassword=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
sudo touch /root/.gravium/gravium.conf
echo '
rpcuser='$rpcuser'
rpcpassword='$rpcpassword'
rpcallowip=127.0.0.1
listen=1
server=1
rpcport=3385
daemon=0 # required for systemd
logtimestamps=1
maxconnections=256
externalip='$ip'
masternodeprivkey='$key'
masternode=1
' | sudo -E tee /root/.gravium/gravium.conf

# Setup systemd service
echo && echo "Almost There...."
sleep 3
sudo touch /etc/systemd/system/graviumd.service
echo '[Unit]
Description=graviumd
After=network.target
[Service]
Type=simple
User=root
ExecStart=/root/gravium/src/graviumd -daemon
ExecStop=/root/gravium/src/gravium-cli stop
Restart=on-abort
[Install]
WantedBy=multi-user.target
' | sudo -E tee /etc/systemd/system/graviumd.service
chmod +x /etc/systemd/system/graviumd.service
sudo systemctl enable graviumd
sudo systemctl start graviumd
killall graviumd

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
(crontab -l -u masternode 2>/dev/null; echo '* * * * * cd /root/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1') | sudo crontab -u root -

cd ~

# cd to gravium-cli for final, no real need to run cli with commands as service when you can just cd there
echo && echo "Gravium Masternode Setup Complete!"

echo && echo "Please type in cd /root/gravium/src and run ./graviumd -daemon and then ./gravium-cli getblockcount after a few minutes"
