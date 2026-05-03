import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

final assistantProvider = NotifierProvider<AssistantNotifier, List<ChatMessage>>(AssistantNotifier.new);

class AssistantNotifier extends Notifier<List<ChatMessage>> {
  late final DrinkRepository _repository;

  @override
  List<ChatMessage> build() {
    _repository = ref.read(drinkRepositoryProvider);
    return [
      ChatMessage(
        id: 'welcome',
        text: 'TrendDrink asistanına hoş geldin! Yaz veya malzemeni gir, sana özel tarifler önereyim.',
        author: ChatAuthor.assistant,
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    final message = text.trim();
    if (message.isEmpty) return;
    state = [
      ...state,
      ChatMessage(id: 'user-${DateTime.now().millisecondsSinceEpoch}', text: message, author: ChatAuthor.user),
    ];
    await Future<void>.delayed(const Duration(milliseconds: 650));
    final response = await _createResponse(message);
    state = [...state, response];
  }

  Future<ChatMessage> _createResponse(String query) async {
    final lower = query.toLowerCase();
    final drinks = await _repository.fetchAllDrinks();

    final matchedDrink = drinks.firstWhere(
      (drink) => lower.contains(drink.title.toLowerCase()) || drink.title.toLowerCase().contains(lower),
      orElse: () => DrinkModel(
        id: '',
        title: '',
        description: '',
        category: '',
        preparation: '',
        ingredients: const [],
        imageUrl: '',
        gradient: const LinearGradient(colors: [Color(0xFF000000), Color(0xFF000000)]),
      ),
    );

    if (matchedDrink.id.isNotEmpty) {
      return ChatMessage(
        id: 'assistant-${DateTime.now().millisecondsSinceEpoch}',
        text: 'Harika seçim! ${matchedDrink.title} tarifini detaylıca incelemek ister misin?',
        author: ChatAuthor.assistant,
        drinkId: matchedDrink.id,
      );
    }

    final categoryMatches = drinks
        .where((drink) => lower.contains(drink.category.toLowerCase()) || drink.ingredients.any((ingredient) => lower.contains(ingredient)))
        .toList();

    if (categoryMatches.isNotEmpty) {
      final suggestions = categoryMatches.take(3).map((drink) => drink.title).join(', ');
      return ChatMessage(
        id: 'assistant-${DateTime.now().millisecondsSinceEpoch}',
        text: 'Bu malzemelerle ya da içecek tarzıyla uyumlu tarifler: $suggestions. Hangisini görmek istersin?',
        author: ChatAuthor.assistant,
      );
    }

    final topDrinks = drinks.take(3).map((drink) => drink.title).join(', ');
    return ChatMessage(
      id: 'assistant-${DateTime.now().millisecondsSinceEpoch}',
      text: 'TrendDrink öneriyor: $topDrinks. Dilediğini yaz, sana hemen yönlendireyim.',
      author: ChatAuthor.assistant,
    );
  }
}
