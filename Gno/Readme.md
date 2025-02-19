
<p style="font-size:14px" align="right">
 <a href="https://t.me/nodeistt" target="_blank"><img src="https://github.com/Nodeist/Testnet_Kurulumlar/blob/fee87fe32609c1704206721b9fb16e4c5de75a96/telegramlogo.png" width="30"/></a><br>Telegrama Katıl<br>
<a href="https://nodeist.site/" target="_blank"><img src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/logo.png" width="30"/></a><br> Websitemizi Ziyaret Et 
</p>


<p align="center">
  <img height="100" height="auto" src="https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Gno/75237105%20(1).png">
</p>

# Gno.land Kurulum

### Güncellemeler ve gereklilikler
Yükleme ve yapılandırma

```
wget -O gno.sh https://raw.githubusercontent.com/Nodeist/Testnet_Kurulumlar/main/Gno/gno.sh && chmod +x gno.sh && ./gno.sh

```

### Mnemonic Üret (kaydetmeyi unutma!)

```
cd gno

./build/gnokey generate
```

Üretilen mnemonic ile Cüzdan Oluştur (Verilen bilgileri yedeklemeyi unutmayın.)
```
./build/gnokey add account --recover
```

### Musluktan Jeton isteyin:
https://gno.land/faucet

Bakiyenizi kontrol edin. `CUZDANADRESINIZ` yazan kısma az önce aldığınız cüzdan adresini yazın.

```
./build/gnokey query auth/accounts/CUZDANADRESINIZ --remote gno.land:36657
```



Aşağıdakine benzer bir çıktı görmelisiniz:

```
height: 0                                                            
data: {                                                                
"BaseAccount": {                                                       
"address": "g1lr8jsfhtd2du33rgknv2977nc0uefmcty06xpd",               
"coins": "100gnot",                                                   

"public_key": {                                                        
"@type": "/tm.PubKeySecp256k1",                                      
"value": "AxJXHJE8y+b/l3v0LBbdr7QmikZVEEl8j3BH6hE+lh5f"            },                                                                   

"account_number": "1731",                                            
"sequence": "2"                                                    }
```

"account_number": "1731",                                            
"sequence": "2"    

Account number ve sekansınızı kaydedin.
