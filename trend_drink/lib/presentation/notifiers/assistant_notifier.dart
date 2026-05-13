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

    // ── 0. Sensitivity/Allergen matching ────────────────────────────────
    final sensitivityResp = _matchSensitivity(drinks, lower);
    if (sensitivityResp != null) return sensitivityResp;

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

  ChatMessage? _matchSensitivity(List<DrinkModel> drinks, String lower) {
    // ── Sensitivity/allergen keywords ──────────────────────────────────
    const sensitivityMap = {
      'kafein': 'kafein',
      'kafeinsiz': 'kafein',
      'cafeinated': 'kafein',
      'decaf': 'kafein',
      'şeker': 'şeker',
      'seker': 'şeker',
      'şekersiz': 'şeker',
      'diyabet': 'şeker',
      'sugar': 'şeker',
      'sugarfree': 'şeker',
      'süt': 'süt',
      'sut': 'süt',
      'laktoz': 'süt',
      'dairy': 'süt',
      'vegan': 'vegan',
      'vejetaryen': 'vegan',
      'gluten': 'gluten',
      'glutenfree': 'gluten',
      'alerji': 'alerji',
      'alerjik': 'alerji',
      'allergen': 'alerji',
      'kolin': 'kolin',
      'çikolata': 'çikolata',
      'cikola': 'çikolata',
      'chocolate': 'çikolata',
      'nut': 'fındık',
      'fındık': 'fındık',
      'findik': 'fındık',
      'almond': 'almond',
      'kaju': 'kaju',
    };

    for (final entry in sensitivityMap.entries) {
      if (lower.contains(entry.key)) {
        final allergen = entry.value;
        final compatible =
            drinks.where((d) => !d.allergens.contains(allergen)).toList();

        if (compatible.isNotEmpty) {
          final names = compatible.take(3).map((d) => d.title).join(', ');
          final drinkId = compatible.first.id;

          String message;
          switch (allergen) {
            case 'kafein':
              message =
                  '✨ Kafeinsiz seçenekler seni bekliyor! **$names**. Hangisini denemek ister misin?';
              break;
            case 'şeker':
              message =
                  '🍯 Düşük şeker veya şekersiz içecekler: **$names**. Sağlıklı seçim! 💪';
              break;
            case 'süt':
              message =
                  '🥛 Sütü olmayan seçenekler: **$names**. Veya vegan alternatif bulabilirim!';
              break;
            case 'vegan':
              message =
                  '🌱 Tamamen vegan seçenekler: **$names**. Doğaya saygılı tercih! 🌍';
              break;
            case 'gluten':
              message =
                  '🌾 Glutensiz içecekler: **$names**. Rahatça içebilirsin! ✅';
              break;
            case 'alerji':
              message =
                  '⚠️ Yaygın alerjenlerden uzak içecekler: **$names**. Güvenli tercih!';
              break;
            case 'çikolata':
              message =
                  '🍫 Çikolatasız alternatifler: **$names**. Farklı bir deneyim için!';
              break;
            case 'fındık':
              message =
                  '🥜 Fındıksız seçenekler: **$names**. Diğer tatlar seni bekliyor!';
              break;
            default:
              message =
                  '✨ **$allergen** içermeyen seçenekler: **$names**. Hangisini tercih edersin?';
          }

          // ── Suggest alternatives from first drink ──────────────────────
          if (compatible.first.alternatives.isNotEmpty) {
            final firstDrink = compatible.first;
            final alternativeTexts = firstDrink.alternatives.entries
                .map((e) => '${e.key} → ${e.value}')
                .join(', ');
            message +=
                '\n\nℹ️ **${firstDrink.title}** için alternatifler: $alternativeTexts';
          }

          return _msg(message, drinkId: drinkId);
        } else {
          String noOptionMessage;
          switch (allergen) {
            case 'kafein':
              noOptionMessage =
                  '😅 Üzgünüm, şu anda kafeinsiz seçenek sınırlı. Başka bir tercih yapmak ister misin?';
              break;
            case 'şeker':
              noOptionMessage =
                  '😅 Şekersiz seçenekler kısıtlı ama başka bir içecek önerebilirim!';
              break;
            case 'vegan':
              noOptionMessage =
                  '😅 Tamamen vegan seçenekler şu anda sınırlı. Başka bir kategori ister misin?';
              break;
            default:
              noOptionMessage =
                  '😅 Maalesef, bu kriter için uygun içecek bulamadım. Başka bir tercih yapmak ister misin?';
          }
          return _msg(noOptionMessage);
        }
      }
    }
    return null;
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
