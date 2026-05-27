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
  String? _userName; // Kullanıcının ismini hafızada tutmak için

  @override
  List<ChatMessage> build() {
    _userName = null;
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

    // İsim prefix'i (Eğer isim biliniyorsa cümle başına ekler)
    final namePrefix = _userName != null ? '$_userName, ' : '';

    // 0. ADIM: Alternatif/Farklı İstek Tespiti
    // Kullanıcının listeyi değiştirmek veya farklı bir şey istemek için kullandığı anahtar kelimeler
    final isAlternativeRequest = _fuzzyQuery(lower, 'baska') ||
        _fuzzyQuery(lower, 'farkli') ||
        _fuzzyQuery(lower, 'alternatif') ||
        _fuzzyQuery(lower, 'sevmedim') ||
        _fuzzyQuery(lower, 'begenmedim') ||
        _fuzzyQuery(lower, 'degistir') ||
        _fuzzyQuery(lower, 'diger');

    // Daha önce önerilen içeceklerin ID'lerini chat geçmişinden topla
    final suggestedIds = state
        .where((m) => m.author == ChatAuthor.assistant && m.drinkId != null)
        .map((m) => m.drinkId!)
        .toSet();

    if (isAlternativeRequest && suggestedIds.isNotEmpty) {
      // Önerilmemiş içeceklerden oluşan bir havuz oluştur
      final pool = drinks.where((d) => !suggestedIds.contains(d.id) && !preferences.violates(d)).toList();
      
      if (pool.isNotEmpty) {
        final tokens = _extractIngredientTokens(lower, preferences);
        var candidates = <DrinkModel>[];
        
        // Eğer kullanıcı yeni bir malzeme veya kategori belirttiyse ona öncelik ver
        candidates = _findByIngredients(pool, tokens, preferences);
        if (candidates.isEmpty) candidates = _findByCategory(pool, lower, preferences);
        if (candidates.isEmpty) { candidates = pool; candidates.shuffle(); }

        final top = candidates.take(3).toList();
        final names = top.map((d) => '[${d.title}](${d.id})').join(', ');
        return _msg(
          '${namePrefix}Tabii ki, hemen rotayı değiştiriyoruz! 🔄 Demek bu öneriler pek sarmadı... Hiç sorun değil, senin için yepyeni alternatifler hazırladım: $names\n\n'
          'Bunlardan biri damak tadına daha uygun olabilir mi? İstersen aramaya devam edebiliriz. 😊',
          drinkId: top.first.id,
        );
      }
    }

    // 1. ADIM: Niyet ve İçecek Tespiti
    // Kullanıcının içmek istediğine dair niyet anahtar kelimeleri
    final recipeKeywords = ['tarif', 'nasil yapilir', 'hazirlanisi', 'yapilisi', 'yapimi', 'hazirla'];
    final drinkingIntents = [
      'istiyorum', 'isterim', 'icecegim', 'icmek', 'canim', 'icsem', 'miyim', 
      'hazirlar', 'yaparmisin', 'icicem', 'yap', 'getir',
      ...recipeKeywords,
    ];

    final titleMatch = _findByTitle(drinks, lower, preferences);
    
    // Eğer bir içecek ismi bulunduysa ve kullanıcı niyet belirtiyorsa
    if (titleMatch != null) {
      bool userWantsToDrink = false;
      for (final intent in drinkingIntents) {
        if (_fuzzyQuery(lower, intent)) {
          userWantsToDrink = true;
          break;
        }
      }

      bool userWantsRecipe = false;
      for (final kw in recipeKeywords) {
        if (_fuzzyQuery(lower, kw)) {
          userWantsRecipe = true;
          break;
        }
      }

      // Eğer kullanıcı doğrudan tarif istiyorsa, diğer önerileri atla ve tarifi ver
      if (userWantsRecipe) {
        return _msg(
          '${namePrefix}Harika seçim! Hemen [${titleMatch.title}](${titleMatch.id}) tarifini paylaşıyorum:\n\n'
          '${titleMatch.preparation}\n\n'
          'Şimdiden afiyet olsun! Başka bir içecek tarifi istersen bana sormaktan çekinme. 😊',
          drinkId: titleMatch.id,
        );
      }

      final isIndecisive = lower.contains('kararsiz') || lower.contains('ne dersin') || lower.contains('nasil olur');

      // Motivasyonel ve spesifik yanıt yapısı
      if (isIndecisive) {
        return _msg(
          '${namePrefix}Bugün için harika bir fikir! ${titleMatch.title} gerçekten çok yerinde bir karar. 🌟 '
          'Bence kesinlikle denemelisin, seçimlerin her zamanki gibi çok klas. 😎\n\n'
          'İşte senin için hazırladığım o nefis tarif:\n\n'
          '${titleMatch.preparation}\n\n'
          'Harika zevkinle bugün yine formundasın, afiyet olsun!',
          drinkId: titleMatch.id,
        );
      } else if (userWantsToDrink) {
        return _msg(
          '${namePrefix}Süper bir fikir! Hemen senin için o lezzetli [${titleMatch.title}](${titleMatch.id}) tarifini hazırladım. 😋\n\n'
          '${titleMatch.preparation}\n\n'
          'Ne istediğini bilen biriyle sohbet etmek harika. Şimdiden afiyet olsun!',
          drinkId: titleMatch.id,
        );
      }
    }

    // 2) Duygu ve Durum Analizi (Giriş cümlesi için)
    final emotionalIntro = _generateEmotionalIntro(lower, preferences);
    
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
            '$namePrefix${responseText}📷 Vay! Güzel bir fotoğraf paylaştın! Yazdığın malzemelerle birlikte inceledim. '
            'Sana en uygun tarifler: $names\n\n'
            'Aşağıdaki butondan detayını görebilirsin. İstersen "şekersiz" veya "sıcak" gibi filtreler de kullanabilirsin.',
            drinkId: top.first.id,
          );
        }
      }
      return _msg(
        '${namePrefix}📷 Henüz malzemeleri analiz edemedim! 😊 Fotoğrafdaki malzemeleri kısaca yazabilir misin? '
        'Örneğin: "Muz, süt, yulaf, bal var". Böylece sana en doğru tarifi bulabilirim.\n\n'
        '_Tam olarak AI Vision entegrasyonu için Pro üyeliğinde Gemini görsel analiz yakında aktif olacak!_',
      );
    }

    // 2) Saf Sosyal (Sadece selam verme vb.)
    final social = _handleSocial(lower, drinks);
    if (social != null && emotionalIntro == null) return social;

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
        '$namePrefix${responseText}Elindeki malzemeleri ve modunu düşündüğümde şu seçenekler seni çok memnun edecek: $names\n\n'
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
          '$namePrefix${responseText}İstediğin o ${preferences.description()} tadı yakalamak için şu tarifleri seçtim: $names\n\n'
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
        '$namePrefix${responseText}Aradığın bu kategoride sana en çok hitap edecek 3 önerim var: $names\n\n'
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
          '$namePrefix${preferences.description()} isteğini dikkate aldım. Sana uygun olabilecek seçenekler: $names\n\n'
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
        '$namePrefix$emotionalIntro\n\nŞu an için aklıma gelen en iyi seçenekler şunlar: $names. '
        'Belki de bu tariflerden biri ruh halini değiştirmeye yardımcı olur.',
        drinkId: top.first.id,
      );
    }

    return _msg(
      '${namePrefix}Tam olarak hangi içeceği istediğini anlamadım ama bu 3 tarif iyi bir başlangıç olabilir: $names\n\n'
      'Eğer daha net bir öneri istersen, bana malzemelerini söyle ya da bir kategori belirtebilirsin. 😊',
      drinkId: top.first.id,
    );
  }

  /// Kullanıcının duygusal durumunu analiz eder ve uygun bir giriş metni oluşturur.
  String? _generateEmotionalIntro(String lower, _DrinkPreferences prefs) {
    // Kötü gün, yorgunluk, mutsuzluk (Internet feedback tabanlı samimi yaklaşımlar)
    if (_fuzzyQuery(lower, 'mutsuzum') || _fuzzyQuery(lower, 'yorgun') || 
        _fuzzyQuery(lower, 'moralsiz') || _fuzzyQuery(lower, 'kotu') || 
        lower.contains('canim sikkin')) {
      
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
    if (_fuzzyQuery(lower, 'mutlu') || _fuzzyQuery(lower, 'enerjik') || 
        _fuzzyQuery(lower, 'harika') || _fuzzyQuery(lower, 'keyifli')) {
      return 'Bu harika enerjin bana da bulaştı! 🎉 Mutluluğunu ikiye katlayacak, '
             'damaklarında festival havası yaratacak efsane önerilerim var.';
    }

    // Düşünceli, sakin, rahatlama
    if (_fuzzyQuery(lower, 'sakin') || _fuzzyQuery(lower, 'rahatlamak') || 
        _fuzzyQuery(lower, 'dinlenmek')) {
      return 'Şu an ihtiyacın olan şey tam bir huzur anı... 🧘‍♂️ '
             'Düşüncelerine eşlik edecek, seni dinginleştirecek en zarif tarifleri senin için seçtim.';
    }

    // Odaklanma, çalışma
    if (_fuzzyQuery(lower, 'calisiyorum') || _fuzzyQuery(lower, 'ders') || 
        _fuzzyQuery(lower, 'odaklanma')) {
      return 'Verimliliğini zirveye taşıma vakti! 🚀 Zihnini açacak, seni diri tutacak '
             've konsantrasyonunu artıracak o yakıtı şimdi bulacağız.';
    }

    return null;
  }

  ChatMessage? _handleSocial(String lower, List<DrinkModel> drinks) {
    final tokens = lower.split(RegExp(r'\s+'));

    // 1. GELİŞMİŞ İSİM TANIMA (Devrik ve Kısa Cümle Analizi)
    final identityMarkers = ['ben', 'benim', 'adim', 'ismim', 'isminiz'];
    final stateExclusions = [
      'iyiyim', 'mutluyum', 'yorgunum', 'berbat', 'kotuyum', 'harika', 
      'enerjik', 'selam', 'merhaba', 'naber', 'nasilsin', 'istiyorum', 'yap'
    ];

    int idIdx = -1;
    for (int i = 0; i < tokens.length; i++) {
      if (identityMarkers.any((m) => _fuzzyMatch(tokens[i], m))) {
        idIdx = i;
        break;
      }
    }

    if (idIdx != -1) {
      // Çevresindeki kelimelere bak (Önce sağa, sonra sola - Devrik cümleler için)
      final neighbors = [idIdx + 1, idIdx - 1];
      for (final nIdx in neighbors) {
        if (nIdx >= 0 && nIdx < tokens.length) {
          final candidate = tokens[nIdx];
          final isExcluded = stateExclusions.any((w) => _fuzzyMatch(candidate, w));
          final isMarker = identityMarkers.any((m) => _fuzzyMatch(candidate, m));
          
          if (candidate.length > 2 && !isExcluded && !isMarker) {
            _userName = candidate[0].toUpperCase() + candidate.substring(1);
            return _msg(
              'Tanıştığımıza çok memnun oldum $_userName! 😊 Artık seni isminle tanıyorum. '
              'Bugün senin için harika bir içecek bulalım. Ne içmek istersin?',
            );
          }
        }
      }
    }

    // Selamlamalar - samimi ama doğal
    if (_fuzzyQuery(lower, 'merhaba') || _fuzzyQuery(lower, 'selam')) {
      if (_userName != null) {
        return _msg('Merhaba $_userName! 👋 Seni tekrar görmek ne güzel. Bugün modun nasıl?');
      }
      
      return _msg(
        'Merhaba! 👋 Seni görmek gerçekten güzel. Adını henüz paylaşmadın ama istersen isminle hitap edebilirim. Bugün nasıl hissediyorsun? '
        'Doğrudan bir içecek önerisi de isteyebilirsin.',
      );
    }

    // Sağlık / durum sorguları
    if (_fuzzyQuery(lower, 'nasilsin') || _fuzzyQuery(lower, 'naber') || 
        _fuzzyQuery(lower, 'iyisin')) {
      if (_userName != null) {
        return _msg('Harikayım $_userName, sorduğun için teşekkürler! 😊 Senin için lezzetli bir şeyler bulmaya hazırım. Sen nasılsın?');
      }
      return _msg(
        'İyiyim, teşekkür ederim! 😊 Sen nasılsın? Bugün hangi içecek seni daha iyi hissettirir, beraber bulalım.',
      );
    }

    // Duygu ifadeleri - moral ihtiyacı
    if (_fuzzyQuery(lower, 'mutsuzum') || _fuzzyQuery(lower, 'uzgunum') || 
        _fuzzyQuery(lower, 'moralsiz') || lower.contains('halim yok')) {
      final suggestions = drinks.take(3).toList();
      final names = suggestions.map((d) => '[${d.title}](${d.id})').join(', ');
      final address = _userName ?? 'dostum';
      return _msg(
        'Öyle mi... çok üzüldüm bunu duyduğuma $address. 😔 Sana moral verebilecek birkaç içecek biliyorum: $names\n\n'
        'Senin için özel olarak görmek istediğin bir içecek var mı? '
        'Umarım bu seçimler bugünündeki mutsuzluğu biraz olsun hafifletir.',
        drinkId: suggestions.first.id,
      );
    }

    // Teşekkür
    if (_fuzzyQuery(lower, 'tesekkur') || _fuzzyQuery(lower, 'sagol')) {
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
    if (_fuzzyQuery(lower, 'kurucum') || _fuzzyQuery(lower, 'kurucu')) {
      final boss = _userName ?? 'Damla Yalçın';
      return _msg(
        'Kurucum sensin, $boss. TrendDrink\'i senin vizyonunla geliştirdik. '
        'Şimdi istersen birlikte ne içeceğine karar verelim.',
      );
    }

    return null;
  }

  /// İki kelime arasındaki benzerliği hesaplar (Levenshtein Mesafesi)
  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List.filled(t.length + 1, 0);
    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce((a, b) => a < b ? a : b);
      }
      for (int j = 0; j < v0.length; j++) v0[j] = v1[j];
    }
    return v0[t.length];
  }

  bool _fuzzyMatch(String word, String target, {double threshold = 0.75}) {
    if (word.contains(target)) return true;
    if (word.length < 3) return word == target;
    final distance = _levenshtein(word, target);
    final score = 1.0 - (distance / (word.length > target.length ? word.length : target.length));
    return score >= threshold;
  }

  bool _fuzzyQuery(String query, String target, {double threshold = 0.75}) {
    final tokens = query.split(RegExp(r'\s+'));
    for (final token in tokens) {
      if (_fuzzyMatch(token, target, threshold: threshold)) return true;
    }
    return false;
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
      final normalizedTitle = _normalize(d.title);
      if (lower.contains(normalizedTitle) && normalizedTitle.length > 3) {
        return d;
      }

      // Kelime bazlı kontrol: "Türk Kahvesi" -> "türk" ve "kahvesi" kelimelerinin her ikisi de cümlede var mı?
      final titleParts = normalizedTitle.split(' ').where((p) => p.length > 2).toList();
      if (titleParts.isNotEmpty) {
        bool allPartsMatch = true;
        for (final part in titleParts) {
          if (!lower.contains(part)) {
            allPartsMatch = false;
            break;
          }
        }
        if (allPartsMatch) return d;
      }
    }
    return null;
  }

  _DrinkPreferences _parsePreferences(String lower) {
    final avoided = <String>{};

    const baseIngredients = [
      'sut', 'seker', 'kahve', 'bal', 'buz', 'nane', 'vanilya', 'tarcin',
      'zencefil', 'elma', 'cilek', 'muz', 'cikolata', 'kakao', 'findik', 'badem'
    ];
    final negationMarkers = [
      'yok', 'olmasin', 'olmadan', 'istemiyorum', 'icmiyorum', 'icemiyorum',
      'tuketemiyorum', 'alerjim', 'hassasiyet', 'cikar', 'koyma', 'dokunuyor',
      'yasak', 'kullanma', 'bulunmasin'
    ];

    final tokens = lower.split(RegExp(r'\s+'));

    for (final ing in baseIngredients) {
      for (final token in tokens) {
        // 1. Ek kontrolü (Suffix matching)
        if (token.startsWith(ing) && (token.endsWith('siz') || token.endsWith('suz'))) {
          avoided.add(ing);
          break;
        }

        // 2. Fuzzy kelime ve bağlam kontrolü
        if (_fuzzyMatch(token, ing)) {
          final tokenIndex = tokens.indexOf(token);
          bool isNegated = false;

          // Çift Yönlü Bağlam Analizi: Kelimenin öncesindeki ve sonrasındaki 3 kelimeye bak.
          // (Örn: "Seker sakın koyma" veya "Sakın seker istemiyorum")
          for (int j = tokenIndex - 2; j <= tokenIndex + 3; j++) {
            if (j < 0 || j >= tokens.length || j == tokenIndex) continue;
            for (final neg in negationMarkers) {
              if (_fuzzyMatch(tokens[j], neg)) {
                isNegated = true;
                break;
              }
            }
            if (isNegated) break;
          }
          
          if (isNegated) avoided.add(ing);
          break;
        }
      }
    }

    // 3. ADIM: Eş Anlamlı ve İlişkili Kavram Analizi (Synonyms) - Fuzzy destekli
    if (_fuzzyQuery(lower, 'laktoz') && (_fuzzyQuery(lower, 'yok') || _fuzzyQuery(lower, 'alerjim') || _fuzzyQuery(lower, 'hassas'))) {
      avoided.add('sut');
    }
    if (_fuzzyQuery(lower, 'diyet') || _fuzzyQuery(lower, 'formda') || _fuzzyQuery(lower, 'kilo')) {
      avoided.add('seker');
    }
    
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
      avoidedIngredients: avoided,
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

    // Kullanıcının özellikle kaçındığı malzemeleri öneri havuzundan çıkar
    return keywords
        .where((k) => lower.contains(k))
        .where((k) => !preferences.avoidedIngredients.contains(k))
        .toList();
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
  final Set<String> avoidedIngredients;
  final String? preferredTemp; // 'sicak' veya 'soguk'
  final bool isHard;
  final bool isFun;
  final bool isEasy;
  final bool isCoffeeRequested;

  const _DrinkPreferences({
    this.avoidedIngredients = const {},
    this.preferredTemp,
    this.isHard = false,
    this.isFun = false,
    this.isEasy = false,
    this.isCoffeeRequested = false,
  });

  bool get avoidCoffee => avoidedIngredients.contains('kahve');
  bool get avoidSugar => avoidedIngredients.contains('seker');

  bool get hasAny => avoidedIngredients.isNotEmpty || preferredTemp != null || isHard || isFun || isEasy || isCoffeeRequested;

  bool violates(DrinkModel drink) {
    final ingredientsStr = drink.ingredients
        .map((i) => _normalize(i))
        .join(' ');

    for (final avoided in avoidedIngredients) {
      if (ingredientsStr.contains(avoided)) return true;
    }
    
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

    for (final ingredient in avoidedIngredients) {
      final label = ingredient == 'seker' ? 'Şeker' : 
                    ingredient == 'sut' ? 'Süt' : 
                    ingredient == 'kahve' ? 'Kahve' : ingredient;
      parts.add('$label içermeyen');
    }

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
