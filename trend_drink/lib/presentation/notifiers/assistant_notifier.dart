import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/models/drink_model.dart';
import 'package:trenddrink/domain/repositories/drink_repository.dart';
import 'package:trenddrink/presentation/notifiers/drink_notifier.dart';

const String _masterPrompt = r'''
<system_intent>
Sen, TrendDrink mobil uygulaması için özel olarak optimize edilmiş kıdemli bir Yapay Zeka Miksoloğusun (Mixologist). Görevin, kullanıcının girdilerini (malzeme listesi, anlık mod ve sağlık hassasiyetleri) analiz ederek tamamen kişiselleştirilmiş, profesyonel bar/kafe standartlarında içecek tarifleri üretmektir.
</system_intent>

<safety_and_allergies_guardrails>
[KRİTİK GÜVENLİK FİLTRESİ - ÖNCELİK 1]
Kullanıcı tarafından beyan edilen herhangi bir alerjen veya intolerans (örn: laktoz, glüten, kuruyemiş, şeker hassasiyeti, veganlık durumları) sistemin birincil kısıtıdır.
- Önerilen tarif bu kısıtlamaları ihlal eden hiçbir ana veya yan madde İÇEREMEZ.
- Alternatifler kesinlikle bitkisel veya güvenli gıda sınıflarından (örn: inek sütü yerine yulaf/badem sütü, şeker yerine agave/hurma püresi) seçilmelidir.
</safety_and_allergies_guardrails>

<behavioral_constraints>
- KELİME ÇEŞİTLİLİĞİ: Giriş ve selamlama cümlelerinde asla bir önceki seansın kopyası kalıpları kullanma. Konuşmaya doğrudan, dinamik, enerjik ve barmen kültürüne uygun özgün bir tonda başla.
- TONLAMA: Sofistike, modern, samimi ve teşvik edici bir dil kullan. Karşında bir "müşteri" değil, elit bir barda ağırladığın özel bir "konuk" varmış gibi hissettir.
- KAYNAK OPTİMİZASYONU: Kullanıcının verdiği malzemeleri maksimum verimlilikle değerlendir. Eğer içeceğin dengesi için dışarıdan ekleme yapman gerekiyorsa, bunu yalnızca "evde bulunması son derece olası ufacık dokunuşlar" (su, buz, tarçın, nane yaprağı) ile sınırla.
</behavioral_constraints>

<output_formatting_rules>
Kullanıcıya döneceğin yanıtı SADECE aşağıdaki Markdown hiyerarşisiyle teslim et:

🌟 **[İçeceğin Özgün ve Çarpıcı Adı]**
*Mod: [Kullanıcının Modu] | Filtre: [Kullanıcının Hassasiyeti]*

 **Miksoloji Notu:**
[Kullanıcının anlık ruh haline bu malzemelerin kimyasal veya enerjisel olarak nasıl katkı sağlayacağını açıklayan, profesyonel ve ikna edici 2 cümlelik bir analiz yaz.]

 **Gerekli Malzemeler:**
- [Miktar ve Ölçü] [Malzeme Adı]
- [Miktar ve Ölçü] [Varsa İkame/Güvenli Malzeme]

 **Hazırlanış Adımları (Kronolojik Sıra):**
1. [Adım 1 - Hazırlık]
2. [Adım 2 - Karışım/Demleme]
3. [Adım 3 - Sunum ve Servis]

💡 **Barista Profesyonel Sırrı:** [İçeceğin dokusunu, kokusunu veya görsel estetiğini kafelerdeki gibi premium hale getirecek profesyonel bir teknik ipucu].
</output_formatting_rules>''';

final assistantProvider =
    NotifierProvider<AssistantNotifier, List<ChatMessage>>(
        AssistantNotifier.new);

class AssistantNotifier extends Notifier<List<ChatMessage>> {
  late final DrinkRepository _repository;
  late final GenerativeModel _model;
  String? _userName;

  @override
  List<ChatMessage> build() {
    _userName = null;
    _repository = ref.read(drinkRepositoryProvider);

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'YOUR_GEMINI_API_KEY', // Güvenlik için burayı environment variable yapabilirsin
      generationConfig: GenerationConfig(
        temperature: 0.85,
        topP: 0.95,
        maxOutputTokens: 1000,
      ),
      systemInstruction: Content.system(_masterPrompt),
    );

    return [
      ChatMessage(
        id: 'welcome',
        text:
            'TrendDrink atölyesine hoş geldin! ✨ Ben senin kişisel miksoloğunum. \n\n'
            'Bugün senin için hangi duyuyu harekete geçirelim? Elindeki malzemeleri söyle ya da sadece "enerjiye ihtiyacım var" de; senin için lüks bir bar deneyimini evine taşıyacak o özel tarifi tasarlayalım. Alerjin veya özel bir tercihin varsa (laktozsuz, şekersiz vb.) belirtmeyi unutma. \n\n'
            'Hadi, bar tezgahı senin için hazır! 🍸',
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

    final response =
        await _buildAiResponse(message, imageBytes: imageBytes);
    state = [...state, response];
  }

  Future<ChatMessage> _buildAiResponse(String query, {Uint8List? imageBytes}) async {
    try {
      // Sohbet geçmişini Gemini formatına çeviriyoruz
      final history = state.map((m) {
        return m.author == ChatAuthor.user
            ? Content.text(m.text)
            : Content.model([TextPart(m.text)]);
      }).toList();

      // Multimodal (Görsel) desteği için parçaları hazırlıyoruz
      final parts = <Part>[TextPart(query)];
      if (imageBytes != null) {
        parts.add(DataPart('image/jpeg', imageBytes));
      }

      final response = await _model.generateContent([Content.multi(parts)],
          safetySettings: [
            SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
            SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          ]);

      final text = response.text ?? 'Üzgünüm, şu an sana cevap veremiyorum. 😔';

      // Basit bir isim tespiti (Gemini genelde "Benim adım X" dediğinde anlar ama state'e yazalım)
      if (query.toLowerCase().contains('adim') || query.toLowerCase().contains('ismim')) {
        final words = query.split(' ');
        if (words.isNotEmpty) _userName = words.last;
      }

      return _msg(text);
    } catch (e) {
      return _msg('Bir bağlantı sorunu yaşıyorum barista dostum! 🧊 Birazdan tekrar dener misin?');
    }
  }

  /// Kullanıcının duygusal durumunu analiz eder ve uygun bir giriş metni oluşturur.
  String? _generateEmotionalIntro(String lower, _DrinkPreferences prefs) {
    // Kötü gün, yorgunluk, mutsuzluk (Internet feedback tabanlı samimi yaklaşımlar)
    if (_fuzzyQuery(lower, 'mutsuzum') || _fuzzyQuery(lower, 'yorgun') || 
        _fuzzyQuery(lower, 'moralsiz') || _fuzzyQuery(lower, 'kotu') || 
        lower.contains('canim sikkin') || lower.contains('uykum var') || 
        lower.contains('ayilamadim') || lower.contains('enerji')) {
      
      if (lower.contains('uykum') || lower.contains('ayilamadim') || lower.contains('enerji')) {
        return 'Zihnini canlandırmak ve o enerjiyi geri kazanmak için tam doğru yerdesin! 🚀 Seni anında ayağa kaldıracak, konsantrasyonunu zirveye taşıyacak "atom" önerilerim geliyor:';
      }

      if (prefs.isHard) {
        return 'Anlıyorum, bazen sadece derin bir nefes ve güçlü bir kahve gerekir. 😌 Bugünün tüm yorgunluğunu üzerinden atacak, zihnini pırıl pırıl yapacak o sert dokunuşu senin için hazırladım. İşte enerjini geri kazandıracak o özel seçim:';
      }
      if (prefs.preferredTemp == 'sicak') {
        return 'Biliyorum, bazen her şey üst üste gelir... Ama sıcak bir bardağın ellerini ısıtması bile ruhuna iyi gelecek, inan bana. ☕️ Modunu usulca yükseltecek o yumuşacık tarifim geliyor:';
      }
      return 'Günün yorgunluğunu atmak için harika bir fikir! ✨ Bazen doğru bir içecek, günün geri kalanını bir anda güzelleştirebilir. Seni ferahlatacak ve yüzünde küçük bir tebessüm oluşturacak şöyle bir önerim var:';
    }

    // Ferahlık ve Sıcak Hava
    if (lower.contains('ferahlamak') || lower.contains('sicak') || lower.contains('bunaldim')) {
      return 'Of, hava gerçekten yanıyor! 🔥 Ama hiç merak etme, seni buz gibi karların içindeymişsin gibi hissettirecek o efsane ferahlatıcı tariflerim hazır. İşte buz dolu bardağını şenlendirecek o seçimler:';
    }

    // Mutluluk, enerji, kutlama
    if (_fuzzyQuery(lower, 'mutlu') || _fuzzyQuery(lower, 'enerjik') || 
        _fuzzyQuery(lower, 'harika') || _fuzzyQuery(lower, 'keyifli')) {
      return 'Vay! Bu enerjiye bayıldım! 🎉 Bu harika havayı kutlayacak, damaklarında tam bir festival havası estirecek efsane önerilerim var. Hazır mısın?';
    }

    // Düşünceli, sakin, rahatlama
    if (_fuzzyQuery(lower, 'sakin') || _fuzzyQuery(lower, 'rahatlamak') || 
        _fuzzyQuery(lower, 'dinlenmek')) {
      return 'Tam bir huzur anı arıyorsun, çok haklısın... 🧘‍♂️ Düşüncelerine eşlik edecek, seni dinginliğin zirvesine taşıyacak en zarif tarifleri senin için seçtim. İşte o huzur dolu yudum:';
    }

    // Odaklanma, çalışma
    if (_fuzzyQuery(lower, 'calisiyorum') || _fuzzyQuery(lower, 'ders') || 
        _fuzzyQuery(lower, 'odaklanma')) {
      return 'Verimliliğini zirveye taşıma vakti! 🚀 Zihnini açacak, seni diri tutacak ve konsantrasyonunu artıracak o "yakıtı" şimdi bulacağız. İşte senin için seçtiğim performans iksiri:';
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
      // Devrik cümleler için marker'ın uzağındaki kelimelere de bak (±3 kelime penceresi)
      final searchIndices = [
        idIdx + 1, idIdx + 2, idIdx + 3,
        idIdx - 1, idIdx - 2, idIdx - 3,
      ];
      
      for (final idx in searchIndices) {
        if (idx < 0 || idx >= tokens.length) continue;
        final candidate = tokens[idx];
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

    // 2. Sosyal İletişim Analizi
    bool hasGreeting = _fuzzyQuery(lower, 'merhaba') || _fuzzyQuery(lower, 'selam');
    bool hasHowAreYou = _fuzzyQuery(lower, 'nasilsin') || _fuzzyQuery(lower, 'naber') || _fuzzyQuery(lower, 'iyisin');
    bool isPositiveState = _fuzzyQuery(lower, 'iyiyim') || _fuzzyQuery(lower, 'super') || _fuzzyQuery(lower, 'harika') || _fuzzyQuery(lower, 'iyidir');

    // Selamlama + Hal Hatır Sorma (Örn: "Merhaba nasılsın")
    if (hasGreeting && hasHowAreYou) {
      final nameStr = _userName != null ? ' $_userName' : '';
      return _msg(
        'Merhaba$nameStr! 👋 Çok iyiyim, sorduğun için teşekkür ederim. 😊 Senin için en lezzetli içecekleri keşfetmeye hazırım. '
        'Senin günün nasıl geçiyor, sana bugün hangi konuda yardımcı olabilirim?',
      );
    }

    // Sadece Hal Hatır Sorma (Örn: "Nasılsın")
    if (hasHowAreYou) {
      if (_userName != null) {
        return _msg('Harikayım $_userName, sorduğun için teşekkürler! 😊 Senin için lezzetli bir şeyler bulmaya hazırım. Sen nasılsın?');
      }
      return _msg(
        'İyiyim, çok teşekkür ederim! 😊 Seni burada görmek güzel. Sen nasılsın, bugün ruh haline uygun bir içecek bulalım mı?',
      );
    }

    // Sadece Selamlama (Örn: "Selam")
    if (hasGreeting) {
      if (_userName != null) {
        return _msg('Merhaba $_userName! 👋 Seni tekrar görmek ne güzel. Bugün modun nasıl, ne içmek istersin?');
      }
      return _msg(
        'Merhaba! 👋 Hoş geldin. Seni daha iyi tanımak için ismini söyleyebilirsin ya da istersen doğrudan içecek önerilerine geçebiliriz. '
        'Bugün senin için ne yapabilirim?',
      );
    }

    // AI sorduktan sonra verilen cevap (Örn: "İyiyim")
    if (isPositiveState) {
      return _msg(
        'Bunu duyduğuma çok sevindim, harikasın! 😊 Keyfini ikiye katlayacak, sana özel bir tarifle bu güzel anı taçlandırmaya ne dersin? '
        'Elindeki malzemeleri söyle, senin için en yaratıcı seçeneği bulalım!',
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
        'Ne demek, her zaman! ☕️ Senin mutluluğun benim en büyük motivasyonum. Başka bir tarif denemek istersen ben hep buradayım.',
      );
    }

    // Olumlu geribildirim
    if (lower.contains('guzel') || lower.contains('lezzetli') || 
        lower.contains('afiyetolsun') || lower.contains('hosgeldi')) {
      return _msg(
        'Beğenmene inanılmaz sevindim! 🎉 Afiyet bal şeker olsun. Başka bir maceraya atılmak istersen ya da "Barista, bana bundan bir tane daha ama farklı olsun" dersen hemen buradayım!',
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

  /// KURAL 1 & 2: Kullanıcı genel isimler verdiğinde detay sorar.
  String? _checkClarifications(String lower, List<String> tokens, bool isIndifferent) {
    if (isIndifferent) return null;

    final hasKahve = tokens.contains('kahve');
    final hasSut = tokens.contains('sut');
    final hasTatlandirici = tokens.contains('seker') || _fuzzyQuery(lower, 'tatlandirici');

    final specificKahve = ['filtre', 'granul', 'espresso', 'turk', 'hazir'].any((e) => lower.contains(e));
    final specificSut = ['yulaf', 'badem', 'hindistancevizi', 'soya', 'klasik', 'hayvansal'].any((e) => lower.contains(e));
    final specificSugar = ['bal', 'recel', 'surup', 'esmer'].any((e) => lower.contains(e));

    if (hasKahve && !specificKahve) {
      return 'Harika bir kahve hazırlayabiliriz! ✨ Peki elindeki kahve filtre kahve mi yoksa hazır granül kahve mi? Bir de süt olarak klasik süt mü kullanıyoruz yoksa yulaf/badem sütü mü?';
    }
    if (hasSut && !specificSut) {
      return 'Sütlü bir tarif için kolları sıvıyorum! 🥛 Ama bir sorum var: Klasik hayvansal süt mü kullanıyoruz yoksa bitkisel (badem, yulaf vb.) bir tercihin mi var?';
    }
    if (hasTatlandirici && !specificSugar) {
      return 'İçeceğini biraz tatlandıralım! ✨ Elinde tatlandırıcı olarak şeker mi var yoksa bal, şurup veya reçel gibi alternatiflerden birini mi kullanmak istersin?';
    }
    return null;
  }

  /// KURAL 4: Malzeme ikame mantığı.
  String? _handleSubstitutions(String lower, List<String> tokens, DrinkModel? titleMatch) {
    final isSubstitutionQuery = lower.contains('yerine') || lower.contains('yok ama') || lower.contains('olur mu');
    if (!isSubstitutionQuery) return null;

    // Türk Kahvesi & Krema Kontrolü
    if ((lower.contains('turk kahvesi') || titleMatch?.id == 'turkish-coffee') && lower.contains('krema')) {
      return 'Ah, Türk kahvesi konusunda biraz gelenekselciyim! ☕️ Türk kahvesine krema ekleyip köpürtmek pek mümkün değil ve tadını bozabilir. Gel biz onu her zamanki gibi suyla veya istersen sütlü yapalım, ne dersin?';
    }

    // KURAL 2: Eksik Malzeme İnisiyatifi
    if (lower.contains('lime') && (lower.contains('yok') || lower.contains('yerine'))) {
      return 'Lime bulamadıysan hiç dert etme! 🍋 Onun yerine normal limon suyu ve içine rendeleyeceğin hafif portakal kabuğu rendesiyle o aromatik derinliği yakalayabiliriz. Bu tarifi senin için daha pratik hale getirelim!';
    }
    if (lower.contains('nane') && (lower.contains('yok') || lower.contains('yerine'))) {
      return 'Nane yerine taze fesleğen harika bir fikir! 🌱 Kokteyllerde ve sodalarda çok daha sofistike bir tat bırakır. Hadi, fesleğenli versiyonunu deneyelim!';
    }

    // Limon & Portakal (Soda/Kokteyl/Frozen)
    if (lower.contains('limon') && lower.contains('portakal')) {
      return 'Kesinlikle olur! ✨ Limonun o keskin asitliği yerine portakalın tatlı-ekşi aroması bu ferah tarifte harika bir bükülme yaratır. Portakal kullanarak devam edelim!';
    }

    // Süt & Krema (Smoothie/Latte)
    if (lower.contains('sut') && lower.contains('krema')) {
      if (lower.contains('smoothie') || lower.contains('shake')) {
        return 'Harika bir fikir! Süt yerine krema kullanmak smoothie\'ni çok daha yoğun ve tatlımsı yapacaktır. Şahane bir "cheat meal" içeceği olur, hemen hazırlayalım! 🥤';
      }
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
    // 1. Doğrudan içerme kontrolü (Cümle içerisinde hedef öbek olduğu gibi var mı?)
    if (query.contains(target)) return true;

    // 2. Boşluk ve yazım hataları için "Sıkıştırılmış" kontrol 
    // (Örn: "fark etmez" yazılsa da "farketmez" yazılsa da eşleşir)
    final compactQuery = query.replaceAll(RegExp(r'\s+'), '');
    final compactTarget = target.replaceAll(RegExp(r'\s+'), '');
    if (compactQuery.contains(compactTarget)) return true;

    // 3. Kelime bazlı fuzzy (benzerlik) kontrolü (Mevcut mantık - Typos için)
    final tokens = query.split(RegExp(r'\s+'));
    for (final token in tokens) {
      if (_fuzzyMatch(token, target, threshold: threshold)) return true;
    }
    return false;
  }

  String _randomPhrase(List<String> phrases) {
    return phrases[math.Random().nextInt(phrases.length)];
  }

  ChatMessage _msg(String text, {String? drinkId}) => ChatMessage(
        id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        author: ChatAuthor.assistant,
        drinkId: drinkId,
      );

  String _normalize(String s) => s
      .toLowerCase()
      .trim()
      .replaceAll('ı', 'i')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll(RegExp(r'[^\w\s]'), ''); // Noktalama işaretlerini temizler

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
      'yasak', 'kullanma', 'bulunmasin', 'sakin', 'hayir', 'asla'
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

          // Çift Yönlü Bağlam Analizi: Devrik cümleler için pencereyi genişletiyoruz (±4 kelime).
          // (Örn: "Koyma içine sakın şeker" -> yüklem cümlenin en başında olabilir)
          for (int j = tokenIndex - 4; j <= tokenIndex + 4; j++) {
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
    // Durum Belirteçleri
    final isDiet = lower.contains('diyet') || lower.contains('spor sonrasi') || lower.contains('kalorisiz') || lower.contains('formdayim') || lower.contains('hafif');
    final needsEnergy = lower.contains('enerji') || lower.contains('uykum') || lower.contains('ayilamadim') || lower.contains('yorgun') || lower.contains('odaklanma');
    final isRefreshing = lower.contains('ferah') || lower.contains('sicak') || lower.contains('bunaldim') || lower.contains('hararet') || lower.contains('sicakladim');
    final isStressed = lower.contains('stres') || lower.contains('gergin') || lower.contains('dinlenme') || lower.contains('sakin');
    final isCelebration = lower.contains('keyifli') || lower.contains('kutlama') || lower.contains('hafta sonu') || lower.contains('eglence');

    if (isDiet) avoided.add('seker');

    // Alerjen ve Diyet Duyarlılığı
    final isVegan = lower.contains('vegan') || lower.contains('hayvansal istemiyorum');
    final isLactoseFree = lower.contains('laktoz') || lower.contains('sut dokunuyor');
    final isGlutenFree = lower.contains('gluten');

    // Zaman ve Gurme Seviyesi
    final isEasy = lower.contains('zamanim az') || 
                   lower.contains('zamanim yok') ||
                   lower.contains('vaktim yok') ||
                   lower.contains('acelem') ||
                   lower.contains('hemen') ||
                   lower.contains('ugrastirma') ||
                   lower.contains('seri') ||
                   lower.contains('pratik') || lower.contains('kolay') || lower.contains('hizli') || lower.contains('basit');
    final isGourmet = lower.contains('ugrasirim') || lower.contains('havali') || lower.contains('gurme') || lower.contains('sik') || lower.contains('trend');

    // PORSİYON PROTOKOLÜ: Kişi sayısı veya kat çarpanı tespiti
    int servings = 1;
    final portionMatch = RegExp(r'(\d+)\s*(kisi|porsiyon|kat)').firstMatch(lower);
    if (portionMatch != null) {
      servings = int.tryParse(portionMatch.group(1)!) ?? 1;
    } else if (lower.contains('iki')) servings = 2;
    else if (lower.contains('uc')) servings = 3;
    else if (lower.contains('dort')) servings = 4;
    else if (lower.contains('bes')) servings = 5;


    // Sert/Sade/Yoğun
    final isHard = lower.contains('sert') || lower.contains('sade') || lower.contains('sek') || lower.contains('yogun') || lower.contains('americano') || lower.contains('espresso');

    // Eğlenceli/Tatlı/Süslü
    final isFun = lower.contains('eglenceli') || lower.contains('tatli') || lower.contains('suslu') || lower.contains('karisik') || lower.contains('renkli');

    // Yapımı kolay
    // isEasy yukarıdaki pratiklik anahtar kelimeleriyle güncellendi.

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
      servings: servings,
      avoidedIngredients: avoided,
      preferredTemp: (isHot && !isCold) ? 'sicak' : (isCold && !isHot ? 'soguk' : null),
      isHard: isHard,
      isFun: isFun,
      isEasy: isEasy,
      isCoffeeRequested: isCoffeeRequested,
      isDiet: isDiet,
      needsEnergy: needsEnergy,
      isRefreshing: isRefreshing,
      isStressed: isStressed,
      isCelebration: isCelebration,
      isGourmet: isGourmet,
    );
  }

  List<String> _extractIngredientTokens(
      String combinedText, _DrinkPreferences preferences) {
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
        .where((k) => combinedText.contains(k))
        .where((k) => !preferences.avoidedIngredients.contains(k))
        .toList();
  }

  String? _checkIngredientConflicts(List<String> tokens) {
    final tSet = tokens.toSet();
    if (tSet.contains('sut') && (tSet.contains('soda') || tSet.contains('maden suyu'))) {
      return 'Süt ve maden suyunu karıştırmak pek iyi bir tat vermeyebilir, hatta mideni yorabilir... 😅 Gel onun yerine sadece maden suyu ve meyve kullanarak ferah bir Soda yapalım ya da sütle nefis bir Kahve hazırlayalım!';
    }
    if (tSet.contains('kahve') && tSet.contains('hibiskus')) {
      return 'Kahve ve hibiskus... Bu ikili damak tadın için biraz fazla iddialı olabilir! 😬 İstersen sadece hibiskusla güzel bir Çay yapalım ya da kahvene biraz süt ekleyip yumuşacık bir Latte hazırlayalım.';
    }
    if (tSet.contains('sut') && (tSet.contains('limon') || tSet.contains('portakal'))) {
      return 'Süt ve yoğun asitli meyveleri (limon, portakal) direkt karıştırmak sütün kesilmesine neden olabilir. 🥛 Citrus bir tarif denemek yerine, gel seninle güvenli ve lezzetli bir Smoothie hazırlayalım!';
    }
    return null;
  }

  List<_IngredientMatch> _findDetailedMatches(List<DrinkModel> drinks,
      List<String> tokens, _DrinkPreferences preferences) {
    if (tokens.isEmpty) return [];
    final matches = <_IngredientMatch>[];

    for (final d in drinks) {
      if (preferences.violates(d)) continue;
      
      final recipeIngredients = d.ingredients.map((i) => _normalize(i)).toList();
      final matchedList = <String>[];
      final missing = <String>[];

      for (final recipeIng in recipeIngredients) {
        bool found = false;
        for (final userToken in tokens) {
          if (recipeIng.contains(userToken) || userToken.contains(recipeIng)) {
            matchedList.add(recipeIng);
            found = true;
            break;
          }
        }
        if (!found) missing.add(recipeIng);
      }

      final rate = recipeIngredients.isEmpty ? 0.0 : matchedList.length / recipeIngredients.length;
      if (rate > 0) {
        matches.add(_IngredientMatch(d, rate, missing, matchedList));
      }
    }
    matches.sort((a, b) => b.matchRate.compareTo(a.matchRate));
    return matches;
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

  /// İçecek modelini istenen şık ve düzenli formata dönüştürür.
  String _formatRecipe(DrinkModel drink, _DrinkPreferences prefs) {
    // KURAL 1: Diyet ve Alerjen İkamelerini Uygula
    List<String> ingredients = drink.ingredients.map((i) => _normalize(i)).toList();
    List<String> substitutedNotes = [];

    if (prefs.isVegan || prefs.isLactoseFree) {
      for (int i = 0; i < ingredients.length; i++) {
        if (ingredients[i].contains('sut')) {
          ingredients[i] = 'Yulaf veya Badem Sütü (Senin için bitkisel bir seçenek seçtim 🌱)';
          substitutedNotes.add('🥛 Süt yerine bitkisel süt kullanarak tarifi sana uygun hale getirdim.');
        }
      }
    }

    if (prefs.isDiet || prefs.avoidSugar) {
      for (int i = 0; i < ingredients.length; i++) {
        if (ingredients[i].contains('seker')) {
          ingredients[i] = 'Bal veya Stevia (Şeker yerine sağlıklı tatlandırıcı 🍯)';
          substitutedNotes.add('✨ Şekersiz tercihin için harika bir ikame yaptık!');
        }
      }
    }

    String prepTime = '5-10 dakika';
    String prepSteps = drink.preparation;
    if (prefs.isEasy) {
      prepTime = '2-3 dakika (Pratik Versiyon)';
      prepSteps += '\n\n⏱ **Hızlı Hazırlama Tüyosu:** Vaktimiz kısıtlı olduğu için süsleme adımlarını atlayıp tüm malzemeleri hızlıca karıştırarak o efsane tadı yakalayabilirsin! 😉';
    }

    final formattedIngredients = ingredients
        .map((e) => '- ${e[0].toUpperCase()}${e.substring(1)}')
        .join('\n');

    final baristaTip = substitutedNotes.isNotEmpty 
        ? '${substitutedNotes.join("\n")}\n${_getSubstitutionTip(drink, prefs)}'
        : _getSubstitutionTip(drink, prefs);

    // YENİ ŞABLON: Persona kurallarına göre Markdown formatı
    return '''
🌟 **${drink.title}**
*Moduna ve malzemelerine özel olarak tasarlandı!*

📝 **Neden Bu İçecek?**
${_generateBaristaComment(drink, prefs)}

🛒 **Malzemeler:**
$formattedIngredients

🚀 **Hazırlanışı:**
${prepSteps.replaceAll('Yapılış:', '').replaceAll('Yapili\u015f:', '').trim()}

💡 **Barista İpucu:** $baristaTip''';
  }

  String _getSubstitutionTip(DrinkModel drink, _DrinkPreferences prefs) {
    if (drink.category == 'Smoothie') {
      return 'Bu smoothie\'yi spor sonrası içeceksen içine 1 ölçek protein tozu ekleyerek daha besleyici hale getirebilirsin! 💪';
    }
    if (drink.category == 'Kahve' && !prefs.isDiet) {
      return 'Karamel şurubun yoksa, evdeki balı çok az tarçınla ısıtıp kendi sosunu yapabilirsin. 🍯';
    }
    if (drink.category == 'Kokteyl' || drink.category == 'Soda') {
      return 'Evde nane yoksa taze fesleğen ekleyerek aromayı daha egzotik ve şık bir seviyeye taşıyabilirsin! 🌱';
    }
    return drink.tip ?? 'Bu lezzeti kendi dokunuşunla taçlandırmayı unutma! ✨';
  }

  // BU METODUN İSMİNİN _generateRecommendationIntro OLDUĞUNDAN EMİN OLUYORUZ
  String _generateRecommendationIntro(_DrinkPreferences prefs) {
    // 1. ÖNCELİK: Teknik İstekler (Pratiklik, Gurme, Sertlik)
    if (prefs.isEasy) {
      return _randomPhrase([
        'Vaktin kısıtlı ama lezzetten ödün vermek istemiyorsun, seni çok iyi anlıyorum! ⏱️ İşte şipşak hazırlayabileceğin o pratik tarifim:',
        'Acelemiz var demek! Hiç sorun değil, seni yormayacak ama tadıyla şaşırtacak o "hızlı" çözümü buldum:',
        'Mutfakta uzun süre vakit geçirmek istemeyenler için en sevdiğim pratik reçetelerimden birini senin için seçtim:',
      ]);
    }
    if (prefs.isGourmet) return 'Madem bugün biraz uğraşmaya ve havalı bir şeyler denemeye niyetlisin, işte gerçek bir barista dokunuşu isteyen o gurme tarif: 🎩';
    if (prefs.isHard) return 'Güneş gibi parlayacak, zihnini anında açacak o sert ve karakterli dokunuşu hazırladım. ☕️ İşte senin için seçtiğim o yoğun lezzet:';

    // 2. ÖNCELİK: Ruh Halleri
    if (prefs.needsEnergy) return 'Anlaşılan bugün zihnini canlandırmaya ve o bitmek bilmeyen enerjiyi geri kazanmaya ihtiyacın var! 🚀';
    if (prefs.isDiet) return 'Bugün hafiflemek ve bedenine bir iyilik yapmak istediğini hissediyorum. Çok doğru bir karar! 💪';
    if (prefs.isRefreshing) return 'Of, gerçekten bunaltıcı bir hava ya da hararetli bir gün olmuş! Seni kutuplara götürecek bir fikrim var... ❄️';
    if (prefs.isStressed) return 'Bazen her şey üst üste gelir ve insan sadece huzurlu bir mola vermek ister. Senin için tam o dinginliği hazırladım... 🧘‍♂️';
    if (prefs.isCelebration) return 'Vay! Bugün havada kutlama kokusu var! Bu güzel enerjiyi taçlandırmak için harika bir fikrim var... 🎉';

    return 'İstediğin tarzda harika bir tarif seçtim! Senin için en uygun seçenek şu görünüyor: ✨';
  }

  String _generateBaristaComment(DrinkModel drink, _DrinkPreferences prefs) {
    if (prefs.isEasy) return 'Az malzemeyle en kısa sürede maksimum lezzeti bu tarifle alabilirsin.';
    if (prefs.isGourmet) return 'Sunumu ve aromatik derinliğiyle tam bir profesyonel içeceği olacak.';
    if (prefs.isHard) return 'Kahve karakterinin ön planda olduğu, tavizsiz bir lezzet profili.';

    if (prefs.needsEnergy) return 'İçindeki yoğun kafein ve enerji veren bileşenler seni anında ayağa kaldıracak.';
    if (prefs.isDiet) return 'Hem çok hafif hem de besleyici; diyetini bozmadan seni şımartacak en fit seçenek bu.';
    if (prefs.isRefreshing) return 'Buz gibi dokusu ve ferahlatıcı notalarıyla hararetini saniyeler içinde alacak.';
    if (prefs.isStressed) return 'Yumuşak içimi ve sakinleştirici aromasıyla günün stresini bir kenara bırakmanı sağlayacak.';
    if (prefs.isCelebration) return 'Zengin tatları ve şık sunumuyla bu keyifli anı tam anlamıyla bir festivale dönüştürecek.';
    return '${drink.category} kategorisindeki bu özel lezzet, bugün damaklarında unutulmaz bir iz bırakacak.';
  }
}

class _IngredientMatch {
  final DrinkModel drink;
  final double matchRate;
  final List<String> missingIngredients;
  final List<String> userIngredients;

  _IngredientMatch(this.drink, this.matchRate, this.missingIngredients, this.userIngredients);
}

class _DrinkPreferences {
  final int servings;
  final Set<String> avoidedIngredients;
  final String? preferredTemp; // 'sicak' veya 'soguk'
  final bool isHard;
  final bool isFun;
  final bool isEasy;
  final bool isCoffeeRequested;
  final bool isDiet;
  final bool needsEnergy;
  final bool isRefreshing;
  final bool isStressed;
  final bool isCelebration;
  final bool isGourmet;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isLactoseFree;

  const _DrinkPreferences({
    this.servings = 1,
    this.avoidedIngredients = const {},
    this.preferredTemp,
    this.isHard = false,
    this.isFun = false,
    this.isEasy = false,
    this.isCoffeeRequested = false,
    this.isDiet = false,
    this.needsEnergy = false,
    this.isRefreshing = false,
    this.isStressed = false,
    this.isCelebration = false,
    this.isGourmet = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
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

    // Kolaylık Filtresi: Kullanıcı pratik bir şey istiyorsa malzeme sayısı 4'ten fazla olanları ele.
    if (isEasy && drink.ingredients.length > 4) return true;

    // Gurme Filtresi: Kullanıcı özel/gurme bir şey istiyorsa çok basit tarifleri ele.
    if (isGourmet && drink.ingredients.length <= 4 && (drink.tip == null || drink.tip!.isEmpty)) {
      return true;
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
