#!/bin/bash

clear
cd ~

# stop daeomn 
gravium-cli stop
sleep 5

# remove data chain files/folders
cd /root/.graviumcore
rm -fr blocks database chainstate db.log mncache.dat mnpayments.dat peers.dat fee_estimates.dat banlist.dat netfulfilled.dat governance.dat .lock

# download new binaries and untar
wget https://github.com/Gravium/gravium/releases/download/v1.0.2/graviumcore-1.0.2-linux64.tar.gz
tar xzfv graviumcore-1.0.2-linux64.tar.gz
cd graviumcore-1.0.2/bin

# apply permissions and move to /usr/bin folder
chmod +x graviumd
chmod +x gravium-cli
chmod +x gravium-tx

# Move binaries do lib folder
mv gravium-cli /usr/bin/gravium-cli
mv gravium-tx /usr/bin/gravium-tx
mv graviumd /usr/bin/graviumd

# run and reindex
graviumd -daemon -reindex
