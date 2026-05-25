import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/domain/services/conversational_chat_service.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

/// Konuşma tabanlı chat servisi provider
final conversationalChatServiceProvider = Provider((ref) {
  return ConversationalChatService();
});

/// Sohbet mesajları state'i
final conversationalChatProvider =
    NotifierProvider<ConversationalChatNotifier, List<ChatMessage>>(
        ConversationalChatNotifier.new);

/// Loading durumu (mesaj gönderme sırasında)
final chatLoadingProvider = StateProvider<bool>((ref) => false);

class ConversationalChatNotifier extends Notifier<List<ChatMessage>> {
  late final ConversationalChatService _chatService;

  @override
  List<ChatMessage> build() {
    _chatService = ref.watch(conversationalChatServiceProvider);
    
    return [
      ChatMessage(
        id: 'welcome-chat',
        text:
            'Merhaba! 👋 Ben Ava, TrendDrink\'in AI arkadaşın. Sohbet etmek için buradayım! '
            'Nasılsın sen? Bugün nasıl geçiyor? 😊',
        author: ChatAuthor.assistant,
      ),
    ];
  }

  /// Mesaj gönder ve yanıt al
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Kullanıcı mesajını ekle
    final userMessage = ChatMessage(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      text: text.trim(),
      author: ChatAuthor.user,
    );

    state = [...state, userMessage];

    // Loading başlat
    ref.read(chatLoadingProvider.notifier).state = true;

    try {
      // Membership check (isteğe bağlı - bazı seviye kontrolleri için)
      final membership = ref.read(membershipProvider);

      // AI yanıtını al
      final aiResponse = await _chatService.sendMessage(text.trim(), membership);

      // AI mesajını ekle
      final assistantMessage = ChatMessage(
        id: 'assistant-${DateTime.now().millisecondsSinceEpoch}',
        text: aiResponse,
        author: ChatAuthor.assistant,
      );

      state = [...state, assistantMessage];
    } catch (e) {
      // Hata mesajı ekle
      final errorMessage = ChatMessage(
        id: 'error-${DateTime.now().millisecondsSinceEpoch}',
        text: 'Üzgünüm, bir hata oluştu: ${e.toString()}. Lütfen tekrar dene. 😞',
        author: ChatAuthor.assistant,
      );
      state = [...state, errorMessage];
    } finally {
      // Loading bitir
      ref.read(chatLoadingProvider.notifier).state = false;
    }
  }

  /// Sohbeti sıfırla (yeni başlat)
  void resetChat() {
    _chatService.clearHistory();
    state = [
      ChatMessage(
        id: 'welcome-chat',
        text:
            'Merhaba! 👋 Ben Ava, tekrar buradayım. Yeni bir sohbete başlıyor muyuz? 😊',
        author: ChatAuthor.assistant,
      ),
    ];
  }

  /// Sonuncu mesaj ID'si (scroll için)
  String? get lastMessageId => state.isNotEmpty ? state.last.id : null;
}
