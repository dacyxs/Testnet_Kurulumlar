echo -e "\e[1m\e[32m4. Servisler baslatiliyor... \e[0m" && sleep 1
# create service
tee $HOME/kujirad.service > /dev/null <<EOF
[Unit]
Description=kujirad
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$(which kujirad) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo mv $HOME/kujirad.service /etc/systemd/system/

# start service
sudo systemctl daemon-reload
sudo systemctl enable kujirad
sudo systemctl restart kujirad

echo '=============== KURULUM BASARIYLA TAMAMLANDI ==================='
echo -e 'Loglari kontrol et: \e[1m\e[32mjournalctl -ujournalctl -u kujirad -f -o cat\e[0m'
echo -e 'Senkronizasyon durumu kontrol et: \e[1m\e[32mcurl -s localhost:26657/status | jq .result.sync_info\e[0m'
