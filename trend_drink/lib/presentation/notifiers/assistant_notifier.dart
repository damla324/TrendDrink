import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

final assistantProvider =
    NotifierProvider<AssistantNotifier, List<ChatMessage>>(
        AssistantNotifier.new);

class AssistantNotifier extends Notifier<List<ChatMessage>> {
  late final DrinkRepository _repository;

  @override
  List<ChatMessage> build() {
    _repository = ref.read(drinkRepositoryProvider);
    return [
      ChatMessage(
        id: 'welcome',
        text:
            'Merhaba! Ben İçecek AI 🍵\n\nElindeki malzemeleri yaz, bir kategori sor ya da ruh haline göre öneri isteye bilirsin.',
        author: ChatAuthor.assistant,
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    final message = text.trim();
    if (message.isEmpty) return;

    state = [
      ...state,
      ChatMessage(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        text: message,
        author: ChatAuthor.user,
      ),
    ];

    await Future<void>.delayed(const Duration(milliseconds: 700));
    final response = await _buildResponse(message);
    state = [...state, response];
  }

  Future<ChatMessage> _buildResponse(String query) async {
    final drinks = await _repository.fetchAllDrinks();
    final lower = _normalize(query);

    // ── 1. Exact/partial drink title match ─────────────────────────────
    final titleMatch = _findByTitle(drinks, lower);
    if (titleMatch != null) {
      return _msg(
        '**${titleMatch.title}** için detaylı tarifi görmek ister misin? '
        'Tarih, faydaları ve yapılışı seni bekliyor. 👇',
        drinkId: titleMatch.id,
      );
    }

    // ── 2. Ingredient matching ──────────────────────────────────────────
    final tokens = _tokenize(lower);
    final byIngredient = _findByIngredients(drinks, tokens);
    if (byIngredient.isNotEmpty) {
      final names = byIngredient.take(3).map((d) => d.title).join(', ');
      final ids = byIngredient.take(1).map((d) => d.id).firstOrNull;
      return _msg(
        'Elindeki malzemelerle yapabileceğin içecekler: **$names**. '
        'Birini tıklayarak detayına gidebilirsin.',
        drinkId: ids,
      );
    }

    // ── 3. Category keyword ─────────────────────────────────────────────
    final categoryMatch = _findByCategory(drinks, lower);
    if (categoryMatch.isNotEmpty) {
      final names = categoryMatch.take(3).map((d) => d.title).join(', ');
      return _msg(
        'Bu kategoriden önerilerim: **$names**. Hangisi ilgini çekiyor?',
        drinkId: categoryMatch.first.id,
      );
    }

    // ── 4. Mood/feeling keywords ────────────────────────────────────────
    final moodResp = _matchMood(drinks, lower);
    if (moodResp != null) return moodResp;

    // ── 5. Temperature ──────────────────────────────────────────────────
    if (lower.contains('sıcak') ||
        lower.contains('sicak') ||
        lower.contains('ılık')) {
      final hot = drinks.where((d) => d.temperature == 'Sıcak').toList();
      if (hot.isNotEmpty) {
        final names = hot.take(3).map((d) => d.title).join(', ');
        return _msg('Sıcak içecek önerilerim: **$names**.',
            drinkId: hot.first.id);
      }
    }
    if (lower.contains('soğuk') ||
        lower.contains('soguk') ||
        lower.contains('buzlu')) {
      final cold = drinks.where((d) => d.temperature == 'Soğuk').toList();
      if (cold.isNotEmpty) {
        final names = cold.take(3).map((d) => d.title).join(', ');
        return _msg('Soğuk içecek önerilerim: **$names**.',
            drinkId: cold.first.id);
      }
    }

    // ── 6. Fallback ─────────────────────────────────────────────────────
    final topNames = drinks.take(3).map((d) => d.title).join(', ');
    return _msg(
      'Tam olarak anlayamadım 😅 Ama şu an popüler olanlar: **$topNames**. '
      'Bir malzeme ya da kategori adı yazarsan daha iyi yönlendiririm!',
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────
  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll('ğ', 'g')
      .replaceAll('ş', 's')
      .replaceAll('ç', 'c')
      .replaceAll('ı', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u');

  List<String> _tokenize(String s) =>
      s.split(RegExp(r'[,;\s/&+]+')).where((t) => t.length >= 3).toList();

  DrinkModel? _findByTitle(List<DrinkModel> drinks, String lower) {
    for (final d in drinks) {
      final normalized = _normalize(d.title);
      if (lower.contains(normalized) || normalized.contains(lower)) return d;
      for (final word in lower.split(' ')) {
        if (word.length >= 4 && normalized.contains(word)) return d;
      }
    }
    return null;
  }

  List<DrinkModel> _findByIngredients(
      List<DrinkModel> drinks, List<String> tokens) {
    return drinks.where((d) {
      return d.ingredients
          .any((ing) => tokens.any((t) => _normalize(ing).contains(t)));
    }).toList();
  }

  List<DrinkModel> _findByCategory(List<DrinkModel> drinks, String lower) {
    const categoryMap = {
      'kahve': 'Kahve',
      'coffee': 'Kahve',
      'matcha': 'Matcha',
      'frozen': 'Frozen',
      'dondurulmus': 'Frozen',
      'kokteyl': 'Kokteyl',
      'cocktail': 'Kokteyl',
      'smoothie': 'Smoothie',
      'cay': 'Çay',
      'tea': 'Çay',
      'soda': 'Soda',
      'fit': 'Fit',
      'saglikli': 'Fit',
      'protein': 'Fit',
    };
    for (final entry in categoryMap.entries) {
      if (lower.contains(entry.key)) {
        return drinks.where((d) => d.category == entry.value).toList();
      }
    }
    return [];
  }

  ChatMessage? _matchMood(List<DrinkModel> drinks, String lower) {
    if (lower.contains('enerji') ||
        lower.contains('uyku') ||
        lower.contains('yorgun')) {
      final e = drinks
          .where((d) => d.category == 'Kahve' || d.category == 'Matcha')
          .take(2)
          .toList();
      if (e.isNotEmpty) {
        return _msg(
          'Enerji için kahve veya matcha kombinasyonu harika! '
          'Dene: **${e.map((d) => d.title).join(", ")}**.',
          drinkId: e.first.id,
        );
      }
    }
    if (lower.contains('diyet') ||
        lower.contains('fit') ||
        lower.contains('saglik')) {
      final f = drinks
          .where((d) => d.category == 'Fit' || d.category == 'Smoothie')
          .take(3)
          .toList();
      if (f.isNotEmpty) {
        return _msg(
          'Sağlıklı seçenekler için: **${f.map((d) => d.title).join(", ")}**.',
          drinkId: f.first.id,
        );
      }
    }
    if (lower.contains('parti') ||
        lower.contains('eglence') ||
        lower.contains('aksam')) {
      final p = drinks.where((d) => d.category == 'Kokteyl').take(3).toList();
      if (p.isNotEmpty) {
        return _msg(
          'Akşam partisi için: **${p.map((d) => d.title).join(", ")}**! 🎉',
          drinkId: p.first.id,
        );
      }
    }
    return null;
  }

  ChatMessage _msg(String text, {String? drinkId}) {
    return ChatMessage(
      id: 'assistant-${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      author: ChatAuthor.assistant,
      drinkId: drinkId,
    );
  }
}
