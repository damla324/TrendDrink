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
        text: 'Merhaba! Ben İçecek AI 🍵\n\n'
            'Elindeki malzemeleri yaz (örn: "limon, muz, yoğurt") veya sohbet eder gibi söyle (örn: "Elimde muz ve süt var, bunlarla ne yapabilirim?"). '
            'Veya bir kategori sor (kahve, çay, smoothie, fit, kokteyl vs) ya da ruh haline göre öneri iste. '
            'Hangi ürüne hassasiyetin varsa onu da söyle, ona göre alternatifler sunayım! 💚',
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
        'Oh, [${titleMatch.title}](${titleMatch.id}) mi istiyorsun? 😋 Süper bir tercih! '
        'Tarifi hemen paylaşayım; malzemeler, adımlar ve püf noktaları aşağıdaki düğmede seni bekliyor. '
        'Bu tarife bakıp sonra bana "benzer ama daha hafif" veya "şekersiz" gibi bir istek daha yazabilirsin. 👇',
        drinkId: titleMatch.id,
      );
    }

    // ── 2. Ingredient matching ──────────────────────────────────────────
    final ingredientTokens = _extractIngredientTokens(lower);
    final byIngredient = _findByIngredients(drinks, ingredientTokens);
    if (byIngredient.isNotEmpty) {
      final suggestions = byIngredient.take(3).toList();
      final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
      final mainId = suggestions.first.id;
      return _msg(
        'Elindeki malzemelere en uygun içecekleri buldum! ✨\n\n'
        'Sana en uygun üç seçenek: $names.\n\n'
        'Aşağıdaki düğmeye tıklayarak seçtiğim tarifin detaylı tarifine ulaşabilirsin. '
        'Şimdi bana da söyle: bu tariflerden hangisini daha çok denemek istersin ya da hangi malzemeyi kesinlikle kullanmak istersin? 🍹',
        drinkId: mainId,
      );
    }

    final looksLikeIngredientQuery = _isIngredientIntent(lower, ingredientTokens);
    if (looksLikeIngredientQuery) {
      if (ingredientTokens.isEmpty) {
        return _msg(
          'Sohbetinden anladığım kadarıyla elindeki malzemelerle ne yapabileceğini merak ediyorsun. '
          'Bana sadece malzemelerini yaz: örn. "Elimde muz, süt ve bal var" veya "Evde çilek ve yoğurt var, bunlarla ne yapabilirim?"',
        );
      }
      final tokensStr = ingredientTokens.join(', ');
      return _msg(
        'Aradığın malzeme kombinasyonunda (**$tokensStr**) tam olarak uyan içecek bulamadım. '
        'Dilersen malzemeleri biraz daha sadeleştir veya sadece ana malzemeleri söyle. \n'
        'Örneğin: "Elimde muz ve süt var" ya da "Evde sadece çilek var".\n'
        'Ayrıca bir malzemeden kaçınmak istersen, onu da yazabilirsin (örn: "süt istemiyorum").',
      );
    }

    // ── 3. Category keyword ─────────────────────────────────────────────
    final categoryMatch = _findByCategory(drinks, lower);
    if (categoryMatch.isNotEmpty) {
      final suggestions = categoryMatch.take(3).toList();
      final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
      return _msg(
        'Bu kategori tam senlik! 🎯 Sana uygun üç tane lezzet seçtim: $names.\n\n'
        'Bu tariflerin her biri için detaylı tarif bağlantısı aşağıdaki butonda. '
        'Hangisini görmek istersin ve bu tarifte hangi malzemeyi öne çıkarmak istersin? 😊',
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
        final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
        return _msg(
          'Sıcak bir şey çekiyor olabilirsin; bunun için bazı özel tarifler seçtim. ☕\n\n'
          '$names\n\n'
          'Aşağıdaki butona basınca seçtiğim tarife hemen ulaşacaksın. '
          'Sonra bana hangi hisle içmek istediğini de söyle, daha kişisel öneriler vereyim! 😊',
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
        final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
        return _msg(
          'Soğuk bir ferahlık mı istersin? Hemen sana uygun seçenekler hazırladım. 🧊\n\n'
          '$names\n\n'
          'Birini seçmek için aşağıdaki butonu kullan, tarifin tam detaylarını sana açayım. '
          'Sonra istersen buz oranını da beraber ayarlarız! 😄',
          drinkId: suggestions.first.id,
        );
      }
    }

    // ── 6. Fallback ─────────────────────────────────────────────────────
    final random = DateTime.now().millisecond % 3;
    final selectedDrinks = drinks..shuffle();
    final topDrinks = selectedDrinks.take(3).toList();
    final topNames = topDrinks.map((d) => '[${d.title}](${d.id})').join(', ');

    final fallbackMessages = [
      'Hmm, tam anlayamadım ama yardımcı olmak istiyorum! 😊\n\n'
          '$topNames gibi lezzetler seni çekebilir. Aşağıdan birini seç ve tarifi görelim!\n\n'
          'Sonra bana daha spesifik söyle (malzeme, kalori, tat profili) ki doğru tarifi bulabilirim! 💡',
      'Bekle, ben seninçin şu üç tarif buldum: $topNames. 🎯\n\n'
          'Bunlardan hangisi senin kulağına hoş geldi? Hangisini denemek isterdin?\n\n'
          'Detaylarını görmek için aşağı bastığında, bana da "tatlı seviyorum" veya "sağlıklı arıyorum" gibi daha kesin çıklama yaparsan, seni öğrenerim! 📝',
      'Vay canına, bu soru çok güzel! Çıldırttın beni 😄\n\n'
          'Sana şu tarif önerileri yapıyorum: $topNames\n\n'
          'İstersen bak, beğendim mi yaz. Hatta "elma var", "vegan istiyorum" veya "5 dakikada yapabilecek şey" gibi başka ipuçları verirsen, daha yapı iyi eşleşme bulabilirim! 🎨',
    ];

    return _msg(fallbackMessages[random]);
  }

  ChatMessage? _matchSensitivity(List<DrinkModel> drinks, String lower) {
    // ── Sensitivity/allergen keywords ──────────────────────────────────
    const sensitivityMap = {
      'kafeinsiz': 'kafein',
      'cafeinsiz': 'kafein',
      'decaf': 'kafein',
      'kafein istemiyorum': 'kafein',
      'şekersiz': 'şeker',
      'şeker istemiyorum': 'şeker',
      'şeker yok': 'şeker',
      'diyabet': 'şeker',
      'sugarfree': 'şeker',
      'sugar free': 'şeker',
      'sütsüz': 'süt',
      'sut istemiyorum': 'süt',
      'süt istemiyorum': 'süt',
      'laktozsuz': 'süt',
      'dairy free': 'süt',
      'vegan': 'vegan',
      'vejetaryen': 'vegan',
      'glutensiz': 'gluten',
      'gluten free': 'gluten',
      'glutenfree': 'gluten',
      'alerjim var': 'alerji',
      'alerji': 'alerji',
      'alerjik': 'alerji',
      'allergen': 'alerji',
      'çikolatadan': 'çikolata',
      'çikolata istemiyorum': 'çikolata',
      'fındık istemiyorum': 'fındık',
      'findik istemiyorum': 'fındık',
      'badem istemiyorum': 'kaju',
      'fındık': 'fındık',
      'findik': 'fındık',
      'almond': 'kaju',
      'kaju': 'kaju',
    };

    String? allergen;
    for (final entry in sensitivityMap.entries) {
      if (lower.contains(entry.key)) {
        allergen = entry.value;
        break;
      }
    }

    allergen ??= _inferAllergenFromQuery(lower);
    final needsAlternative = lower.contains('yerine') || lower.contains('alternatif');
    if (allergen == null && !needsAlternative) return null;

    // Eğer alerjen tespit edildiyse, ya içinde o madde olmayanları 
    // ya da o maddeye özel alternatifi olan içecekleri buluyoruz.
    final compatible = drinks.where((d) {
      if (allergen == null) return false;
      final isSafe = !d.allergens.contains(allergen);
      final hasReplacement = d.alternatives.containsKey(allergen);
      return isSafe || hasReplacement;
    }).toList();

        if (compatible.isNotEmpty) {
          // Alternatifi olanları en başa getiriyoruz
          final sorted = compatible.toList()..sort((a, b) {
            final aHasAlt = a.alternatives.containsKey(allergen) ? 0 : 1;
            final bHasAlt = b.alternatives.containsKey(allergen) ? 0 : 1;
            return aHasAlt.compareTo(bHasAlt);
          });

          final suggestions = sorted.take(3).toList();
          final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
          final drinkId = suggestions.first.id;
          final firstDrink = suggestions.first;
          final hasSpecificAlt = firstDrink.alternatives.containsKey(allergen);

          String message;
          String emoji;

          switch (allergen) {
            case 'kafein':
              emoji = '✨';
              message =
                  '$emoji Kafeinsiz mi istiyorsun? Rahatlığını düşündüğün için çok hoşuma gitti! '
                  'İşte tam sana göre seçenekler:\n\n$names\n\n';
              if (hasSpecificAlt) {
                message += '💡 **${firstDrink.title}** hazırlarken kahve yerine **${firstDrink.alternatives[allergen]}** kullanmanı öneririm. Tadı harika oluyor! ☕🚫';
              } else {
                message += 'Birine tıkla, tadını çıkar! ✨';
              }
              break;
            case 'şeker':
              emoji = '🍯';
              message =
                  '$emoji Şeker hassasiyetini anlıyorum, çok bilinçli bir yaklaşım! 💪\n\n$names\n\n';
              if (hasSpecificAlt) {
                message += '💡 **${firstDrink.title}** tarifinde şeker yerine **${firstDrink.alternatives[allergen]}** kullanarak aynı lezzeti yakalayabilirsin! 🎉';
              } else {
                message += 'Bunlardan biri hoşuna gitti mi? Şekersiz de çok lezzetli tariflerim var. 😊';
              }
              break;
            case 'süt':
              emoji = '🥛';
              message =
                  '$emoji Süt hassasiyetin mi var? Hiç sorun değil! İşte seçtiğim içecekler:\n\n$names\n\n';
              if (hasSpecificAlt) {
                message += '💡 **${firstDrink.title}** hazırlarken inek sütü yerine **${firstDrink.alternatives[allergen]}** kullanırsan sindirimi çok daha rahat olacaktır! 😋';
              } else {
                message += 'Bu tarifler vegan dostudur ve seni çok iyi hissettirecek! 🌿';
              }
              break;
            case 'vegan':
              emoji = '🌱';
              message =
                  '$emoji Veganlık çok gurur verici! 🌍 İşte tamamen vegan içecekler:\n\n$names\n\n'
                  'Hepsi 100% animal-free, birine tıkla! 💚';
              break;
            case 'gluten':
              emoji = '🌾';
              message =
                  '$emoji Glutenden uzak mı durmak istiyorsun? Tamam, anladım! ✅\n\n$names\n\n'
                  'Hepsi güvenli, rahatça içebilirsin! 😊';
              break;
            case 'alerji':
              emoji = '⚠️';
              message =
                  '$emoji Aman diye! Yaygın alerjenlerden uzak, güvenli seçenekler:\n\n$names\n\n'
                  'Rahatlıkla deneyebilirsin! 💚';
              break;
            case 'çikolata':
              emoji = '🍫';
              message =
                  '$emoji Çikolatadan kaçıyorsun, tamam! Başka tatların da çok güzel olur:\n\n$names\n\n'
                  'Hangisine kafa attın? 😄';
              break;
            case 'fındık':
              emoji = '🥜';
              message =
                  '$emoji Fındık/Yemiş alerjisi önemli bir konu, hemen önlemimi aldım! ⚠️\n\n$names\n\n';
              if (hasSpecificAlt) {
                message += '💡 **${firstDrink.title}** yaparken fındık yerine **${firstDrink.alternatives[allergen]}** kullanarak güvenle bu lezzetin tadına bakabilirsin. 😊';
              } else {
                message += 'Bu tarifler senin için tamamen güvenli ve yemiş içermiyor! 💪';
              }
              break;
            default:
              emoji = '✨';
              message =
                  '$emoji **$allergen** hassasiyetin için en uygun tarifleri seçtim:\n\n$names\n\n';
              if (hasSpecificAlt) {
                message += '💡 **${firstDrink.title}** içindeki $allergen yerine **${firstDrink.alternatives[allergen]}** kullanmanı tavsiye ederim.';
              }
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

  String? _inferAllergenFromQuery(String lower) {
    const negativeTerms = [
      'hassasiyet',
      'hassasiyetim',
      'alerji',
      'alerjim',
      'alerjisi',
      'istemiyorum',
      'istemem',
      'istemiyor',
      'kaçın',
      'kacın',
      'uzak',
      'yok',
      'sorun',
      'rahatsiz',
      'tolerans',
      'tüketmem',
      'tehlike',
      'zarar',
    ];

    if (!negativeTerms.any(lower.contains)) return null;

    const allergenKeywords = {
      'kafein': 'kafein',
      'kafeinsiz': 'kafein',
      'cafeinsiz': 'kafein',
      'decaf': 'kafein',
      'şeker': 'şeker',
      'sugar': 'şeker',
      'şekerli': 'şeker',
      'süt': 'süt',
      'sut': 'süt',
      'laktoz': 'süt',
      'vegan': 'vegan',
      'vejetaryen': 'vegan',
      'gluten': 'gluten',
      'çikolata': 'çikolata',
      'çikolatadan': 'çikolata',
      'fındık': 'fındık',
      'findik': 'fındık',
      'badem': 'kaju',
      'kaju': 'kaju',
      'almond': 'kaju',
    };

    for (final entry in allergenKeywords.entries) {
      if (lower.contains(entry.key)) return entry.value;
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

  List<String> _tokenize(String s) {
    final tokens = s
        .split(RegExp(r'[,;\s/&+]+'))
        .map((t) => t.trim())
        .where((t) => t.length > 1)
        .toList();

    const stopwords = {
      'var',
      'yok',
      'ama',
      'ancak',
      'fakat',
      'veya',
      've',
      'ile',
      'icin',
      'için',
      'ne',
      'neyi',
      'neleri',
      'hangi',
      'nasıl',
      'nasil',
      'bana',
      'bunu',
      'bu',
      'şu',
      'benim',
      'bende',
      'elimde',
      'evde',
      'bunlarla',
      'bunla',
      'varsa',
      'yapabilirim',
      'yaparım',
      'yapayım',
      'tavsiye',
      'öner',
      'oner',
      'isterim',
      'istiyorum',
      'lütfen',
      'mı',
      'mi',
      'mu',
      'mü',
      'da',
      'de',
      'daha',
      'sonra',
    };
    return tokens.where((t) => !stopwords.contains(t.toLowerCase())).toList();
  }

  String _cleanIngredientQuery(String lower) {
    var cleaned = lower.replaceAll(RegExp(r'[?!.]'), ' ');
    const removePatterns = [
      r'\belimde\b',
      r'\bevde\b',
      r'\bbende\b',
      r'\bbenim\b',
      r'\bbunlarla\b',
      r'\bbunla\b',
      r'\bbununla\b',
      r'\bvarsa\b',
      r'\bvar\b',
      r'\byok\b',
      r'\bama\b',
      r'\bveya\b',
      r'\bve\b',
      r'\bile\b',
      r'\bicin\b',
      r'\biçin\b',
      r'\bne\b',
      r'\bneyi\b',
      r'\bneleri\b',
      r'\bhangi\b',
      r'\bnasıl\b',
      r'\bnasil\b',
      r'\byapabilirim\b',
      r'\byaparim\b',
      r'\byapayim\b',
      r'\btavsiye\b',
      r'\böner\b',
      r'\boner\b',
      r'\bisterim\b',
      r'\bistiyorum\b',
      r'\bbana\b',
      r'\bplease\b',
      r'\bmi\b',
      r'\bmu\b',
      r'\bmü\b',
      r'\bda\b',
      r'\bde\b',
      r'\bdaha\b',
      r'\bsonra\b',
      r'\bbu\b',
      r'\bşu\b',
    ];
    for (final pattern in removePatterns) {
      cleaned = cleaned.replaceAll(RegExp(pattern), ' ');
    }
    return cleaned;
  }

  List<String> _extractIngredientTokens(String lower) {
    final cleaned = _cleanIngredientQuery(lower);
    return _tokenize(cleaned);
  }

  bool _isIngredientIntent(String lower, List<String> tokens) {
    const ingredientIntentTriggers = [
      'elimde',
      'evde',
      'bende',
      'bunlarla',
      'bununla',
      'varsa',
      'var',
      'ne yapabilirim',
      'ne yapayim',
      'ne önerirsin',
      'hangi tarif',
      'hangi icecek',
      'hangi içecek',
      'ne içsem',
      'ne yapabilirim',
      'tavsiye',
      'öner',
      'isterim',
      'istiyorum',
    ];
    final triggerFound = ingredientIntentTriggers.any(lower.contains);
    return triggerFound || tokens.length >= 2;
  }

  DrinkModel? _findByTitle(List<DrinkModel> drinks, String lower) {
    final words = lower.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    for (final d in drinks) {
      final normalized = _normalize(d.title);
      if (lower.contains(normalized) || normalized.contains(lower)) return d;

      // Only use word-level title matching for short single-word queries.
      if (words.length == 1) {
        final word = words.first;
        if (word.length >= 3 && normalized.contains(word)) return d;
      }
    }
    return null;
  }

  List<DrinkModel> _findByIngredients(
      List<DrinkModel> drinks, List<String> tokens) {
    final normalizedTokens =
        tokens.map(_normalize).where((token) => token.isNotEmpty).toList();

    if (normalizedTokens.isEmpty) return [];

    final exactMatches = <_IngredientMatch>[];

    for (final drink in drinks) {
      final drinkIngredientsNormalized = drink.ingredients
          .map((ing) => _normalize(ing).toLowerCase())
          .toList();

      int matchedCount = 0;
      for (final token in normalizedTokens) {
        final normalized = token.toLowerCase();
        if (drinkIngredientsNormalized.any((ing) => ing.contains(normalized) || ing == normalized)) {
          matchedCount++;
        }
      }

      if (matchedCount == normalizedTokens.length) {
        final extraIngredientCount = drinkIngredientsNormalized.length - matchedCount;
        final score = matchedCount * 100 - extraIngredientCount * 5;
        exactMatches.add(_IngredientMatch(drink, matchedCount, score));
      }
    }

    if (exactMatches.isNotEmpty) {
      exactMatches.sort((a, b) {
        if (b.score != a.score) return b.score.compareTo(a.score);
        if (b.matchCount != a.matchCount) return b.matchCount.compareTo(a.matchCount);
        return a.drink.title.compareTo(b.drink.title);
      });
      return exactMatches.map((match) => match.drink).toList();
    }

    return [];
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
          '💪 Enerji lazım, biliyorum! Kahve veya matcha combo seni ayağa kaldırır!\n\n${e.map((d) => '[${d.title}](${d.id})').join(", ")}\n\n'
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
          '💪 Sağlıkla ilgileniyorsun, çok hoş! Benim burada harika seçenekler var:\n\n${f.map((d) => '[${d.title}](${d.id})').join(", ")}\n\n'
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
          '🎉 Eğlenceye mi kalkıyorsun? Mükemmel! İşte akşam favoritileri:\n\n${p.map((d) => '[${d.title}](${d.id})').join(", ")}\n\n'
          'Hangisiyle başlamak ister misin? Tıkla, tarifi görmek için! 🍹',
          drinkId: p.first.id,
        );
      }
    }
    if (lower.contains('klasik') ||
        lower.contains('favorim') ||
        lower.contains('sevdiğim') ||
        lower.contains('sevdigim')) {
      final classics = drinks.take(4).toList();
      if (classics.isNotEmpty) {
        return _msg(
          '😊 Klasik seçenekler mi istiyorsun? Çok iyi! İşte en populer içecekler:\n\n${classics.map((d) => '[${d.title}](${d.id})').join(", ")}\n\n'
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

class _IngredientMatch {
  _IngredientMatch(this.drink, this.matchCount, this.score);

  final DrinkModel drink;
  final int matchCount;
  final int score;
}
