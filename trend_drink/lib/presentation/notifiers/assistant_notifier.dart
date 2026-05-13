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
        'Oh, **${titleMatch.title}** mi istiyorsun! 😋 Çok güzel bir seçim! '
        'Detayını görmek için bağlantıya tıkla, tarif ve püf noktaları seni bekliyor! 👇',
        drinkId: titleMatch.id,
      );
    }

    // ── 2. Ingredient matching ──────────────────────────────────────────
    final tokens = _tokenize(lower);
    final byIngredient = _findByIngredients(drinks, tokens);
    if (byIngredient.isNotEmpty) {
      final suggestions = byIngredient.take(3).toList();
      final names = suggestions.map((d) => d.title).join(', ');
      final mainId = suggestions.first.id;
      return _msg(
        'Elindeki malzemelerle bu leziz içecekleri yapabilirsin! ✨\n\n**$names**\n\n'
        'Detaylarını görmek için herhangi birine tıkla, hepsi eşi benzeri yok! 🍹',
        drinkId: mainId,
      );
    }

    // ── 3. Category keyword ─────────────────────────────────────────────
    final categoryMatch = _findByCategory(drinks, lower);
    if (categoryMatch.isNotEmpty) {
      final suggestions = categoryMatch.take(3).toList();
      final names = suggestions.map((d) => d.title).join(', ');
      return _msg(
        'Bu kategoride bende harika seçenekler var! 🎯\n\n**$names**\n\n'
        'Hangisin hoşuna gitti? Tıkla, detayını keşfet! 😊',
        drinkId: suggestions.first.id,
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
        final suggestions = hot.take(3).toList();
        final names = suggestions.map((d) => d.title).join(', ');
        return _msg(
          'Sıcak bir şey mi istiyorsun? Buraya bak! ☕\n\n**$names**\n\n'
          'Hangisinin tadını merak ediyorsun?',
          drinkId: suggestions.first.id,
        );
      }
    }
    if (lower.contains('soğuk') ||
        lower.contains('soguk') ||
        lower.contains('buzlu')) {
      final cold = drinks.where((d) => d.temperature == 'Soğuk').toList();
      if (cold.isNotEmpty) {
        final suggestions = cold.take(3).toList();
        final names = suggestions.map((d) => d.title).join(', ');
        return _msg(
          'Soğuk bir serinlik mi lazım? Tam zamanında! 🧊\n\n**$names**\n\n'
          'Biri hoşuna gitti mi? Detayını görmek için tıkla!',
          drinkId: suggestions.first.id,
        );
      }
    }

    // ── 6. Fallback ─────────────────────────────────────────────────────
    final topDrinks = drinks.take(3).toList();
    final topNames = topDrinks.map((d) => d.title).join(', ');
    return _msg(
      'Hmm, tam anlayamadım ama yapacağım! 😄 Şimdi çok popüler olan içecekler:\n\n**$topNames**\n\n'
      'Eğer bir malzeme, kategori (kahve, çay, smoothie vs) ya da ruh halin hakkında yazarsan, '
      'sana daha doğru şeyler önerebilirim! 💪',
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
          final suggestions = compatible.take(3).toList();
          final names = suggestions.map((d) => d.title).join(', ');
          final drinkId = suggestions.first.id;

          String message;
          String emoji;
          
          switch (allergen) {
            case 'kafein':
              emoji = '✨';
              message =
                  '$emoji Kafeinsiz mi istiyorsun? Rahatlığını düşündüğün için çok hoşuma gitti! '
                  'İşte tam seçeceğin şeyler:\n\n**$names**\n\n'
                  'Birine tıkla, tadını çık! ☕🚫';
              break;
            case 'şeker':
              emoji = '🍯';
              message =
                  '$emoji Şeker kontrolü yapıyorsun, harika! 💪 Sana özel seçenekler:\n\n**$names**\n\n'
                  'Sağlıklı tercih ettiğin için tebrik ederim! 🎉';
              break;
            case 'süt':
              emoji = '🥛';
              message =
                  '$emoji Sütü istemiyorsun, anladım! Benim burada harika vegan dostu içecekler var:\n\n**$names**\n\n'
                  'Hepsi de leziz ve doyurucu! 😋';
              break;
            case 'vegan':
              emoji = '🌱';
              message =
                  '$emoji Veganlık çok gurur verici! 🌍 İşte tamamen vegan içecekler:\n\n**$names**\n\n'
                  'Hepsi 100% animal-free, birine tıkla! 💚';
              break;
            case 'gluten':
              emoji = '🌾';
              message =
                  '$emoji Glutenden uzak mı durmak istiyorsun? Tamam, anladım! ✅\n\n**$names**\n\n'
                  'Hepsi güvenli, rahatça içebilirsin! 😊';
              break;
            case 'alerji':
              emoji = '⚠️';
              message =
                  '$emoji Aman diye! Yaygın alerjenlerden uzak, güvenli seçenekler:\n\n**$names**\n\n'
                  'Rahatlıkla deneyebilirsin! 💚';
              break;
            case 'çikolata':
              emoji = '🍫';
              message =
                  '$emoji Çikolatadan kaçıyorsun, tamam! Başka tatların da çok güzel olur:\n\n**$names**\n\n'
                  'Hangisine kafa attın? 😄';
              break;
            case 'fındık':
              emoji = '🥜';
              message =
                  '$emoji Fındıktan uzak mı durmak istiyorsun? Sorun değil! '
                  'Başka muhteşem seçenekler:\n\n**$names**\n\n'
                  'Hepsi başka şekilde leziz! 😊';
              break;
            default:
              emoji = '✨';
              message =
                  '$emoji **$allergen** endişesi var mı? Benim burada güzel seçenekler var:\n\n**$names**\n\n'
                  'Birine tıkla, detaylarını gör!';
          }

          // ── Enhanced alternatives display ────────────────────────────
          if (suggestions.isNotEmpty && suggestions.first.alternatives.isNotEmpty) {
            final firstDrink = suggestions.first;
            final altList = firstDrink.alternatives.entries
                .map((e) => '  • ${e.key} → ${e.value}')
                .join('\n');
            message +=
                '\n\n💡 **${firstDrink.title}** için alternatifler:\n$altList';
          }

          return _msg(message, drinkId: drinkId);
        } else {
          String noOptionMessage;
          String emoji;
          
          switch (allergen) {
            case 'kafein':
              emoji = '😅';
              noOptionMessage =
                  '$emoji Üzgünüm, şu anda kafeinsiz seçenek çok sınırlı. '
                  'Ama merak etme, yakında daha çok eklerim! Başka bir tercih yapmak ister misin? 🍹';
              break;
            case 'şeker':
              emoji = '😅';
              noOptionMessage =
                  '$emoji Şekersiz seçenekler kısıtlı ama merak etme, başka leziz şeyler önerebilirim! '
                  'Başka bir kategori ister misin? ☕';
              break;
            case 'vegan':
              emoji = '😅';
              noOptionMessage =
                  '$emoji Tamamen vegan seçenekler şu anda sınırlı ama geliştiriliyorum! '
                  'Başka bir tercih yapmak ister misin? 🌱';
              break;
            default:
              emoji = '😅';
              noOptionMessage =
                  '$emoji Bu kriter için henüz uygun içecek bulamadım ama arayışımda devam! '
                  'Başka bir tercih yapmak ister misin? 💪';
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
          '💪 Enerji lazım, biliyorum! Kahve veya matcha combo seni ayağa kaldırır!\n\n**${e.map((d) => d.title).join(", ")}**\n\n'
          'Hangisi sana daha hoş gelir? Tıkla, yapılışını öğren! ⚡',
          drinkId: e.first.id,
        );
      }
    }
    if (lower.contains('diyet') ||
        lower.contains('fit') ||
        lower.contains('saglik') ||
        lower.contains('sağlık')) {
      final f = drinks
          .where((d) => d.category == 'Fit' || d.category == 'Smoothie')
          .take(3)
          .toList();
      if (f.isNotEmpty) {
        return _msg(
          '💪 Sağlıkla ilgileniyorsun, çok hoş! Benim burada harika seçenekler var:\n\n**${f.map((d) => d.title).join(", ")}**\n\n'
          'Hangisi seni heyecanlandırdı? Birine tıkla! 🌱',
          drinkId: f.first.id,
        );
      }
    }
    if (lower.contains('parti') ||
        lower.contains('eglence') ||
        lower.contains('eğlence') ||
        lower.contains('aksam') ||
        lower.contains('akşam')) {
      final p = drinks.where((d) => d.category == 'Kokteyl').take(3).toList();
      if (p.isNotEmpty) {
        return _msg(
          '🎉 Eğlenceye mi kalkıyorsun? Mükemmel! İşte akşam favoritileri:\n\n**${p.map((d) => d.title).join(", ")}**\n\n'
          'Hangisiyle başlamak ister misin? Tıkla, tarifi görmek için! 🍹',
          drinkId: p.first.id,
        );
      }
    }
    if (lower.contains('klasik') || lower.contains('favorim') || lower.contains('sevdiğim') || lower.contains('sevdigim')) {
      final classics = drinks.take(4).toList();
      if (classics.isNotEmpty) {
        return _msg(
          '😊 Klasik seçenekler mi istiyorsun? Çok iyi! İşte en populer içecekler:\n\n**${classics.map((d) => d.title).join(", ")}**\n\n'
          'Bunlardan hangisi seni en çok etkiledi? 🌟',
          drinkId: classics.first.id,
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
