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
            'Merhaba! Ben İçecek AI 🍵\n\nElindeki malzemeleri yaz, fotoğraf yükle (✨ Pro özelliği) ya da sohbet eder gibi anlat. '
            'Örneğin: "Elimde muz ve süt var" veya bir buzdolabı fotoğrafı paylaş — sana uygun tarifi seçeyim.',
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
            '📷 Fotoğrafını ve yazdığın malzemeleri inceledim. Senin için en iyi tarifler: $names\n\n'
            'Aşağıdaki butondan detayına geç. İstersen "şekersiz" veya "sıcak" gibi ek bir filtre de yazabilirsin.',
            drinkId: top.first.id,
          );
        }
      }
      return _msg(
        '📷 Fotoğrafını aldım. Görseldeki malzemeleri kısaca yazabilir misin? '
        'Örneğin: "Muz, süt, yulaf, bal var". Böylece sana en doğru tarifi seçeyim. ✨\n\n'
        '_İpucu: AI Vision tam entegrasyonu için Pro üyeliğinde Gemini görsel analiz yakında aktif!_',
      );
    }

    // 1) Sosyal
    final social = _handleSocial(lower);
    if (social != null) return social;

    // 2) Başlık eşleşmesi
    final title = _findByTitle(drinks, lower);
    if (title != null) {
      return _msg(
        '[${title.title}](${title.id}) harika tercih! 😋 Tam detaylar aşağıdaki butonda.',
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
        'Bu malzemelerle yapabileceğin en iyi 3 tarif: $names ✨\n\nAşağıdaki butona tıkla, ilkinin detayını açayım.',
        drinkId: top.first.id,
      );
    }

    // 4) Kategori
    final byCat = _findByCategory(drinks, lower);
    if (byCat.isNotEmpty) {
      final top = byCat.take(3).toList();
      final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
      return _msg(
        'Bu kategoride seni mest edecek 3 tarif seçtim: $names 🎯',
        drinkId: top.first.id,
      );
    }

    // 5) Fallback
    final shuffled = [...drinks]..shuffle();
    final top = shuffled.take(3).toList();
    final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
    return _msg(
      'Tam yakalayamadım ama belki şunlardan biri ilgini çeker: $names 🌟\n\nDaha kesin bir cevap istersen "malzeme: muz, süt" gibi yazabilirsin.',
      drinkId: top.first.id,
    );
  }

  ChatMessage? _handleSocial(String lower) {
    if (lower.contains('merhaba') || lower.contains('selam')) {
      return _msg('Merhaba! Bugün hangi lezzeti hazırlayalım? 🍹');
    }
    if (lower.contains('teşekkür') || lower.contains('sagol')) {
      return _msg('Rica ederim! Afiyet olsun. ☕');
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
