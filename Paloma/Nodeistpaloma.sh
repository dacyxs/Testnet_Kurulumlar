#!/bin/bash
echo "=================================================="
echo -e "\033[0;35m"
echo " | \ | |         | |    (_)   | |  ";
echo " |  \| | ___   __| | ___ _ ___| |_ ";
echo " |     |/ _ \ / _  |/ _ \ / __| __| ";
echo " | |\  | (_) | (_| |  __/ \__ \ |_ ";
echo " |_| \_|\___/ \__,_|\___|_|___/\__| ";
echo -e "\e[0m"
echo "=================================================="                                                            
sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "node isminizi yaziniz: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
echo "export WALLET=wallet" >> $HOME/.bash_profile
echo "export CHAIN_ID=paloma" >> $HOME/.bash_profile
source $HOME/.bash_profile


echo '================================================='
echo 'Node isminiz: ' $NODENAME
echo 'Cüzdan isminiz: ' $WALLET
echo 'Chain ismi: ' $CHAIN_ID
echo '================================================='
sleep 2
echo -e "\e[1m\e[32m1. Paketler güncelleniyor... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y
echo -e "\e[1m\e[32m2. Bagliliklar yukleniyor... \e[0m" && sleep 1
# packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
# install go
ver="1.17.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version
echo -e "\e[1m\e[32m3. kutuphaneler indirilip yukleniyor... \e[0m" && sleep 1
# download binary
wget -qO - https://github.com/palomachain/paloma/releases/download/v0.1.0-alpha/paloma_0.1.0-alpha_Linux_x86_64v3.tar.gz | \
sudo tar -C /usr/local/bin -xvzf - palomad
sudo chmod +x /usr/local/bin/palomad
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/raw/main/api/libwasmvm.x86_64.so

# config
palomad config chain-id $CHAIN_ID
palomad config keyring-backend file

# init
palomad init $NODENAME --chain-id $CHAIN_ID

# download genesis and addrbook
wget -qO $HOME/.paloma/config/genesis.json "https://raw.githubusercontent.com/palomachain/testnet/master/livia/genesis.json"
wget -qO $HOME/.paloma/config/addrbook.json "https://raw.githubusercontent.com/palomachain/testnet/master/livia/addrbook.json"

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0grain\"/" $HOME/.paloma/config/app.toml

# set peers and seeds
SEEDS=""
PEERS="30d92940f03052f942401165689b2e70e041fc8e@167.235.243.186:26656,02c92c5ebd44822d26dc88f6e1a333cf692cf802@95.31.16.222:26656,8e365511d7cd078ae8f0acf771dc3642f6eaa077@20.127.7.19:36416,0f4411c257bfe7bf191c2c3fd32b385a363487cf@167.71.247.34:26656,fae84ec72a6f686d76096053e0532a65b69e5228@143.198.169.111:26656,a70cab8943a70171272d62e6e3e2eaf704b9693c@149.102.148.127:26656,f5fd79e1086ebd5503e0ab19314746a7b1b8e220@144.91.77.189:36776,7980e25d5a9f8370969676808e4be7244b5d6a67@134.209.95.202:26656,cbef1c2d365c1b087e22e5d1c3ebdd10250e34d2@159.65.14.48:26656,dcc02e5e4e9aa8bec92a27bb148a20232d913420@5.161.111.18:26656,fd12957ba333022359b5a7c2285aa158ae6af04c@195.201.235.194:26656,92cbddc9bd34904b2044d640c5da1c6da4b81877@194.163.169.166:26656,14ca25ab5cfdc7a28b6600e4ac64303035e4e65a@54.193.147.0:26656,5af8117a3b45f9611a910954735367f867530825@46.228.199.8:26656,8ec7f59d20d2155d3b0f7b09b4762248ce84f04e@74.220.22.51:26656,8bbe63d166c3c09241ba93464449e4b8009d17eb@20.240.51.154:26656,949f02a722f1d1bbb254091c77a4837df392717a@165.232.130.3:26656,c9b64b1f2e305c8f406801af891592ff1141a77d@161.97.73.185:26656,e756146a910dadb75deaed8a6dc2491fe6fe3677@143.198.179.94:26656,03d507609c6cb48998d8bd7e9c612324bcc6ff87@188.166.168.176:36416,89b9f4fed146b01044dc9f72ead13c6537367cbd@20.102.99.251:26656,a6fb5aaabe1170c5b3d3a654502e77701fdde2e4@207.244.237.70:26656,120be42c0d9061ae7ade4445159034b496240f76@20.114.129.135:26656,78b6d4fbc0ac6c4b9c0e10659ae669766d785855@65.21.151.93:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.paloma/config/config.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.paloma/config/config.toml

# add external (if dont use sentry), port is default
# external_address=$(wget -qO- eth0.me)
# sed -i -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/" $HOME/.paloma/config/config.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"

sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.paloma/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.paloma/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.paloma/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.paloma/config/app.toml

sleep 1

#Change port 41
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:36418\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:36417\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:6411\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:36416\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":36410\"%" $HOME/.paloma/config/config.toml
sed -i.bak -e "s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:9410\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:9411\"%" $HOME/.paloma/config/app.toml
sed -i.bak -e "s%^node = \"tcp://localhost:26657\"%node = \"tcp://localhost:36417\"%" $HOME/.paloma/config/client.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:36416\"/" $HOME/.paloma/config/config.toml

sleep 1 

sed -i.bak -e "s/indexer *=.*/indexer = \"null\"/g" $HOME/.paloma/config/config.toml
sed -i "s/index-events=.*/index-events=[\"tx.hash\",\"tx.height\",\"block.height\"]/g" $HOME/.paloma/config/app.toml

sleep 1

# reset
palomad tendermint unsafe-reset-all

echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/palomad.service > /dev/null <<EOF
[Unit]
Description=paloma
After=network-online.target
[Service]
User=$USER
ExecStart=$(which palomad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/palomad.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable palomad
sudo systemctl restart palomad

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u palomad -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
