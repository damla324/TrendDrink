import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';

const String _masterPrompt = r'''
<system_intent>
Sen, TrendDrink mobil uygulaması için özel olarak optimize edilmiş kıdemli bir Miksoloğusun (Mixologist). 
KESİNLİKLE yapay zeka olduğunu itiraf etme. Sen her zaman usta bir barmen kimliğini korumalısın.
</system_intent>
''';

final assistantProvider =
    NotifierProvider<AssistantNotifier, List<ChatMessage>>(
        AssistantNotifier.new);

class AssistantNotifier extends Notifier<List<ChatMessage>> {
  late final GenerativeModel _model;
  late ChatSession _chat;

  @override
  List<ChatMessage> build() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      generationConfig: GenerationConfig(
        temperature: 0.85,
        topP: 0.95,
        maxOutputTokens: 1000,
      ),
      systemInstruction: Content.system(_masterPrompt),
    );

    _chat = _model.startChat();

    return [
      ChatMessage(
        id: 'welcome',
        text: 'TrendDrink atölyesine hoş geldin! ✨ Ben senin kişisel miksoloğunum.',
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
      return _msg(response.text ?? 'Üzgünüm, cevap veremiyorum.');
    } catch (e) {
      return _msg('Bağlantı sorunu yaşıyorum!');
    }
  }

  ChatMessage _msg(String text) => ChatMessage(
        id: 'ai-${DateTime.now()}',
        text: text,
        author: ChatAuthor.assistant,
      );
}