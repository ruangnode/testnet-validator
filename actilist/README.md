<p style="font-size:14px" align="right">
</p>



# Tutorial Setup secretcli & convert SCRT ke SSCRT (Testnet)

## 1. Siapkan address di wallet keplr 
- Udah pada taulah ya :)

## 2. Setup Network & Ambil faucet
- Connect wallet kalian disini untuk dapetin network nya
https://connect.pulsar.scrttestnet.com/

![image](https://635078835-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FgF1LuzRcRVxJ2tTkh299%2Fuploads%2FyeUOb7aJwFVl1KWJ6lMy%2Fconnect_keplr.png?alt=media&token=3e1afcce-9e9d-4bfb-a0eb-34edf9d62ec9
)

- Ambil faucet disini
https://pulsar.faucet.trivium.network/

![image](https://635078835-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FgF1LuzRcRVxJ2tTkh299%2Fuploads%2FnlQlHylJaJOqMJri8qEQ%2Ftestnetguide_3.png?alt=media&token=071a06af-b81d-4df7-85b6-514e17f98706)

## 3. Setup secretcli

**Siapkan VPS kalian**

- Install si secretcli nya

```
wget https://github.com/scrtlabs/SecretNetwork/releases/download/v1.4.1-patch.3/secretcli-Linux
```

![image](https://user-images.githubusercontent.com/72949170/198849763-b36d32c9-7f74-41b3-b536-5b1425083414.png)


- Jadikan secretcli sebagai executable

```
chmod +x secretcli-Linux
```

- Agar gampang commandnya kita ganti dari ```./secretcli-Linux``` jadi ```secretcli```

```
sudo mv secretcli-Linux /usr/local/bin/secretcli
```

## 4. Setup wallet kalian di secretcli

```
secretcli config node https://rpc.pulsar.scrttestnet.com
secretcli config output json
secretcli config chain-id pulsar-2
secretcli keys add WALLET --recover
```

ganti ```wallet``` jadi nama wallet kalian

- Masukan mnemonic phrase Keplr kalian kesitu
- Masukan password & re-enter password


## 5. Convert 50 SCRT tokens into sSCRT

```
secretcli tx compute execute secret1jgu494j78qrvtznfzy8u48dv9k5e3yt2wl5cap '{"deposit":{}}' --amount 50000000uscrt --from WALLET
```

ganti ```wallet``` jadi nama wallet kalian


## Support 
Join the Telegram Channel: [BakkeiETH](https://t.me/airdropchannel666)

Join the Discord Server: [BakkeiETH](https://discord.gg/tTjDAfkCNn)
