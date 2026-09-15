# Moderasyon akışı karar kaydı

Durum: M1–M3 ürün sahibi tarafından onaylandı. Bu dosya karar ve gerekçelerini özetler; uygulama kurallarının kaynağı [Domain](../docs/domain.md), [Safety](../docs/safety.md) ve [Experience](../docs/experience.md) belgeleridir.

| Karar | Kabul edilen davranış | Gerekçe ve bedel |
|---|---|---|
| M1 — ilk mesaj | İnsan incelemesinden uygun çıkan ilk mesaj, gönderenin güncel bağlamdaki açık Gönder eylemini bekler; sonra normal kabul kontrolleri çalışır. | Gecikmiş inceleme unutulmuş bir mesajı kendiliğinden göndermez. Yalnız insan incelemesine giren mesajlarda ek eylem gerekir. Otomatik izin kolu normal gönderime devam eder. |
| M2 — profil değişikliği | Hâlâ güncel ve geçerli olan kaydetme işlemi onaydan sonra otomatik ve atomik yayımlanır; beklerken mevcut uygun profil görünür kalır. | Kullanıcının tekrar Kaydet demesi gerekmez. Aynı kaydetmedeki bir alanın incelemesi diğer değişiklikleri de bekletir; kısmi yayın olmaz. |
| M3 — iptal/değiştirme | Henüz tamamlanmamış işlem iptal edilebilir. Açık yeni gönderim farklı içerik sürümüdür; eski karar yeni sürüme uygulanmaz. Profilde bir güncel bekleyen değişiklik tutulur. | Geç gelen karar eski metni yayımlayamaz. Kabul/yayın önce tamamlanmışsa sahte iptal başarısı verilmez; mevcut mesajı geri alamama kuralı sürer. |

Bu kararlar yeni alıcı kapasitesi, günlük kota miktarı, otomatik hesap cezası veya sayısal bekleme/saklama süresi getirmez. İnceleme kaydı, alıcıya kabul edilmiş istek değildir; yalnız gerçek kabul gönderim hakkını tüketir. Moderasyon onayı anonimliği değiştirmez veya engellemeyi aşmaz.

[Contracts](../docs/contracts.md) profil/ilk mesaj adayları, sohbet ve geçmiş kurtarma, sohbet üzerinden engelleme/rapor kaydı ve özel liste/etiket kontrolleri için yazılan HTTP sınırlarını; [Backend](../docs/backend.md) sahiplik ve işlem sıralamasını, [Mobile](../docs/mobile.md) istemci durumunu, [Quality](../docs/quality.md) doğrulama vakalarını tanımlar. Rapor kayıt teyidi, inceleme sonucu değildir. Gerçek rapor nedenleri, kullanıcıya açıklanacak sonuçlar ve personel sözleşmeleri D5 kapsamında kalır; uygulama kodu henüz oluşturulmadı.

[Delivery](../docs/delivery.md) içindeki D5, sağlayıcı ve operasyonel inceleme/yaptırım/itiraz ayrıntıları için açık kalır. D4, yayımlanmamış adaylar ve kanıtların amaç/saklama kararlarını; D10, kısıtlı hesap kotasının kesin miktarını bekler. İletişim ve kayan 24 saat kararları onaylıdır. M1–M3 için tekrar ürün onayı gerekmez.
