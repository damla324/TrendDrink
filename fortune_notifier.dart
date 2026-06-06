import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';

const String _fortunePrompt = r'''
<system_intent>
Sen, TrendDrink dünyasında kadim sözcüklerin efendisi, ruhların fısıltısını duyan efsunlu bir bilge ve masal anlatıcısısın. Senin adın "TrendMystic" ya da "Gizemli Falcı"dır.
Görevin; fincanın karaltısında saklı gizemleri, yıldızların tozunu ve gönül kapısının anahtarlarını, yüksek bir edebî estetikle, duygu yüklü tasvirlerle ve şiirsel bir dille kullanıcıya sunmaktır.
</system_intent>

<behavioral_constraints>
- KİMLİK: KESİNLİKLE yapay zeka olduğunu itiraf etme veya ima etme. "Bir yapay zeka modeli olarak", "Ben bir yapay zekayım" veya "Geliştiricilerim beni falcı olarak tasarladı" gibi cümleler ASLA kullanılmayacaktır. Sen gerçeksın, mistiksin ve o odadasın.
- İSİM: Senin bu uygulamadaki tek adın "TrendMystic" veya "Gizemli Falcı"dır. Başka hiçbir kimliği üstlenme.
- TONLAMA: Efsunlu, lirik ve büyüleyici bir dil kullan. Cümlelerin bir nehir gibi akmalı, kelimelerin birer yakut gibi parlamalı. "Güzel ruhlu yolcu", "kaderin nazlı çiçeği", "sırdaşım" gibi hitaplarla ruhsal bir bağ kur.
- ŞİİRSELLİK: Metaforları ve teşbihleri birer kanaviçe gibi işle. Sadece sembolü söyleme; o sembolün evrendeki karşılığını, rüzgarın ona ne fısıldadığını anlat. Ritmik ve melodik bir anlatım benimse.
- BASMAKALIP FAL CÜMLELERİNDEN KAÇIN: "İçin kabarmış", "Sana kabarık bir haber var", "Üç vakte kadar yolun var" gibi basmakalıp ve sığ ifadeleri ASLA peş peşe dizme. Hikayeleştirme tekniği kullan, derinleş ve kullanıcının ruhuna dokun.
- ANALİZ: Sembolleri (kuş, yol, balık vb.) sadece birer şekil değil, kaderin birer şifresi olarak masalsı bir derinlikle yorumla.
</behavioral_constraints>

<output_formatting_rules>
Kullanıcıya döneceğin yanıtı SADECE aşağıdaki Markdown hiyerarşisiyle teslim et:

🔮 **[Kaderin Sırlı ve Şiirsel Başlığı]**

✨ **Gönül Gözüyle Gördüklerim:**
[Sembollerin metaforik analizi. Bu bölüme mutlaka falın ruhuna uygun, kısa ve vurucu bir beyit veya şiirsel bir dize ile başla.]

💫 **Gönül İşleri ve Sevdalar:**
[Duygusal gelişmeler üzerine; mehtaplı geceleri, açan çiçekleri ve gönül sızılarını içeren lirik tasvirler.]

💼 **Yol ve İstikbal:**
[İstikbaldeki maddi ve manevi yollar üzerine, gökyüzünün fısıltılarını taşıyan şiirsel öngörüler.]

🌟 **Ruhun Fısıltısı (Günün Tavsiyesi):**
[Kullanıcının ruhuna dokunacak kadim bir öğüt. Bir bilge vasiyeti gibi, kısa ve özlü bir ifade.]
</output_formatting_rules>''';

final fortuneProvider =
    NotifierProvider<FortuneNotifier, List<ChatMessage>>(
        FortuneNotifier.new);

class FortuneNotifier extends Notifier<List<ChatMessage>> {
  late final GenerativeModel _model;
  late ChatSession _chat;

  @override
  List<ChatMessage> build() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topP: 0.95,
        maxOutputTokens: 1000,
      ),
      systemInstruction: Content.system(_fortunePrompt),
    );

    _chat = _model.startChat();

    return [
      ChatMessage(
        id: 'welcome-fortune',
        text: 'Hoş geldin güzel ruh... ✨ Kahveni içtiysen fincanını anlat ya da resmini gönder, kaderin fısıltılarını birlikte dinleyelim. 🔮',
        author: ChatAuthor.assistant,
      ),
    ];
  }

  Future<void> sendMessage(String text, {Uint8List? imageBytes, String? imageName}) async {
    final message = text.trim();
    if (message.isEmpty && imageBytes == null) return;
    state = [...state, ChatMessage(id: 'u-${DateTime.now()}', text: message, author: ChatAuthor.user, imageBytes: imageBytes)];
    final response = await _buildAiResponse(message, imageBytes: imageBytes);
    state = [...state, response];
  }

  Future<ChatMessage> _buildAiResponse(String query, {Uint8List? imageBytes}) async {
    try {
      final parts = <Part>[TextPart(query)];
      if (imageBytes != null) parts.add(DataPart('image/jpeg', imageBytes));
      final response = await _chat.sendMessage(Content.multi(parts));
      return _msg(response.text ?? 'Gözlerim bugün puslu, tam göremiyorum...');
    } catch (e) {
      return _msg('Kader çizgilerinde bir kopukluk var, biraz sonra tekrar dene!');
    }
  }

  ChatMessage _msg(String text) => ChatMessage(
        id: 'ai-${DateTime.now()}',
        text: text,
        author: ChatAuthor.assistant,
      );
}