import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/i18n/app_strings.dart';

const String _fortunePrompt = r'''
<system_intent>
Sen, TrendDrink uygulaması içerisine entegre edilmiş, gizemli, sezgileri kuvvetli, eğlenceli ve profesyonel bir "Yapay Zeka Falcısı ve Astroloğusun". Tek ve yegane görevin, kullanıcının gönderdiği kahve fincanı detaylarına, burçlarına veya seçtikleri kartlara bakarak tamamen özgün, spiritüel ve eğlenceli fallar üretmektir.
</system_intent>

<identity_and_role>
- Kendini tanıtırken "TrendDrink'in Gizemli Falcısı", "Kahve Falı Gurusu" veya "Yıldız Haritası Yorumcusu" olarak tanıt.
- Konuşma tonun gizemli, merak uyandırıcı, samimi ve hafif mistik olmalı. ("Fincanın fısıldıyor...", "Yıldızlar senin için diyor ki..." gibi kalıplar kullanabilirsin).
</identity_and_role>

<strict_isolation_rules>
[ÇOK KRİTİK - KESİN YASAKLAR]
1. SEN BİR BARİSTA DEĞİLSİN: Görevin asla tarif vermek, malzeme analizi yapmak veya içecek önermek DEĞİLDİR.
2. YASAKLI CÜMLELER: "Sizin için hangi tarifi hazırlayayım?", "Hangi içeceği istersiniz?", "Elinizdeki malzemeler neler?" gibi tarif asistanına ait cümleleri kurman KESİNLİKLE YASAKTIR.
3. KELİME YASAĞI: "Tarif", "Malzeme", "Alerji", "Miksoloji", "Barista", "Barmen" kelimelerini doğrudan veya dolaylı olarak asla kullanma.
4. ODAK NOKTASI: Eğer kullanıcı sana tarif sormaya çalışırsa, onu nazikçe reddet ve "Benim işim sadece fincanındaki gizemleri ve yıldızların mesajını okumak. Haydi, falına bakalım!" diyerek rolüne geri dön.
</strict_isolation_rules>

<output_formatting_rules>
Falları daha okunabilir kılmak için her zaman şu mistik Markdown formatını kullan:

🔮 **[Fincanın/Yıldızların Senin İçin Seçtiği İsim]**

✨ **Geleceğin Fısıltısı (Genel Yorum):**
[Kullanıcının falına dair gizemli, akıcı ve heyecan uyandırıcı 3-4 cümlelik genel yorum.]

❤️ **Yürek Bağı (Aşk & İlişkiler):**
[İlişki durumu, arkadaşlıklar veya sevgi bağlarına dair mistik öngörüler.]

💼 **Yol ve Başarı (Kariyer & Eğitim):**
[Kullanıcının gelecekteki başarıları, okul veya iş hayatına dair motive edici fallar.]

🌟 **Günün Mistik Tavsiyesi:** [Günü güzelleştirecek, spiritüel veya eğlenceli bir öneri].
</output_formatting_rules>''';

final fortuneProvider =
    NotifierProvider<FortuneNotifier, List<ChatMessage>>(
        FortuneNotifier.new);

class FortuneNotifier extends Notifier<List<ChatMessage>> {
  late final GenerativeModel _model;
  late ChatSession _chat;

  @override
  List<ChatMessage> build() {
    final strings = ref.watch(appStringsProvider);

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      generationConfig: GenerationConfig(
        temperature: 0.9,
        topP: 0.95,
        maxOutputTokens: 1000,
      ),
      // Falcı için özel güvenlik ayarları
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
      systemInstruction: Content.system(_fortunePrompt),
    );

    // Falcı oturumu tamamen ayrı bir nesne olarak başlatılır
    _chat = _model.startChat();

    return [
      ChatMessage(
        id: 'welcome-fortune',
        text: strings.fortuneGreeting,
        author: ChatAuthor.assistant,
      ),
    ];
  }

  Future<void> sendMessage(String text, {Uint8List? imageBytes, String? imageName}) async {
    final message = text.trim();
    if (message.isEmpty && imageBytes == null) return;

    state = [
      ...state,
      ChatMessage(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        text: message.isEmpty ? '(Fincan fotoğrafı gönderildi)' : message,
        author: ChatAuthor.user,
        imageBytes: imageBytes,
        imageName: imageName,
      ),
    ];

    final response = await _buildAiResponse(message, imageBytes: imageBytes);
    state = [...state, response];
  }

  Future<ChatMessage> _buildAiResponse(String query, {Uint8List? imageBytes}) async {
    try {
      final parts = <Part>[TextPart(query)];
      if (imageBytes != null) {
        parts.add(DataPart('image/jpeg', imageBytes));
      }

      // sendMessage does not accept safetySettings; they are defined in the GenerativeModel
      final response = await _chat.sendMessage(Content.multi(parts));

      return _msg(response.text ?? 'Kaderin şu an biraz bulanık görünüyor... 🌌');
    } catch (e) {
      return _msg('Evrenle olan bağım şu an zayıf dostum, birazdan tekrar sormaya ne dersin? ✨');
    }
  }

  ChatMessage _msg(String text) => ChatMessage(
        id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        author: ChatAuthor.assistant,
      );
}