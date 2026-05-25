import 'dart:typed_data';

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
            'Merhaba! 👋 Ben İçecek AI, TrendDrink\'in arkadaş gibi asistanı.\n\n'
            'Ben sadece içecek önerisi yapmıyorum, seninle sohbet etmeyi de severim! 😊\n\n'
            'Örneğin:\n'
            '• "Merhaba! Nasılsın?" gibi yazabilirsin\n'
            '• "Elimde muz ve süt var" diyebilirsin\n'
            '• "Bugün nasıl geçti?" sorabilirsin\n'
            '• Fotoğraf yükleyebilirsin (✨ Pro özelliği)\n\n'
            'Nelerin hakkında konuşmak istersin? 🍹',
        author: ChatAuthor.assistant,
      ),
    ];
  }

  Future<void> sendMessage(String text,
      {Uint8List? imageBytes, String? imageName}) async {
    final message = text.trim();
    if (message.isEmpty && imageBytes == null) return;

    state = [
      ...state,
      ChatMessage(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        text: message.isEmpty ? '(Fotoğraf gönderildi)' : message,
        author: ChatAuthor.user,
        imageBytes: imageBytes,
        imageName: imageName,
      ),
    ];

    await Future<void>.delayed(const Duration(milliseconds: 600));
    final response =
        await _buildResponse(message, hasImage: imageBytes != null);
    state = [...state, response];
  }

  Future<ChatMessage> _buildResponse(String query,
      {bool hasImage = false}) async {
    final drinks = await _repository.fetchAllDrinks();
    final lower = _normalize(query);

    // Görsel destekli akış (multimodal placeholder + pratik öneri).
    if (hasImage) {
      final tokens = _extractIngredientTokens(lower);
      if (tokens.isNotEmpty) {
        final byIng = _findByIngredients(drinks, tokens);
        if (byIng.isNotEmpty) {
          final top = byIng.take(3).toList();
          final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
          return _msg(
            '📷 Vay! Güzel bir fotoğraf paylaştın! Yazdığın malzemelerle birlikte inceledim. '
            'Sana en uygun tarifler: $names\n\n'
            'Aşağıdaki butondan detayını görebilirsin. İstersen "şekersiz" veya "sıcak" gibi filtreler de kullanabilirsin.',
            drinkId: top.first.id,
          );
        }
      }
      return _msg(
        '📷 Güzel bir fotoğraf yüklemedin! 😊 Fotoğrafdaki malzemeleri kısaca yazabilir misin? '
        'Örneğin: "Muz, süt, yulaf, bal var". Böylece sana en doğru tarifi bulabilirim.\n\n'
        '_Tam olarak AI Vision entegrasyonu için Pro üyeliğinde Gemini görsel analiz yakında aktif olacak!_',
      );
    }

    // 1) Sosyal
    final social = _handleSocial(lower);
    if (social != null) return social;

    // 2) Başlık eşleşmesi
    final title = _findByTitle(drinks, lower);
    if (title != null) {
      return _msg(
        'Ah, [${title.title}](${title.id})! Çok güzel bir seçim! 😋 '
        'Tam olarak bunu önerirdim sana. Detaylı tarifi aşağıdaki butondan görebilirsin.',
        drinkId: title.id,
      );
    }

    // 3) Malzeme
    final tokens = _extractIngredientTokens(lower);
    final byIng = _findByIngredients(drinks, tokens);
    if (byIng.isNotEmpty) {
      final top = byIng.take(3).toList();
      final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
      return _msg(
        'Vay be! Şu malzemeleri kullanarak çok güzel şeyler yapabiliriz! 😊\n\n'
        'Sana en uygun 3 tarif: $names\n\n'
        'Aşağıdaki butondan ilkinin detayını açabilirsin. Hangisi daha çekici geliyor?',
        drinkId: top.first.id,
      );
    }

    // 4) Kategori
    final byCat = _findByCategory(drinks, lower);
    if (byCat.isNotEmpty) {
      final top = byCat.take(3).toList();
      final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
      return _msg(
        'Ah, bu kategorini seviyor musun? 😋 Ben de! '
        'Sana en beğeneceğim 3 seçenek: $names\n\n'
        'Aşağıdaki butonlardan ilkinin detayını açabilirsin. Hangisi ilgini çekti?',
        drinkId: top.first.id,
      );
    }

    // 5) Fallback - Daha samimi yanıt
    final shuffled = [...drinks]..shuffle();
    final top = shuffled.take(3).toList();
    final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
    return _msg(
      'Hmmm, tamamen yakalayamadım ama bana inan, bu 3 tarifin herhangi biri seni hayal kırıklığına uğratmaz! 🌟\n\n$names\n\n'
      'Daha kesin yanıt almak istersen "malzeme: muz, süt" ya da "kategorisi: kahve" gibi yazabilirsin. '
      'Anlaşıldı mı? 😊',
      drinkId: top.first.id,
    );
  }

  ChatMessage? _handleSocial(String lower) {
    // Selamlamalar - samimi yanıtlar
    if (lower.contains('merhaba') || lower.contains('selam') || lower.contains('merhba')) {
      return _msg(
        'Merhaba! 👋 Çok iyi ki yazıyorsun. Bugün nasıl geçiyor sana? '
        'Hangi tür bir içecek ile sana keyif verebilirim? 🍹',
      );
    }

    // Sağlık/Durum sorguları
    if (lower.contains('nasils') || lower.contains('iyi misin') || 
        lower.contains('naber') || lower.contains('iyimisin') ||
        lower.contains('nasilsin')) {
      return _msg(
        'Çok iyiyim teşekkür edersin! 😊 Seninle konuşmak her zaman güzel. '
        'Peki sen nasılsın? Bugün sana ne gibi bir içecek hoş gelir? '
        'Serinletici mi, yoksa sıcak mı tercih edersin?',
      );
    }

    // Teşekkür
    if (lower.contains('tesekkur') || lower.contains('sagol') || lower.contains('thanks')) {
      return _msg(
        'Rica ederim! 😊 Afiyet olsun. Başka bir şey istersen lütfen söyle. ☕',
      );
    }

    // Nasıl gitti (içecek deneme sonrası)
    if (lower.contains('guzel') || lower.contains('lezzetli') || 
        lower.contains('afiyetolsun') || lower.contains('hosgeldi')) {
      return _msg(
        'Vay be! Çok sevindim! 🎉 Umarım gerçekten damak tadına hitap etmiştir. '
        'Eğer başka bir şey denemek istersen, ben buradayım! '
        'Ne gibi bir lezzet daha denemek istersin?',
      );
    }

    // Genel sohbet
    if (lower.contains('ben') || lower.contains('ben de') || lower.contains('ben biraz')) {
      return _msg(
        'Anlıyorum! Anlatır mısın biraz daha? Ben gerçekten merak ediyorum. '
        'Belki seninle uygun bir içecek kombinasyonu bulabilirim. 😊',
      );
    }

    return null;
  }

  ChatMessage _msg(String text, {String? drinkId}) => ChatMessage(
        id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        author: ChatAuthor.assistant,
        drinkId: drinkId,
      );

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u');

  DrinkModel? _findByTitle(List<DrinkModel> drinks, String lower) {
    for (final d in drinks) {
      if (_normalize(d.title).contains(lower) && lower.length > 2) {
        return d;
      }
    }
    return null;
  }

  List<String> _extractIngredientTokens(String lower) {
    const keywords = [
      'muz',
      'sut',
      'yogurt',
      'bal',
      'elma',
      'cilek',
      'limon',
      'portakal',
      'yulaf',
      'kakao',
      'kahve',
      'sucuk',
      'vanilya',
      'tarcin',
      'zencefil',
      'nane',
      'seker',
      'su',
      'buz',
      'cay',
      'matcha',
      'karpuz',
      'muhrek',
      'badem',
      'findik'
    ];
    return keywords.where((k) => lower.contains(k)).toList();
  }

  List<DrinkModel> _findByIngredients(
      List<DrinkModel> drinks, List<String> tokens) {
    if (tokens.isEmpty) return [];
    final scored = <(DrinkModel, int)>[];
    for (final d in drinks) {
      var score = 0;
      final ingNormalized = d.ingredients.map((i) => _normalize(i)).join(' ');
      for (final t in tokens) {
        if (ingNormalized.contains(t)) score++;
      }
      if (score > 0) scored.add((d, score));
    }
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }

  List<DrinkModel> _findByCategory(List<DrinkModel> drinks, String lower) {
    const map = {
      'kahve': 'Kahve',
      'matcha': 'Matcha',
      'kokteyl': 'Kokteyl',
      'frozen': 'Frozen',
      'smoothie': 'Smoothie',
      'cay': 'Çay',
      'soda': 'Soda',
      'fit': 'Fit',
    };
    for (final entry in map.entries) {
      if (lower.contains(entry.key)) {
        return drinks.where((d) => d.category == entry.value).toList();
      }
    }
    return [];
  }
}
