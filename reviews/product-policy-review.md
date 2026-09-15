# Ürün karar incelemesi

Ürün sahibi R1–R10 yönlerini ve iletişim kararlarını onayladı. Yazıyor ve okundu bilgisi için özel karar: sonraya ertelenmiyor, üründe hiç olmayacak. Geçerli kurallar ilgili belgelere işlendi; bu dosya uygulama şartnamesi değildir.

| Başlık | Karar durumu |
|---|---|
| R1 — kapsam | Saved, duo ve reaksiyonlar sonraki sürümlerde planlanıyor. Yazıyor/okundu ürün dışında. Trait Signal, abonelik ve boost önceki onayla sonraya bırakıldı. |
| R2 — trust | İç güven değerlendirmesi ve durumlar korunuyor; cevaplanmama tek başına ceza nedeni değil. Geçici yaptırım ayrıntıları D5'te. |
| R3 — iletişim | Çift başına tek açık iletişim, değişen bağlamda açık yeniden gönderim ve aşağıdaki iki dönüş akışı kabul edildi. |
| R4 — moderasyon | İnsan inceleme kuyruğu korunuyor, bekleyen içerik gönderilmiş sayılmıyor. Kuyruğun ayrıntıları ve personel planı D5'te. |
| R5 — quiz/taslak | Tek aktif deneme, yerel şifreli taslak, koleksiyonda son eklenen sırası ve bağımsız tamamlanma kaydı kabul edildi. Puanlama D6, süreler D4'te. |
| R6 — giriş/oturum | Örnek önizleme, beyana dayalı üyelere görünen şehir, 15 dakika/30 gün oturum ve belirsiz refresh sonucunda tekrar giriş kabul edildi. Yaş/numara geri kazanma D3'te. |
| R7 — saklama | Sayılar aday süreler olarak kalıyor; sayısal süreler onaylanmadı. D4 sonuçlanmadan uygulanamaz veya vaat edilemez. |
| R8 — metrikler | Dağılım/alıcı koruması; varsayılan demografik alan yok; otomatik kota sıkma yerine operatör değerlendirmesi. |
| R9 — içerik | İlk yayında kurucunun son ses kontrolü; katalog adetleri içerik çalışmasında. Doğal yazım aynı sonuç kimliğinin anlamını değiştiremez. |
| R10 — limitler | Contracts'taki başlangıç limitleri ve tutarlı Unicode/literal filtre yaklaşımı kabul edildi. |

## İletişim ve kota kararları

A ilk gönderen, B ilk alıcıdır. Anonimlikte B, A'nın profilini öğrenmez.

| Karar | Kabul edilen davranış | Gerekçe ve bedel |
|---|---|---|
| Günlük hesap | Sunucunun son 24 saatte kabul ettiği istekler sayılır; gece yarısında sıfırlanmaz. | Takvim sınırında iki günlük hakkın art arda kullanımını önler; haklar topluca tek saatte yenilenmez. |
| A'nın bitirmesi | Tek başına yeni 14 günlük bekleme başlatmaz; önceki kısıtları silmez. | Gönderenin kararı ile alıcının reddi ayrılır. |
| B'nin bekleyen isteği raporlaması | İsteği kapatır ve bir ret sayılır. | İstenmeyen teması kapatır; otomatik suç tespiti veya hesap cezası değildir. |
| Açık iletişim | Aynı hesap çifti için iki yön toplamında tek bekleyen istek veya açık sohbet bulunur. | Paralel ilişkileri önler. Çakışma, anonim profil–sohbet bağlantısını açıklayamaz. |
| Bağlam değişmesi | Kapı veya seçilen içerik değişirse metin korunur; güncel bağlamla yeniden açık Gönder gerekir. | Görülmemiş kimlikle veya değiştirilmiş içerikle gönderim yapılmaz. |
| B reddetti, sohbet başlamadı | B, elindeki kapalı isteğe açıkça yanıt vererek sohbeti başlatabilir. | A yanıtı görür; geçmiş ret açıklanmaz. |
| B başlamış sohbeti bitirdi | B bir dönüş mesajı gönderebilir; A yanıtlayana kadar başka mesaj gönderemez. A'nın yanıtı sohbeti yeniden açar. | B geri dönebilir, A yeniden konuşmayı seçer; ek bekleme durumu gerekir. |

Alıcının ilk reddi/bitirmesi sonrası 14 gün ve ikinci redden sonra ilk gönderene kalıcı yeni-istek kısıtı korunur. Dönüş bu geçmişi silmez veya A'ya ayrı bir yeni istek izni vermez. Gerçek engelleme iki yönlüdür ve dönüşü durdurur. Anonimlik dönüşte de değişmez. Bekleyen alıcı isteklerine kapasite sınırı eklenmez; cevapsız istek otomatik ret değildir.

[Domain](../docs/domain.md), [Safety](../docs/safety.md) ve [Experience](../docs/experience.md) bu kararların uygulama kurallarını sahiplenir. Kısıtlı hesap kotasının kesin miktarı [Delivery](../docs/delivery.md) D10'da açık kalır; onaylanan pencere ve mevcut ücretsiz/ücretli/koruyucu kota ayrımı yeniden tartışmaya açılmaz. Quiz puanlama, Discover sıralama, saklama süreleri ve operasyonel moderasyon kendi açık çalışmalarını bekler.
