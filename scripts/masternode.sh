#/bin/bash
clear
cd /root
echo "██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗    ████████╗ ██████╗"
echo "██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝    ╚══██╔══╝██╔═══██╗"
echo "██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗         ██║   ██║   ██║"
echo "██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝         ██║   ██║   ██║"
echo "╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗       ██║   ╚██████╔╝"
echo " ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝       ╚═╝    ╚═════╝ "
echo "                                                                                    "
echo "             ██████╗ ██████╗  █████╗ ██╗   ██╗██╗██╗   ██╗███╗   ███╗"
echo "            ██╔════╝ ██╔══██╗██╔══██╗██║   ██║██║██║   ██║████╗ ████║"
echo "            ██║  ███╗██████╔╝███████║██║   ██║██║██║   ██║██╔████╔██║"
echo "            ██║   ██║██╔══██╗██╔══██║╚██╗ ██╔╝██║██║   ██║██║╚██╔╝██║"
echo "            ╚██████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║╚██████╔╝██║ ╚═╝ ██║"
echo "             ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝"
                                                                                        
echo && echo && echo
sleep 2

# Check if is root
if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "You must use Ubuntu 16.04 (Xenial)."  >&2; exit 1; }

# Gather input from user
echo "Please enter your Masternode Private Key"
read -e -p "e.g. (8tagsuahsAHAJshjvhs88asadijsuyas98aqsaziucdplmkh75sb) : " key
if [[ "$key" == "" ]]; then
    echo "WARNING: No private key entered, exiting!!!"
    echo && exit
fi
read -e -p "VPS Server IP Address and Masternode Port like IP:7979 : " ip
echo && echo "Pressing ENTER will use the default value for the next prompts."
echo && sleep 3
read -e -p "Add swap space? (Recommended) [Y/n] : " add_swap
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    read -e -p "Swap Size [2G] : " swap_size
    if [[ "$swap_size" == "" ]]; then
        swap_size="2G"
    fi
fi
read -e -p "Install Fail2ban? (Recommended) [Y/n] : " install_fail2ban

# Add swap if needed
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    if [ ! -f /swapfile ]; then
        echo && echo "Adding swap space..."
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
        echo && echo "WARNING: Swap file detected, skipping add swap!"
        sleep 3
    fi
fi


# Update system 
echo && echo "Upgrading system..."
sleep 3
sudo apt-get -y update
sudo apt-get -y upgrade

# Add Berkely PPA
echo && echo "Installing bitcoin PPA..."
sleep 3
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:bitcoin/bitcoin
sudo apt-get -y update

# Install required packages
echo && echo "Installing base packages..."
sleep 3
sudo apt-get -y install \
build-essential \
libtool \
autotools-dev \
automake \
unzip \
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
    echo && echo "Installing fail2ban..."
    sleep 3
    sudo apt-get -y install fail2ban
    sudo service fail2ban restart 
fi

# Edit/Create config file for Gravium
echo && echo "Creating your data folder and files..."
sleep 3
sudo mkdir /root/.gravium

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
daemon=0
logtimestamps=1
maxconnections=256
externalip='$ip'
masternode=1
masternodeprivkey='$key'
' | sudo -E tee /root/.gravium/gravium.conf


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

# Move to bin folder and test
echo && echo "Let's take this baby for a spin =D"
sleep 3
cd src
chmod +x graviumd
chmod +x gravium-cli
chmod +x gravium-tx

# Move binaries do lib folder
sudo mv gravium-cli /usr/bin/gravium-cli
sudo mv gravium-tx /usr/bin/gravium-tx
sudo mv graviumd /usr/bin/graviumd

#run daemon
graviumd -daemon
sleep 5

# Download and install sentinel


# Create a cronjob for making sure graviumd runs after reboot
if ! crontab -l | grep "@reboot graviumd -daemon"; then
  (crontab -l ; echo "@reboot graviumd -daemon") | crontab -
fi

# Finished
echo && echo "Gravium Masternode Setup Complete!"

echo "If you put correct PrivKey and VPS IP the daemon should be running."
echo "Wait 2 minutes then run gravium-cli getinfo to check blocks."
echo "when fully synced you can start ALIAS on local wallet and finally check here with gravium-cli masternode status."
echo && echo
