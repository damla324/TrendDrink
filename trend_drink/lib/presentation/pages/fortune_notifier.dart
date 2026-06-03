import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';

const String _fortunePrompt = r'''Sen bir Mistik Falcısın...''';

final fortuneProvider = NotifierProvider<FortuneNotifier, List<ChatMessage>>(FortuneNotifier.new);

class FortuneNotifier extends Notifier<List<ChatMessage>> {
  late final GenerativeModel _model;
  late ChatSession _chat;

  @override
  List<ChatMessage> build() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
      systemInstruction: Content.system(_fortunePrompt),
    );
    _chat = _model.startChat();
    return [ChatMessage(id: 'w-f', text: "Fincanında neler var? 🔮", author: ChatAuthor.assistant)];
  }

  Future<void> sendMessage(String text, {Uint8List? imageBytes, String? imageName}) async {
    state = [...state, ChatMessage(id: 'u-${DateTime.now()}', text: text, author: ChatAuthor.user)];
    final response = await _chat.sendMessage(Content.text(text));
    state = [...state, ChatMessage(id: 'ai-${DateTime.now()}', text: response.text ?? '...', author: ChatAuthor.assistant)];
  }
}