#
# // Copyright (C) 2022 Lukman Habibi By ruangnode.com
#

echo -e "\033[0;35m"
echo " ██████  ██    ██  █████  ███    ██  ██████  ███    ██  ██████  ██████  ███████     ██████  ██████  ███    ███     ";
echo " ██   ██ ██    ██ ██   ██ ████   ██ ██       ████   ██ ██    ██ ██   ██ ██         ██      ██    ██ ████  ████     ";
echo " ██████  ██    ██ ███████ ██ ██  ██ ██   ███ ██ ██  ██ ██    ██ ██   ██ █████      ██      ██    ██ ██ ████ ██     ";
echo " ██   ██ ██    ██ ██   ██ ██  ██ ██ ██    ██ ██  ██ ██ ██    ██ ██   ██ ██         ██      ██    ██ ██  ██  ██     ";
echo " ██   ██  ██████  ██   ██ ██   ████  ██████  ██   ████  ██████  ██████  ███████ ██  ██████  ██████  ██      ██     ";

echo ">>> Cosmovisor Automatic Installer for Nolus | Chain ID : mocaha <<<";
echo -e "\e[0m"

sleep 1

# Variable
SOURCE=celestia-app
WALLET=wallet
BINARY=celestia-appd
FOLDER=.celestia-app
CHAIN=mocha
VERSION=v0.11.0
DENOM=utia
COSMOVISOR=cosmovisor
REPO=https://github.com/celestiaorg/celestia-app.git
GENESIS=https://snapshots.kjnodes.com/celestia-testnet/genesis.json
ADDRBOOK=https://snapshots.kjnodes.com/celestia-testnet/addrbook.json
PORT=16

echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${binary}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $NODENAME ]; then
        read -p "admin@ruangnode.com:~# [ENTER YOUR NODE] > " NODENAME
        echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$NODENAME\e[0m"
echo -e "NODE CHAIN CHAIN  : \e[1m\e[31m$CHAIN\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$PORT\e[0m"
echo ""

# Package
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade

# Install GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# Get testnet VERSION of celestia
cd $HOME
rm -rf $SOURCE
git clone $REPO
cd $SOURCE
git checkout $VERSION
make build
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# Prepare binaries for Cosmovisor
mkdir -p $HOME/$FOLDER/cosmovisor/genesis/bin
mv build/$BINARY $HOME/$FOLDER/cosmovisor/genesis/bin/
rm -rf build

# Create application symlinks
ln -s $HOME/$FOLDER/cosmovisor/genesis $HOME/$FOLDER/cosmovisor/current
sudo ln -s $HOME/$FOLDER/cosmovisor/current/bin/$BINARY /usr/local/bin/$BINARY

# Init generation
$BINARY config chain-CHAIN $CHAIN
$BINARY config keyring-backend test
$BINARY config node tcp://localhost:${PORT}657
$BINARY init $NODENAME --chain-id $CHAIN

# Download genesis and addrbook
curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Set Seers and Peers
SEEDS="3f472746f46493309650e5a033076689996c8881@celestia-testnet.rpc.kjnodes.com:20659"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/$FOLDER/config/config.toml

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml


# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001$DENOM\"/" $HOME/$FOLDER/config/app.toml

# Set indexer
indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/$FOLDER/config/config.toml

# Enable snapshots
cd $HOME
rm -rf ~/$FOLDER/data
mkdir -p ~/$FOLDER/data
curl -L https://snapshots.kjnodes.com/celestia-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/$FOLDER

# Create Service
sudo tee /etc/systemd/system/$BINARY.service > /dev/null << EOF
[Unit]
Description=$BINARY
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/$FOLDER"
Environment="DAEMON_NAME=$BINARY"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl start $BINARY

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK RUNNING LOGS : \e[1m\e[31mjournalctl -fu $BINARY -o cat\e[0m"
echo -e "CHECK LOCAL STATUS : \e[1m\e[31mcurl -s localhost:${PORT}657/status | jq .result.sync_info\e[0m"
echo ""

# End
