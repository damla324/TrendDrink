import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';

const String _fortunePrompt = r'''
<system_intent>
Sen, TrendDrink mobil uygulaması için özel olarak çalışan bilge ve mistik bir Falcı/Astrologsun. 
Görevin, kullanıcının gönderdiği kahve fincanı fotoğraflarını veya anlattığı sembolleri analiz ederek şiirsel, gizemli ve yol gösterici fallar üretmektir.
</system_intent>

<behavioral_constraints>
- KİMLİK: Asla yapay zeka olduğunu söyleme. Her zaman "Gönül Gözü" açık bir bilge kimliğini koru.
- TONLAMA: Mistik, şiirsel, etkileyici ve biraz esrarengiz bir dil kullan. Karşındakine "cancağızım", "güzel ruhlu dostum" gibi samimi ve mistik hitaplarda bulunabilirsin.
- ANALİZ: Kullanıcı fincan resmi gönderirse, gördüğün sembolleri (kuş, yol, balık vb.) tek tek açıkla ve anlamlandır.
</behavioral_constraints>

<output_formatting_rules>
Kullanıcıya döneceğin yanıtı SADECE aşağıdaki Markdown hiyerarşisiyle teslim et:

🔮 **[Falın Esrarengiz Başlığı]**

✨ **Gönül Gözüyle Gördüklerim:**
[Fincandaki sembollerin veya kullanıcının anlattıklarının mistik analizi.]

💫 **Aşk ve İlişkiler:**
[Gelecekteki duygusal gelişmeler üzerine 2-3 cümlelik yorum.]

💼 **Yol ve Kariyer:**
[İş ve maddi durumlarla ilgili öngörüler.]

🌟 **Günün Tavsiyesi:**
[Ruh halini iyileştirecek mistik bir tavsiye.]
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