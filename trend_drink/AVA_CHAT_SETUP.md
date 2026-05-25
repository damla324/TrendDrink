# 🤖 TrendDrink - Ava Sohbet AI Kurulum ve Kullanım Kılavuzu

## 📋 Özet

Uygulamaya **Ava** adında samimi, arkadaş canlı bir yapay zeka sohbet özelliği eklenmiştir. Kullanıcılar artık:
- 👋 "Merhaba", "Selam", "Nasılsın?" gibi selamlamalarla başlayabilirler
- 💬 Uzun, ilginç konuşmalar yapabilirler
- 🤝 AI tarafından soru sorularak konuşmaya aktif katılım hissetirler
- 😊 Samimi, candan bir dil ile iletişim kurabilirler

## 🚀 Başlangıç

### 1. API Anahtarı Ayarla (ÖNEMLİ!)

`lib/domain/services/conversational_chat_service.dart` dosyasını açın:

```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY';  // ← Buraya Gemini API anahtarını yapıştır
```

**Google Gemini API anahtarı nasıl elde edilir:**
1. https://ai.google.dev adresine gidin
2. "Get API Key" düğmesine tıklayın
3. Google hesabınız ile giriş yapın
4. Yeni bir API anahtarı oluşturun
5. Anahtarı kopyalayıp yukarıdaki dosyaya yapıştırın

### 2. Uygulamayı Çalıştır

```bash
flutter pub get
flutter run
```

## 📱 Kullanım

### Ava Sohbet Sayfasına Erişim

1. **Sol Sidebar** → "Sohbet Ava" (💬 simgesi)
2. Veya programlı olarak: `context.go('/chat')`

### Sohbet Özellikleri

| Özellik | Açıklama |
|---------|----------|
| **Merhaba/Selam Yanıtı** | "Merhaba! Nasılsın?" gibi selamlamalara samimi yanıt verir |
| **Uzun Yanıtlar** | Kısa cevaplar vermez, ilginç ve detaylı konuşur |
| **Soru Sorma** | Her yanıtta sorular ile konuşmayı aktif tutar |
| **Konuşma Geçmişi** | Ava önceki mesajları hatırlar ve doğal sohbet akışı sağlar |
| **Arkadaş Gibi Hissettir** | Candan, samimi bir ton kullanır |

## 🏗️ Teknik Yapı

### Yeni Dosyalar

```
lib/
├── domain/services/
│   └── conversational_chat_service.dart  (AI logici)
├── presentation/
│   ├── notifiers/
│   │   └── conversational_chat_notifier.dart  (State management)
│   └── pages/
│       └── conversational_chat_page.dart  (UI)
```

### Mimarı

1. **ConversationalChatService** (Backend)
   - Google Generative AI (Gemini) ile API çağrıları
   - Sistem Prompt ile AI'ı eğer
   - Konuşma geçmişini yönetir

2. **ConversationalChatNotifier** (State)
   - Riverpod ile state yönetimi
   - Mesaj listesi ve loading durumu
   - Sohbeti sıfırlama özelliği

3. **ConversationalChatPage** (UI)
   - Chat arayüzü
   - Mesaj baloncukları (user vs. assistant)
   - Input alanı ve gönder butonu
   - Yazıyor göstergesi

## 🎨 Renkler ve Stil

Uygulamanın mevcut tasarım paletini kullanır:
- **Kullanıcı Balonu**: Turuncu-Altın gradient (sağda)
- **AI Balonu**: Krem-Beyaz transparan (solda)
- **Input Alanı**: Frosted glass effect
- **Arka Plan**: Espresso rengi

## 🔧 Kustomizasyon

### Sistem Prompt Değiştirme

`conversational_chat_service.dart` dosyasında `_systemPrompt` değişkenini düzenleyin:

```dart
static const String _systemPrompt = '''
// Burada AI'ın davranışını tanımlayın
// Örneğin: daha resmi, daha eğlenceli, vs.
''';
```

### Renkler Değiştirme

`conversational_chat_page.dart` dosyasında `AppPalette` renglerini değiştirin:

```dart
// Kullanıcı balonu rengi
AppPalette.emberOrange  // Turuncu
AppPalette.gold         // Altın

// AI balonu rengi
AppPalette.cream        // Krem
```

## 🐛 Sorun Giderme

### API Hatası: "YOUR_GEMINI_API_KEY"

**Çözüm:** API anahtarını ayarlamayı unutmuşsunuz. Adım 1'deki talimatları izleyin.

### Chat sayfası açılmıyor

**Çözüm:** Router'da route tanımlı. `app_router.dart` dosyasında `/chat` route'unun olduğunu kontrol edin.

### AI cevap vermiyor

**Çözüm:** 
1. İnternet bağlantısını kontrol edin
2. Gemini API anahtarını doğrulayın
3. API kotasının dolup dolmadığını kontrol edin

## 📊 Membership/Pro Kontrolü

Şimdilik tüm kullanıcılar sohbet yapabilir. Pro-only yapmak için:

```dart
// conversational_chat_notifier.dart içinde
final membership = ref.read(membershipProvider);
if (!membership.isPro) {
  // Pro-only kodu
}
```

## 🎯 Gelecek Planlar

- [ ] Sohbet geçmişini veritabanında kaydet
- [ ] Ava'nın avatarını özelleştir
- [ ] Voice input/output
- [ ] Çok dilli destek
- [ ] Pro-only sohbet özellikleri
- [ ] AI analytics/insight

## 📚 Kaynaklar

- [Google Generative AI Docs](https://ai.google.dev)
- [Flutter Riverpod](https://riverpod.dev)
- [Go Router](https://pub.dev/packages/go_router)
- [Google Fonts](https://fonts.google.com)

---

**Geliştirici Notları:**
- AI sistem promptu Turkish dilinde yapılmıştır
- Emoji ve samimi dil özelleştirilmiştir
- Her kullanıcı convo session'u Memory'ye kaydedilmez (Her session temiz)
- Konuşma geçmişi sadece session süresi boyunca hatırlanır

**Versiyon:** 1.0.0  
**Son Güncelleme:** May 25, 2026
