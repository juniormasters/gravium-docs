#!/bin/bash

clear
cd ~

# stop daeomn 
gravium-cli stop

# download new binaries
wget https://github.com/Gravium/gravium/releases/download/v1.0.2/graviumcore-1.0.2-linux64.tar.gz
tar xzfv graviumcore-1.0.2.linux64.tar.gz
cd graviumcore-1.0.2/bin

# apply persmissions and move to /usr/bin folder
chmod +x graviumd
chmod +x gravium-cli
chmod +x gravium-tx

# Move binaries do lib folder
mv gravium-cli /usr/bin/gravium-cli
mv gravium-tx /usr/bin/gravium-tx
mv graviumd /usr/bin/graviumd

# run and reindex
graviumd -daemon -reindex
