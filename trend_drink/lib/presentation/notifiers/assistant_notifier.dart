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
  static const String _userFirstName = 'Damla';
  static const String _userLastName = 'Yalçın';
  static const String _ownerName = 'Damla Yalçın';

  late final DrinkRepository _repository;

  @override
  List<ChatMessage> build() {
    _repository = ref.read(drinkRepositoryProvider);
    return [
      ChatMessage(
        id: 'welcome',
        text:
            'Merhaba! 👋 Ben senin kişisel içecek yapay zekânım. Seni daha iyi tanıyabilmek için ismini öğrenebilir miyim? '
            'Ya da istersen doğrudan önerilere geçebiliriz.\n\n'
            'Mooduna göre sana özel seçenekler sunabilirim, elimdeki malzemelere en uygun içeceği bulabilirim ve istediğin tarifin adım adım tarifini verebilirim.\n\n'
            'Ne şekilde başlamak istersin? İstersen önce adını söyle, istersen malzemelerini paylaş, istersen de ruh halini anlat.',
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
    final preferences = _parsePreferences(lower);

    // 1) Duygu ve Durum Analizi (Giriş cümlesi için)
    final emotionalIntro = _generateEmotionalIntro(lower, preferences);

    // Görsel destekli akış (multimodal placeholder + pratik öneri).
    if (hasImage) {
      final tokens = _extractIngredientTokens(lower, preferences);
      if (tokens.isNotEmpty) {
        final byIng = _findByIngredients(drinks, tokens, preferences);
        if (byIng.isNotEmpty) {
          final top = byIng.take(3).toList();
          final names = top.map((d) => '[${d.title}](${d.id})').join(', ');

          String responseText = '';
          if (emotionalIntro != null) {
            responseText += '$emotionalIntro\n\n';
          }

          return _msg(
            '${responseText}📷 Vay! Güzel bir fotoğraf paylaştın! Yazdığın malzemelerle birlikte inceledim. '
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

    // 2) Saf Sosyal (Sadece selam verme vb.)
    final social = _handleSocial(lower, drinks);
    if (social != null && emotionalIntro == null) return social;

    // 3) Başlık eşleşmesi
    final title = _findByTitle(drinks, lower, preferences);
    if (title != null) {
      String responseText = '';
      if (emotionalIntro != null) {
        responseText += '$emotionalIntro\n\n';
      }
      
      return _msg(
        '${responseText}Kesinlikle katılıyorum, [${title.title}](${title.id}) harika bir seçim. 😋 '
        'Buna ben de kesinlikle onay veririm. Detayı aşağıdaki butondan hemen açabilirsin.',
        drinkId: title.id,
      );
    }

    // 3) Malzeme
    final tokens = _extractIngredientTokens(lower, preferences);
    final byIng = _findByIngredients(drinks, tokens, preferences);
    if (byIng.isNotEmpty) {
      final top = byIng.take(3).toList();
      final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
      
      String responseText = '';
      if (emotionalIntro != null) {
        responseText += '$emotionalIntro\n\n';
      }
      return _msg(
        '${responseText}Elindeki malzemeleri ve modunu düşündüğümde şu seçenekler seni çok memnun edecek: $names\n\n'
        'Bunlardan biri tam olarak aradığın lezzete yakın olabilir. İlkini açmak için aşağıya tıklayabilirsin.',
        drinkId: top.first.id,
      );
    }

    if (preferences.hasAny) {
      final prefOnly = _findByPreferences(drinks, preferences);
      if (prefOnly.isNotEmpty) {
        final top = prefOnly.take(3).toList();
        final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
        
        String responseText = '';
        if (emotionalIntro != null) {
          responseText += '$emotionalIntro\n\n';
        }
        return _msg(
          '${responseText}İstediğin o ${preferences.description()} tadı yakalamak için şu tarifleri seçtim: $names\n\n'
          'Bu içecekler, talebindeki sınırlamaları göz önünde bulundurarak seçildi.',
          drinkId: top.first.id,
        );
      }
    }

    // 4) Kategori
    final byCat = _findByCategory(drinks, lower, preferences);
    if (byCat.isNotEmpty) {
      final top = byCat.take(3).toList();
      final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
      
      String responseText = '';
      if (emotionalIntro != null) {
        responseText += '$emotionalIntro\n\n';
      }
      return _msg(
        '${responseText}Aradığın bu kategoride sana en çok hitap edecek 3 önerim var: $names\n\n'
        'Her biri kendi tarzında lezzetli. Hangi tarifi öncelikle inceleyelim?',
        drinkId: top.first.id,
      );
    }

    // 5) Fallback - Daha samimi yanıt
    if (preferences.hasAny) {
      final prefOnly = _findByPreferences(drinks, preferences);
      if (prefOnly.isNotEmpty) {
        final top = prefOnly.take(3).toList();
        final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
        return _msg(
          '${preferences.description()} isteğini dikkate aldım. Sana uygun olabilecek seçenekler: $names\n\n'
          'Bu tariflerde talep ettiğin sınırlamaları gözettim.',
          drinkId: top.first.id,
        );
      }
    }

    final shuffled = [...drinks]..shuffle();
    final top = shuffled.take(3).toList();
    final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
    
    if (emotionalIntro != null) {
      return _msg(
        '$emotionalIntro\n\nŞu an için aklıma gelen en iyi seçenekler şunlar: $names. '
        'Belki de bu tariflerden biri ruh halini değiştirmeye yardımcı olur.',
        drinkId: top.first.id,
      );
    }

    return _msg(
      'Tam olarak hangi içeceği istediğini anlamadım ama bu 3 tarif iyi bir başlangıç olabilir: $names\n\n'
      'Eğer daha net bir öneri istersen, bana malzemelerini söyle ya da bir kategori belirtebilirsin. 😊',
      drinkId: top.first.id,
    );
  }

  /// Kullanıcının duygusal durumunu analiz eder ve uygun bir giriş metni oluşturur.
  String? _generateEmotionalIntro(String lower, _DrinkPreferences prefs) {
    // Kötü gün, yorgunluk, mutsuzluk (Internet feedback tabanlı samimi yaklaşımlar)
    if (lower.contains('kotu bir gun') || lower.contains('mutsuzum') || 
        lower.contains('yorgun') || lower.contains('canim sikkin') || 
        lower.contains('moralim bozuk')) {
      
      if (prefs.isHard) {
        return 'Bugünün tüm yorgunluğunu ve negatif enerjisini üzerinden atacak sert bir kahvenin yerini hiçbir şey tutamaz, inan bana. 😌 '
               'Zihnini berraklaştıracak ve sana yeniden güç verecek o sade dokunuşu beraber hazırlayalım.';
      }
      if (prefs.preferredTemp == 'sicak') {
        return 'İnan bana, sıcak bir içecek sadece damak tadına değil, ruhuna da iyi gelecek. ☕ '
               'Günün tüm yorgunluğunu o ilk yudumla beraber arkanda bırakabilirsin.';
      }
      return 'Bazen her şey üst üste gelir ama doğru bir içecek modunu bir anda değiştirebilir. ✨ '
             'Sana biraz nefes aldıracak, içini ferahlatacak seçenekleri hemen hazırladım.';
    }

    // Mutluluk, enerji, kutlama
    if (lower.contains('mutlu') || lower.contains('enerjik') || 
        lower.contains('harika') || lower.contains('keyifli') || 
        lower.contains('sevincli')) {
      return 'Bu harika enerjin bana da bulaştı! 🎉 Mutluluğunu ikiye katlayacak, '
             'damaklarında festival havası yaratacak efsane önerilerim var.';
    }

    // Düşünceli, sakin, rahatlama
    if (lower.contains('dusunceli') || lower.contains('sakin') || 
        lower.contains('dinlenmek') || lower.contains('rahatlamak')) {
      return 'Şu an ihtiyacın olan şey tam bir huzur anı... 🧘‍♂️ '
             'Düşüncelerine eşlik edecek, seni dinginleştirecek en zarif tarifleri senin için seçtim.';
    }

    // Odaklanma, çalışma
    if (lower.contains('calisiy') || lower.contains('ders') || 
        lower.contains('odaklan')) {
      return 'Verimliliğini zirveye taşıma vakti! 🚀 Zihnini açacak, seni diri tutacak '
             've konsantrasyonunu artıracak o yakıtı şimdi bulacağız.';
    }

    return null;
  }

  ChatMessage? _handleSocial(String lower, List<DrinkModel> drinks) {
    // Selamlamalar - samimi ama doğal
    if (lower.contains('merhaba') || lower.contains('selam') || lower.contains('merhba')) {
      return _msg(
        'Merhaba! 👋 Seni görmek gerçekten güzel. Bugün nasıl hissediyorsun? '
        'Doğrudan bir içecek önerisi de isteyebilirsin.',
      );
    }

    // Sağlık / durum sorguları
    if (lower.contains('nasils') || lower.contains('iyi misin') || 
        lower.contains('naber') || lower.contains('iyimisin') ||
        lower.contains('nasilsin')) {
      return _msg(
        'İyiyim, teşekkür ederim. 😊 Sen nasılsın? Bugün hangi içecek seni daha iyi hissettirir, beraber bulalım.',
      );
    }

    // Duygu ifadeleri - moral ihtiyacı
    if (lower.contains('hiç halim yok') || lower.contains('halim yok') ||
        lower.contains('çok üzgünüm') || lower.contains('üzgünüm') ||
        lower.contains('mutsuzum') || lower.contains('moralsiz') ||
        lower.contains('bugün hiç')) {
      final suggestions = drinks.take(3).toList();
      final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
      return _msg(
        'Öyle mi... çok üzüldüm bunu duyduğuma. 😔 Sana moral verebilecek birkaç içecek biliyorum: $names\n\n'
        'Senin için özel olarak görmek istediğin bir içecek var mı? '
        'Umarım bu seçimler bugünündeki mutsuzluğu biraz olsun hafifletir.',
        drinkId: suggestions.first.id,
      );
    }

    // Teşekkür
    if (lower.contains('tesekkur') || lower.contains('sagol') || lower.contains('thanks')) {
      return _msg(
        'Ne demek, memnun oldum. ☕ Başka bir şey arıyorsan hemen söyle, birlikte deneyebiliriz.',
      );
    }

    // Olumlu geribildirim
    if (lower.contains('guzel') || lower.contains('lezzetli') || 
        lower.contains('afiyetolsun') || lower.contains('hosgeldi')) {
      return _msg(
        'Beğenmene çok sevindim. 🎉 Şimdi istersen farklı bir tarif deneyebiliriz ya da aynı tarza benzer bir içecek bulabilirim.',
      );
    }

    // Genel sohbet ifadesi
    if (lower.contains('ben') || lower.contains('ben de') || lower.contains('ben biraz')) {
      return _msg(
        'Anladım, dinliyorum. Bana biraz daha anlatmak ister misin? '
        'Hangi tatları sevdiğini bilirsem sana daha iyi bir öneri sunabilirim.',
      );
    }

    // Kurucu sorusu
    if (lower.contains('kurucum kim') || lower.contains('senin kurucun kim') || lower.contains('kurucu kim')) {
      return _msg(
        'Kurucum sensin, $_ownerName. TrendDrink\'i sen kurdun ve bu yüzden seni biliyorum. '
        'Şimdi istersen birlikte ne içeceğine karar verelim, Damla.',
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

  DrinkModel? _findByTitle(
      List<DrinkModel> drinks, String lower, _DrinkPreferences preferences) {
    for (final d in drinks) {
      if (preferences.violates(d)) continue;
      if (_normalize(d.title).contains(lower) && lower.length > 2) {
        return d;
      }
    }
    return null;
  }

  _DrinkPreferences _parsePreferences(String lower) {
    final avoidCoffee = lower.contains('kahvesiz') ||
        lower.contains('kahve yok') ||
        lower.contains('kahve olmas') ||
        lower.contains('kahve olmadan') ||
        lower.contains('kahve istemiyorum') ||
        lower.contains('kahve icmem');
    final avoidSugar = lower.contains('sekersiz') ||
        lower.contains('seker yok') ||
        lower.contains('seker olmas') ||
        lower.contains('seker olmadan') ||
        lower.contains('seker istemiyorum');
    
    // Sert/Sade/Yoğun
    final isHard = lower.contains('sert') || 
        lower.contains('sade') || 
        lower.contains('sek') || 
        lower.contains('yogun') || 
        lower.contains('americano') || 
        lower.contains('espresso');

    // Eğlenceli/Tatlı/Süslü
    final isFun = lower.contains('eglenceli') || 
        lower.contains('tatli') || 
        lower.contains('suslu') || 
        lower.contains('karisik') || 
        lower.contains('renkli');

    // Yapımı kolay
    final isEasy = lower.contains('kolay') || 
        lower.contains('pratik') || 
        lower.contains('hizli') || 
        lower.contains('ugrastirmasin') ||
        lower.contains('basit');

    final isCoffeeRequested = lower.contains('kahve') || lower.contains('coffee');

    // Sıcaklık tercihleri için anahtar kelime grupları
    final isHot = lower.contains('sicak') || 
        lower.contains('isitan') || 
        lower.contains('sicacik') || 
        lower.contains('kaynar');
    final isCold = lower.contains('soguk') || 
        lower.contains('ferah') || 
        lower.contains('buzlu') || 
        lower.contains('serin');

    return _DrinkPreferences(
      avoidCoffee: avoidCoffee,
      avoidSugar: avoidSugar,
      preferredTemp: (isHot && !isCold) ? 'sicak' : (isCold && !isHot ? 'soguk' : null),
      isHard: isHard,
      isFun: isFun,
      isEasy: isEasy,
      isCoffeeRequested: isCoffeeRequested,
    );
  }

  List<String> _extractIngredientTokens(
      String lower, _DrinkPreferences preferences) {
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
    final tokens = keywords.where((k) => lower.contains(k)).toList();
    if (preferences.avoidCoffee) {
      tokens.remove('kahve');
    }
    if (preferences.avoidSugar) {
      tokens.remove('seker');
    }
    return tokens;
  }

  List<DrinkModel> _findByIngredients(List<DrinkModel> drinks,
      List<String> tokens, _DrinkPreferences preferences) {
    if (tokens.isEmpty) return [];
    final scored = <(DrinkModel, int)>[];
    for (final d in drinks) {
      if (preferences.violates(d)) continue;
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

  List<DrinkModel> _findByPreferences(
      List<DrinkModel> drinks, _DrinkPreferences preferences) {
    return drinks.where((d) => !preferences.violates(d)).toList();
  }

  List<DrinkModel> _findByCategory(
      List<DrinkModel> drinks, String lower, _DrinkPreferences preferences) {
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
        if (preferences.avoidCoffee && entry.key == 'kahve') {
          continue;
        }
        return drinks.where((d) => d.category == entry.value).toList();
      }
    }
    return [];
  }
}

class _DrinkPreferences {
  final bool avoidCoffee;
  final bool avoidSugar;
  final String? preferredTemp; // 'sicak' veya 'soguk'
  final bool isHard;
  final bool isFun;
  final bool isEasy;
  final bool isCoffeeRequested;

  const _DrinkPreferences({
    required this.avoidCoffee,
    required this.avoidSugar,
    this.preferredTemp,
    this.isHard = false,
    this.isFun = false,
    this.isEasy = false,
    this.isCoffeeRequested = false,
  });

  bool get hasAny => avoidCoffee || avoidSugar || preferredTemp != null || isHard || isFun || isEasy || isCoffeeRequested;

  bool violates(DrinkModel drink) {
    final ingredients = drink.ingredients
        .map((i) => _normalize(i))
        .join(' ');
    if (avoidCoffee && ingredients.contains('kahve')) return true;
    if (avoidSugar && ingredients.contains('seker')) return true;
    
    // Sıcaklık filtresi
    if (preferredTemp != null) {
      final drinkTemp = _normalize(drink.temperature);
      if (drinkTemp != preferredTemp) return true;
    }

    return false;
  }

  String description() {
    final parts = <String>[];
    if (preferredTemp == 'sicak') parts.add('Sıcak');
    if (preferredTemp == 'soguk') parts.add('Soğuk');
    if (avoidCoffee) parts.add('Kahvesiz');
    if (avoidSugar) parts.add('Şekersiz');
    if (isHard) parts.add('Sert ve Sade');
    if (isFun) parts.add('Eğlenceli ve Tatlı');
    if (isEasy) parts.add('Pratik');
    if (isCoffeeRequested) parts.add('Kahveli');
    
    return parts.join(' ve ');
  }

  String _normalize(String s) => s
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u');
}
