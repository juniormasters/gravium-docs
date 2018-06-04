**Preparation**

Get a VPS from a provider like DigitalOcean, Vultr, Linode, etc.
Recommended VPS size: 2GB RAM (if less its ok, we can make swap)
It must be Ubuntu 16.04 (Xenial)
Make sure you have a transaction of exactly 1000 GRV in your desktop cold wallet.
gravium.conf file on LOCAL wallet MUST BE EMPTY!
masternode.conf file on VPS wallet MUST BE EMPTY!
NOTES: PRE_ENABLED status is NOT an issue, just restart local wallet and wait a few minutes.
You need a different IP for each masternode you plan to host

**Wallet Setup Part 1**
Open your wallet on your desktop.
Click Receive, then click Request and put your Label such as “MN1”
Copy the Address and Send EXACTLY 1000 GRV to this Address

Go to the tab at the bottom that says "Tools"
Go to the tab at the top that says "Console"

Wait for 15 confirmations, then run following command:

masternode outputs

You should see one line corresponding to the transaction id (tx_id) of your 1000 coins with a digit identifier (digit). Save these two strings in a text file.

Example:
{
  "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0"
}

Note that if you get more than 1 line, it’s because you made multiple 1000 coins transactions, with the tx_id and digit associated.

Run the following command:

masternode genkey

You should see a long key: (masternodeprivkey)
EXAMPLE: 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

This is your masternode private key, record it to text file, keep it safe, do not share with anyone. This will be called “masternodeprivkey”

Next, you have to go to the data directory of your wallet 
Go to wallet settings=> and click “Open masternode configuration file”
You should see 2 lines both with a # to comment them out.

Please make a new line and add:

MN1 (YOUR VPS IP):port masternodeprivkey tx_id digit

Put your data correctly, save it and close.
Go to Gravium Wallet, Click Settings, Check “Show Masternodes Tab”
Save and Restart your wallet.

Note that each line of the masternode.conf file corresponds to one masternode if you want to run more than one node from the same wallet,
just make a new line and repeat steps.

**VPS Setup**

**Preparation:**
Windows users will need a program called putty to connect to the VPS
Use SSH to Log into your VPS

We need to install some dependencies. Please copy, paste and hit enter:

apt-get update;apt-get upgrade; apt-get install nano software-properties-common git wget -y;

Now Copy command into the VPS command line and hit enter:

wget https://raw.githubusercontent.com/Gravium/gravium-docs/master/scripts/masternode.sh && chmod +x masternode.sh && ./masternode.sh


When prompted, enter your “masternodeprivkey” from before.
You will be asked for your VPS IP and a few other questions.
The installation should finish successfully. Ask for help in discord if it doesn't.

Troubleshooting  and testing:
After the script finishes, you will want to check that it is running properly. Please type in:

cd /root/gravium/src

./graviumd -daemon

./gravium-cli masternode status

If you get an error about permissions, you just need to kill the process and restart with:

killall graviumd

and restart with:

./graviumd -daemon

now test with:

./gravium-cli getblockcount

If you get an error that file does not exist, it may be that the script failed to build and we need to trace back the problem. Contact devs in discord.


**Starting Your Masternode**

Go back to your desktop wallet, to the Masternode tab.
You need to wait for 15 confirmations in order to start the masternode- you can also check on your VPS by:

cd /root/gravium/src

./gravium-cli getblockcount

(needs to be more than 0 to be in sync)

./gravium-cli masternode status

It should return that it was just started.

NOTE: If the Masternode tab isn’t showing, you need to  click settings, check “Show Masternodes Tab” save, and restart the wallet
If your Masternode does not show, restart the wallet
 
Now Click “start-all”. Your masternode should be now up and running!
 
**Checking Your Masternode**
You can check the masternode status by going to the wallet console and typing:
 
masternode status
 
If your masternode is running it should print “Masternode successfully started”.
 
You can also check your MN status by local wallet - tools - console, just type:
 
masternode list full XXXXX
 
(Where XXXXX is yours first 5 character of TX_ID).
 
CONGRATULATIONS!
 
