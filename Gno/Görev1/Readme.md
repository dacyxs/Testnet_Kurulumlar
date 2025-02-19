# Kullanıcı Kaydı
### Şu anda GNO.LAND'de kullanıcı olarak kaydolmanın 2 yolu vardır:

*Davet ayrıcalıklarına sahip biri tarafından davet alın.*

*Kullanıcı kayıt sözleşmesine 2.000 $GNOT gönderin (erişilebilirlik için bunun yakın gelecekte 100 $GNOT olarak değişeceğini unutmayın).*

Davet istemek veya topluluktan $GNOT'ları yedeklemek için [Resmi Gnoland Discord Sunucusu](https://discord.gg/xD2c2Nmd)'na katılmanızı önermemize rağmen , 
istek başına 100 $GNOT veren musluğu da kullanabilirsiniz . 
Bununla birlikte, musluğu 20+ kez spam yapmanız gerekeceğinden, ikincisi tavsiye edilmeyen bir yaklaşımdır.

### Elinize 2.000 $ GNOT aldığınızda, Ubuntu'yu başlatın ve çalışma dizininize gidin.

```
cd gno
```

### Cüzdan bakiyenizi kontrol edin 
`CUZDANADRESI` yazan kısma cuzdan adresinizi yazın
En az 2000gnot bakiyeniz olduğundan emin olun.

```
./build/gnokey query auth/accounts/CUZDANADRESI --remote gno.land:36657
```

### Kayıt işlemini gerçekleştirin
Şimdi sizi aşağıdaki komutla kullanıcı olarak kaydedecek olan işlemin bilgilerini içerecek bir dosya oluşturacağız:
`CUZDANADRESI` ve `USERNAME` yazan yerleri değiştirin. username olarak kullanacağınız bir username belirleyin. sadece küçükharflerden oluşmalıdır. 
rakam ve özel karakter kullanmayın.
```
./build/gnokey maketx call CUZDANADRESI --pkgpath "gno.land/r/users" --func "Register" --gas-fee 1gnot --gas-wanted 2000000 --send "2000gnot" --args "" --args "USERNAME" --args "" > unsigned.tx
```

### İmza işlemini gerçekleştirin
`CUZDANADRESI`, `ACCOUNTNUMBER`, `SEQUENCENUMBER` kısımlarını kendinize göre düzenleyin.
```
./build/gnokey sign CUZDANADRESI --txpath unsigned.tx --chainid testchain --number ACCOUNTNUMBER --sequence SEQUENCENUMBER > signed.tx
```

### İmzayı yayınlayın:
```
./build/gnokey broadcast signed.tx --remote gno.land:36657
```
*Tüm işlemler doğru şekilde gerçekleştiyse [burada bulunan listede](https://gno.land/r/users) kullanıcı adınızı görmelisiniz.*

# Görev 
Artık görev adımına geçebiliriz.

Gno ile ilgili ingilizce bir makale hazırlayın ve yayınlayın. 
Medium, twitter vb. blog sitelerini kullanabilirsiniz.

### Makalenizi hazırladıktan sonra aşağıdaki kodu yazarak yayınlayın;
`CUZDANADRESI` ve `MAKALELINKI` bölümlerini kendinize göre düzenleyin.
```
./build/gnokey maketx call CUZDANADRESI --pkgpath "gno.land/r/boards" --func "CreateReply" --gas-fee 1gnot --gas-wanted 2000000 --send "" --broadcast true --chainid testchain --args "1" --args "8" --args "8" --args "MAKALELINKI" --remote gno.land:36657
```

İşlem başarılı ise [Görev Postları](https://gno.land/r/boards:gnolang/8) sayfasında makale linkinizi görmelisiniz.

