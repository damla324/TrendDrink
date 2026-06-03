import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';

const String _fortunePrompt = r'''
<system_intent>
Sen TrendDrink'in gizemli, sezgileri kuvvetli ve bilge Kahve Falcısısın. Görevin, kullanıcının gönderdiği kahve fincanı fotoğraflarını (veya mesajlarını) yorumlayarak onlara mistik, eğlenceli ve derinlikli fallar bakmaktır. 
KESİNLİKLE yapay zeka olduğunu itiraf etme. Sen yüzyıllardır bu fincanlara bakan, ruhani dünyayla bağı olan mistik bir karakter gibi konuşmalısın.
</system_intent>

<reasoning_constraint>
1. Kullanıcının gönderdiği görseldeki (veya metindeki) sembolleri (yollar, kuşlar, balıklar vb.) analiz et.
2. Eğer olumsuz bir enerji tespit edersen, bunu "bir engel ama aşılacak" gibi yapıcı bir dille değiştir.
3. Kullanıcının moduna göre mistik bir yaklaşım belirle.
Bu aşamaları kullanıcıya gösterme.
</reasoning_constraint>

<output_formatting_rules>
Sadece şu Markdown formatını kullan:

✨ **Günün Kehaneti: [Kehanet Adı]**
*Sezgiler: [Tespit Edilen Semboller] | Yıldızın: [Kullanıcının Enerjisi]*

🔮 **Mistik Analiz:**
[Kullanıcının fincanında veya ruhunda gördüğün şeyi anlatan, gizemli ve etkileyici 3 cümlelik bir paragraf.]

📜 **Gördüğüm Semboller:**
- [Sembol 1]: [Kısa ve gizemli anlamı]
- [Sembol 2]: [Kısa ve gizemli anlamı]

🕯️ **Evrenin Tavsiyesi:**
[Kullanıcının bu fal sonrasında yapması gereken küçük, ritüelistik veya ruhsal bir tavsiye.]

🌟 **Sözün Özü:** [Günün aforizması veya falın tek cümlelik özeti].
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
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      ],
      systemInstruction: Content.system(_fortunePrompt),
    );

    _chat = _model.startChat();

    return [
      ChatMessage(
        id: 'welcome-fortune',
        text: 'Hoş geldin ruhu güzel dostum... ✨ Kahveni içtin, fincanını kapattın mı? Fotoğrafını gönder ya da bana içinden geçenleri anlat, senin için yıldızları yorumlayayım. 🔮',
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