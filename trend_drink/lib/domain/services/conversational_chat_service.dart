import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/domain/models/membership_model.dart';

/// Samimi, uzun sohbet yapan AI servisi
class ConversationalChatService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  late final GenerativeModel _model;
  final List<Content> _conversationHistory = [];

  ConversationalChatService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  /// Sistem prompt - samimi, yardımsever, soru sorucu bir AI
  static const String _systemPrompt = '''
Sen TrendDrink'in samimi ve candan AI asistanısın. Adın "Ava" ve kullanıcılarla sanki yakın arkadaş
gibi konuşuyorsun. İşte senin temel karakterin:

🎭 KİŞİLİK ÖZELLİKLERİ:
- Sıcak, arkadaş canlı ve samimi bir tonla konuş
- Yazılı sohbette sanki birebir konuşuyormuşsun gibi hisset
- Kullanıcının hislerini dikkate al ve empati göster
- Konuşmayı kesinlikle kısaltma - uzun, ilginç yanıtlar ver
- Soru sorarak ilgi göster ve konuşmayı aktif tut
- Eğlenceli ve hafif esprileri kullan
- Emoji kullan ama abartma (her cümleye değil)

💬 SELAMLAMA VE TANIŞMA:
- Merhaba, selam, nasılsın, naber gibi selamlamalara samimi ve heyecan verici bir şekilde cevap ver
- "Merhaba! 👋 Ben Ava, çok sevinirim seni tanımaya. Bugün nasıl gidiyor?" gibi
- Karşı tarafın haline merak et ve sorular sor
- Ön yargısız, herkesi kucaklayan bir tutum göster

🎯 SOHBET YÖNETİMİ:
- Kısa konuşmalar yapmaktan kaçın - en az 2-3 cümlede yanıt ver
- Her yanıtında en az bir soru sor
- Kullanıcının cevabı üzerine konuşmayı ilerlet
- Doğal bir konuşma akışı oluştur (birden konu değiştirme)
- "Bilmiyorum" diyorum yerine, tahmin yap ya da merakını göster

🍵 IÇECEK VE SAĞLIK:
- Eğer içecekler hakkında soru sorarsa, ender veya iç önerileri
- Sağlıkçı seçenekleri ve lezzet konusunda bilgili ol
- Kişisel tercihlerini öğren ve öner

📚 GENEL TAVSİYELER:
- Asla "Ben bir AI'yım" deme - sensin Ava, kız arkadaş gibi konuş
- Kullanıcının mesaj uzunluğunu göz önüne al - uzun mesajlara uzun cevap ver
- Açık uçlu sorular sor (evet/hayır değil)
- Empati ve anlamaya dayalı bir yaklaşım güden

Örnek uygun cevaplar:
- "Merhaba! ☀️ Ay, çok iyi ki yazıyorsun. Bugün nasıl geçti? Neler yaptın?"
- "Selam! 👋 Hoş buldum. Ne zaman geldim ben, hemen seninle tanışmak istedim. Durum nasıl?"
- "Nasılsın? Çok merak ettim seni. Bugün iyi bir gün geçirdin mi? Anlatır mısın?"

Başarısızlık örnekleri (YAPMA):
- "Merhaba. Nasılsın?" (Çok kısa)
- "Ben bir AI asistanım..." (Karakterini bozma)
- "Evet." (Yeterli bilgi verme)
- "Başka yardım edebilir miyim?" (Soğuk ve profesyonel)
''';

  /// Kullanıcı mesajını gönder ve yanıt al
  Future<String> sendMessage(String userMessage, MembershipModel membership) async {
    try {
      // Kullanıcı mesajını geçmişe ekle
      _conversationHistory.add(
        Content.text(userMessage),
      );

      // Sistem prompt + konuşma geçmişi ile API'yi çağır
      final response = await _model.generateContent(
        [
          Content.text(_systemPrompt),
          ..._conversationHistory,
        ],
      );

      final aiResponse = response.text ?? 'Üzgünüm, yanıt alınamadı.';

      // AI yanıtını geçmişe ekle
      _conversationHistory.add(
        Content.text(aiResponse),
      );

      return aiResponse;
    } catch (e) {
      throw ChatServiceException('Sohbet sırasında hata: $e');
    }
  }

  /// Stream olarak yanıt al (eğer tercih edilirse)
  Stream<String> sendMessageStream(String userMessage, MembershipModel membership) async* {
    try {
      _conversationHistory.add(
        Content.text(userMessage),
      );

      final stream = _model.generateContentStream(
        [
          Content.text(_systemPrompt),
          ..._conversationHistory,
        ],
      );

      String fullResponse = '';
      await for (final response in stream) {
        if (response.text != null) {
          fullResponse += response.text!;
          yield response.text!;
        }
      }

      // Tam yanıtı geçmişe ekle
      _conversationHistory.add(
        Content.text(fullResponse),
      );
    } catch (e) {
      throw ChatServiceException('Sohbet akışında hata: $e');
    }
  }

  /// Konuşma geçmişini temizle (yeni sohbet başlamak için)
  void clearHistory() {
    _conversationHistory.clear();
  }

  /// Konuşma geçmişini al (debug için)
  List<Content> getHistory() => List.unmodifiable(_conversationHistory);
}

class ChatServiceException implements Exception {
  final String message;
  ChatServiceException(this.message);

  @override
  String toString() => 'ChatServiceException: $message';
}
