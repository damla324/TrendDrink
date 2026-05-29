import 'package:flutter/material.dart';
import 'package:trenddrink/core/models/drink_model.dart';

class DrinkLocalSource {
  Future<List<DrinkModel>> fetchDrinks() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _drinks;
  }

  static const List<DrinkModel> _drinks = [
    // ── KAHVE ─────────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'iced-hazelnut-mocha',
      title: 'Iced Hazelnut Mocha',
      category: 'Kahve',
      description:
          'F\u0131nd\u0131kl\u0131yken so\u011fuk, \u00e7ikolatal\u0131 ve ferah bir kahve se\u00e7ene\u011fi.',
      history:
          'Mocha ad\u0131n\u0131 Yemen\'in Mocha liman\u0131ndan al\u0131r; buras\u0131 15. y\u00fczy\u0131lda Arabica kahvesinin d\u00fcnyaya a\u00e7\u0131lan kap\u0131s\u0131yd\u0131. Zamanla \u00e7ikolata ve f\u0131nd\u0131k ile harmanlanan mocha, modern kafeteryalar\u0131n en sevilen i\u00e7ece\u011fine d\u00f6n\u00fc\u015ft\u00fc.',
      temperature: 'So\u011fuk',
      pros: [
        'Antioksidan a\u00e7\u0131s\u0131ndan zengin',
        'An\u0131nda enerji sa\u011flar',
        'F\u0131nd\u0131k E vitamini i\u00e7erir',
        '\u00c7ikolata ruh halini y\u00fckseltir'
      ],
      cons: [
        'Y\u00fcksek kafein i\u00e7erir',
        'Kalori dengesi izlenmeli',
        '\u015eeker hassasiyeti olanlar dikkatli olmal\u0131'
      ],
      tip:
          'Sabah performans\u0131 i\u00e7in idealdir. Espresso shot\'unu \u00e7ok az \u00e7ekme, ac\u0131l\u0131k dengeyi bozar.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Espresso (1 shot, 30 ml)\n2. F\u0131nd\u0131k \u015furubu (2 yemek ka\u015f\u0131\u011f\u0131)\n3. S\u00fct (150 ml)\n4. Buz (1 fincan)\n5. Krem \u015fanti (s\u00fcsleme)\n6. Kakao tozu (s\u00fcsleme)\n\nYap\u0131l\u0131\u015f:\n1) Barda\u011fa espresso ve f\u0131nd\u0131k \u015furubunu ekle\n2) So\u011fuk s\u00fctu ekle ve kar\u0131\u015ft\u0131r\n3) Buz dolu barda\u011fa d\u00f6k\n4) \u00dczerine krem \u015fanti ekle\n5) Kakao tozu serpip servis et',
      ingredients: [
        'espresso',
        's\u00fct',
        'f\u0131nd\u0131k \u015furubu',
        'buz'
      ],
      imageUrl: 'Assets/Categories/kahve/ıced hazelnut mocha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
    ),
    DrinkModel(
      id: 'caramel-cold-brew',
      title: 'Caramel Cold Brew',
      category: 'Kahve',
      description:
          'Karamelin derinli\u011fi ile so\u011fuk demleme kahvenin harman\u0131.',
      history:
          'Cold brew tekni\u011fi 1600\'l\u00fc y\u0131llarda Japonya\'da "Kyoto style" ad\u0131yla biliniyordu. Bat\u0131\'da 2010\'lar\u0131n ba\u015f\u0131nda Third Wave Coffee hareketiyle birlikte yeniden ke\u015ffedildi.',
      temperature: 'So\u011fuk',
      pros: [
        'Asitli\u011fi d\u00fc\u015f\u00fck; mide dostudur',
        'Karamel do\u011fal enerji kayna\u011f\u0131d\u0131r',
        'So\u011fuk demleme 24 saat dayanabilir',
        'D\u00fc\u015f\u00fck kafein birikmesi riski'
      ],
      cons: [
        'Haz\u0131rl\u0131\u011f\u0131 12-24 saat s\u00fcrer',
        'Y\u00fcksek kalori (karamel sos nedeniyle)',
        'So\u011fuk ortamda haz\u0131rlanmal\u0131d\u0131r'
      ],
      tip:
          '\u00d6\u011fleden sonra, konsantrasyon gerektiren i\u015fler i\u00e7in m\u00fckemmel.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Buz (1 fincan)\n2. Cold brew (150 ml)\n3. Karamelli s\u00fct (100 ml)\n4. Karamel sos (3 yemek ka\u015f\u0131\u011f\u0131)\n5. \u00c7\u0131rp\u0131lm\u0131\u015f krem (\u015f\u00fcsleme)\n\nYap\u0131l\u0131\u015f:\n1) Barda\u011fa buz ekle\n2) Cold brew ekle\n3) Karamelli s\u00fctu ekle\n4) Karamel sosu kenardan gezdir\n5) Krem \u015fanti ile servis et',
      ingredients: ['buz', 'cold brew', 'karamelli s\u00fct', 'karamel sos'],
      imageUrl: 'Assets/Categories/kahve/caramel cold brew.jpg',
      gradient: LinearGradient(colors: [Color(0xFFA0522D), Color(0xFFD2B48C)]),
    ),
    DrinkModel(
      id: 'vanilla-iced-cappuccino',
      title: 'Vanilla Iced Cappuccino',
      category: 'Kahve',
      description:
          'Kremams\u0131 vanilya aromas\u0131 ile klasik cappuccino tazeligi.',
      history:
          'Cappuccino ad\u0131n\u0131 17. y\u00fczy\u0131lda Capuchin Fransisken ke\u015fi\u015flerinden al\u0131r; kahverengi c\u00fcbbeleri ile k\u00f6p\u00fckl\u00fc kahvenin rengi ayn\u0131d\u0131r. So\u011fuk versiyonu \u0130talya\'dan \u00f6nce ABD\'de 1990\'larda yayg\u0131nla\u015ft\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        'Vanilya sinir sistemini sakinle\u015ftirir',
        'S\u00fct kalsiyum i\u00e7erir',
        'G\u00fc\u00e7l\u00fc espresso odaklanmay\u0131 art\u0131r\u0131r',
        'Yaz i\u00e7in ideal serinlik'
      ],
      cons: [
        'Kafein hassasiyeti olanlar dikkatli olmal\u0131',
        'Tam ya\u011fl\u0131 s\u00fctle kalori artar'
      ],
      tip:
          'Vanilya \u015furubunu az eklersen kahvenin ger\u00e7ek aromas\u0131 \u00f6ne \u00e7\u0131kar.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Espresso (30 ml)\n2. Vanilya \u015furubu (2 yemek ka\u015f\u0131\u011f\u0131)\n3. So\u011fuk s\u00fct (150 ml)\n4. Buz (1 fincan)\n5. \u00c7\u0131rp\u0131lm\u0131\u015f krem (\u015f\u00fcsleme)\n\nYap\u0131l\u0131\u015f:\n1) Espresso ve vanilya \u015furubunu ekle\n2) Buz dolu barda\u011fa d\u00f6k\n3) So\u011fuk s\u00fctu yava\u015f\u00e7a ekle\n4) \u00dczerine krem ekle\n5) Kakao tozu serpiip servis et',
      ingredients: ['espresso', 's\u00fct', 'vanilya', 'buz'],
      imageUrl: 'Assets/Categories/kahve/vanilla ıced cappuccino.jpg',
      gradient: LinearGradient(colors: [Color(0xFFF5DEB3), Color(0xFFD2B48C)]),
    ),
    DrinkModel(
      id: 'lavender-latte',
      title: 'Lavender Latte',
      category: 'Kahve',
      description:
          'Lavanta notalar\u0131 ile hafif, \u00e7i\u00e7eksi s\u0131cak latte.',
      history:
          'Lavanta kahveye ilk kez 2000\'li y\u0131llar\u0131n ba\u015f\u0131nda Portlandl\u0131 k\u00fc\u00e7\u00fck roasterlar taraf\u0131ndan eklendi. Provence aromas\u0131 ve Instagram estetigiyle 2015\'ten itibaren d\u00fcnya genelinde trend oldu.',
      temperature: 'S\u0131cak',
      pros: [
        'Lavanta stres ve kayg\u0131y\u0131 azalt\u0131r',
        'Antioksidan bak\u0131m\u0131ndan zengin',
        '\u00c7i\u00e7eksi aroma serotonin salg\u0131s\u0131n\u0131 uyar\u0131r'
      ],
      cons: [
        '\u015eiddetli lavanta ba\u015f a\u011fr\u0131s\u0131 yapabilir',
        'Lavanta \u015furubu bulunabilirli\u011fi s\u0131n\u0131rl\u0131'
      ],
      tip:
          'Ak\u015fam saatlerinde m\u00fckemmeldir; lavantanin rahatlatici etkisi uykuya geci\u015fi kolayla\u015ft\u0131r\u0131r.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Espresso (30 ml)\n2. Lavanta \u015furubu (2 yemek ka\u015f\u0131\u011f\u0131)\n3. S\u00fct (150 ml)\n4. Bal (1 \u00e7ay ka\u015f\u0131\u011f\u0131)\n5. Kurutulmu\u015f lavanta (s\u00fcsleme)\n\nYap\u0131l\u0131\u015f:\n1) Espresso ve lavanta \u015furubunu ekle\n2) S\u00fctu 60\u00b0C de isi\u0131t\n3) Yava\u015f\u00e7a ekle\n4) K\u00f6p\u00fcrterek servis et',
      ingredients: ['espresso', 's\u00fct', 'lavanta', 'bal'],
      imageUrl: 'Assets/Categories/kahve/lavender latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFF927FA0), Color(0xFFC9D6FF)]),
    ),
    DrinkModel(
      id: 'citrus-cold-brew',
      title: 'Citrus Cold Brew',
      category: 'Kahve',
      description:
          'Taze turun\u00e7gil ve so\u011fuk demleme kahvenin ferah bulu\u015fmas\u0131.',
      history:
          'Turun\u00e7gil ve kahve kombinasyonu Arap kahve k\u00fclt\u00fcr\u00fcnde y\u00fczy\u0131llard\u0131r yer almaktayd\u0131; portakal kabu\u011fu ile \u00e7ekilen T\u00fcrk kahvesi bunun en eski \u00f6rne\u011fidir.',
      temperature: 'So\u011fuk',
      pros: [
        'C vitamini ba\u011f\u0131\u015f\u0131kl\u0131\u011f\u0131 g\u00fc\u00e7lendirir',
        'Turun\u00e7gil asidi ya\u011f yak\u0131m\u0131n\u0131 destekler',
        'Serinletici ve ferahlatici'
      ],
      cons: [
        'Asit refl\u00fcs\u00fc olanlar dikkatli olmali',
        'Haz\u0131rl\u0131k uzun s\u00fcrer'
      ],
      tip:
          'Sabah spordan \u00f6nce i\u00e7ersen enerjik bir ba\u015flang\u0131\u00e7 yapar.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Cold brew (150 ml)\n2. Portakal suyu (100 ml)\n3. Limon suyu (1 \u00e7ay ka\u015f\u0131\u011f\u0131)\n4. S\u00fct (50 ml)\n5. Buz (1 fincan)\n\nYap\u0131l\u0131\u015f:\n1) Buz ekle\n2) Cold brew ekle\n3) Meyve sular\u0131n\u0131 kar\u0131\u015ft\u0131r\n4) S\u00fctu ekle\n5) Portakal dilimi ile s\u00fcsle',
      ingredients: ['cold brew', 'portakal', 'buz', '\u015feker'],
      imageUrl: 'Assets/Categories/kahve/citrus cold brew.png',
      gradient: LinearGradient(colors: [Color(0xFF0B486B), Color(0xFFF56217)]),
    ),
    DrinkModel(
      id: 'pistachio-cold-brew',
      title: 'Pistachio Cold Brew',
      category: 'Kahve',
      description:
          'Pistasya ve so\u011fuk demlenmi\u015f kahvenin m\u00fchte\u015fem uyumu.',
      history:
          'Pistasya\'n\u0131n kahveyle bulu\u015fmas\u0131 Orta Do\u011fu mutfa\u011f\u0131ndan ilham al\u0131r. Starbucks\'\u0131n 2021\'de men\u00fcye ald\u0131\u011f\u0131 Pistachio Latte k\u00fcresel bir \u00e7\u0131lg\u0131nl\u0131k yaratt\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        'Pistasya protein ve sa\u011fl\u0131kl\u0131 ya\u011f i\u00e7erir',
        'Antioksidan a\u00e7\u0131s\u0131ndan g\u00fc\u00e7l\u00fc',
        'Hafizay\u0131 ve odaklanmay\u0131 destekler'
      ],
      cons: [
        'F\u0131stik alerjisi olanlar i\u00e7in uygun de\u011fil',
        'Pistasya \u015furubu \u015feker i\u00e7erir',
        'Pahal\u0131 bir i\u00e7ecek'
      ],
      tip: '\u00d6\u011fle molas\u0131nda sindirim destekler.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Cold brew (150 ml)\n2. Pistasya \u015furubu (2 yemek ka\u015f\u0131\u011f\u0131)\n3. So\u011fuk s\u00fct (100 ml)\n4. Buz\n5. Pistasya par\u00e7alar\u0131 (s\u00fcsleme)\n\nYap\u0131l\u0131\u015f:\n1) Buz dolu barda\u011fa cold brew d\u00f6k\n2) \u015eurub ekle\n3) S\u00fctu yava\u015f\u00e7a ekle\n4) Pistasya ile servis et',
      ingredients: ['cold brew', 'pistasya \u015furubu', 's\u00fct', 'buz'],
      imageUrl: 'Assets/Categories/kahve/pistachio cold brew.jpg',
      gradient: LinearGradient(colors: [Color(0xFF8FBC8F), Color(0xFF4B2C20)]),
    ),
    DrinkModel(
      id: 'vietnamese-iced-coffee',
      title: 'Vietnamese Iced Coffee',
      category: 'Kahve',
      description:
          'Yo\u011fun, tatl\u0131 ve kremsi Vietnamca so\u011fuk kahve.',
      history:
          'C\u00e0 ph\u00ea s\u1eefa \u0111\u00e1, Frans\u0131z s\u00f6mng\u00fcrge d\u00f6neminde (19. y\u00fczy\u0131l) Vietnam\'a giren kahve k\u00fclt\u00fcr\u00fcn\u00fcn kondense s\u00fctle evrile\u015fmi\u015f halidir. Bug\u00fcn Vietnam\'n ulusal i\u00e7ece\u011fi olarak tan\u0131nmaktad\u0131r.',
      temperature: 'So\u011fuk',
      pros: [
        'Y\u00fcksek kafein; derin konsantrasyon sa\u011flar',
        'Kondense s\u00fct uzun s\u00fcreli enerji verir',
        'Robusta taban\u0131 metabolizmay\u0131 h\u0131zland\u0131r\u0131r'
      ],
      cons: [
        '\u00c7ok y\u00fcksek \u015feker i\u00e7eri\u011fi',
        'Kalori yo\u011fun',
        'Kafein tolerans\u0131 d\u00fc\u015f\u00fck olanlar i\u00e7in fazla g\u00fc\u00e7l\u00fc'
      ],
      tip:
          'A\u011f\u0131r \u00f6\u011fle yeme\u011finin ard\u0131ndan \u00f6\u011fleden sonra uyank\u0131\u0131l\u0131\u011f\u0131n\u0131 zirveye ta\u015f\u0131r.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Filtre kahve (30 ml)\n2. Kondense s\u00fct (3 yemek ka\u015f\u0131\u011f\u0131)\n3. Buz (1 fincan)\n4. S\u0131cak su (150 ml)\n\nYap\u0131l\u0131\u015f:\n1) Kondense s\u00fctu barda\u011fa d\u00f6k\n2) Filtre yerle\u015ftir\n3) S\u0131cak suyu yava\u015f\u00e7a d\u00f6k\n4) 3-4 dakika damlamasini bekle\n5) Kar\u0131\u015ft\u0131r\n6) So\u011fuk servis et',
      ingredients: ['filtre kahve', 'kondense s\u00fct', 'buz', 'su'],
      imageUrl: 'Assets/Categories/kahve/vietnamese ıced coffee.jpg',
      gradient: LinearGradient(colors: [Color(0xFF3E2723), Color(0xFF8D6E63)]),
    ),
    DrinkModel(
      id: 'affogato',
      title: 'Affogato',
      category: 'Kahve',
      description:
          'S\u0131cak espresso ile vanilya dondurmaya d\u00f6k\u00fcl\u00fcyor.',
      history:
          '"Bo\u011fulmu\u015f" anlam\u0131na gelen affogato, \u0130talya\'da 1990\'larda ortaya \u00e7\u0131kt\u0131. Hem tatl\u0131 hem kahve i\u015flevi g\u00f6rmesiyle \u0130talyan yemek k\u00fclt\u00fcr\u00fcn\u00fcn en zekice bulu\u015flar\u0131ndan biridir.',
      temperature: 'S\u0131cak',
      pros: [
        'Minimum malzemeyle maksimum lezzet',
        'Espresso polifenolleri i\u00e7erir',
        'Dessert ve kahveyi birle\u015ftirir'
      ],
      cons: [
        'Y\u00fcksek kalori',
        'H\u0131zl\u0131 tüketilmeli (erir)',
        'Laktoz intolerans\u0131 olanlar için uygun de\u011fil'
      ],
      tip:
          'Espresso 30 saniye dinlendirilerek dökülmeli; kaynar su dondurmay\u0131 an\u0131nda eritir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Vanilya dondurmas\u0131 (2 ka\u015f\u0131k)\n2. Taze demlenmi\u015f espresso\n\nYap\u0131l\u0131\u015f:\n1) Kaseye dondurmayi koy\n2) \u00dczerine sicak espressoyu gezdir',
      ingredients: ['espresso', 'vanilya dondurmasi'],
      imageUrl: 'Assets/Categories/kahve/affogato.jpg',
      gradient: LinearGradient(colors: [Color(0xFF8B4513), Color(0xFFF4A460)]),
    ),
    DrinkModel(
      id: 'tiramisu-latte',
      title: 'Tiramisu Latte',
      category: 'Kahve',
      description: 'Tiramisu aromas\u0131 ile zarif s\u0131cak kahve.',
      history:
          'Tiramisu 1960\'larda Veneto b\u00f6lgesinde yarat\u0131ld\u0131; ad\u0131 "beni yukar\u0131 \u00e7ek" demektir. Latte versiyonu, klasik tatl\u0131n\u0131n lezzetini i\u00e7ece\u011fe ta\u015f\u0131ma giri\u015fimiyle 2010\'lu y\u0131llarda Third Wave kafelerde pop\u00fclerle\u015fti.',
      temperature: 'S\u0131cak',
      pros: [
        'Mascarpone protein ve kalsiyum i\u00e7erir',
        'Kokulu aromas\u0131yla ruh halini y\u00fckseltir',
        'Espresso enerjisi ve kakao antioksidanlar\u0131'
      ],
      cons: [
        'Y\u00fcksek ya\u011f ve kalori',
        'Haz\u0131r \u015furup yapay tatlar i\u00e7erebilir'
      ],
      tip:
          'Tatl\u0131 yemek istemeyip tatl\u0131 tatlar ararken m\u00fckemmel bir alternatif.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Espresso\n2. Tiramisu \u015furubu\n3. S\u00fct\n\nYap\u0131l\u0131\u015f:\n1) Espresso ve \u015furubu kar\u0131\u015ft\u0131r\n2) Is\u0131t\u0131lm\u0131\u015f s\u00fctu ekle\n3) \u00dczerine kakao serp',
      ingredients: [
        'espresso',
        's\u00fct',
        'tiramisu \u015furubu',
        'mascarpone'
      ],
      imageUrl: 'Assets/Categories/kahve/tramisu latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFFA0826D), Color(0xFFF5DEB3)]),
    ),
    // ── MATCHA ────────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'matcha-latte',
      title: 'Matcha Latte',
      category: 'Matcha',
      description: 'Klasik s\u0131cak matcha latte, kremsi ve tatmin edici.',
      history:
          'Matcha, 12. y\u00fczy\u0131lda \u00c7in\'den Japonya\'ya ta\u015f\u0131nan toz \u00e7ay gelene\u011finin \u00fcr\u00fcn\u00fcd\u00fcr. Zen Budizm manast\u0131rlar\u0131nda meditasyon \u00f6ncesi i\u00e7ilirdi. Matcha latte ise Bat\u0131\'da 2000\'li y\u0131llarda sa\u011fl\u0131k trendi ile birlikte pop\u00fclerle\u015fti.',
      temperature: 'S\u0131cak',
      pros: [
        'L-theanine ile sakin ve odakl\u0131 enerji',
        'Klorofil antioksidan zengini',
        'Kafein yava\u015f sal\u0131n\u0131r; \u00e7\u00f6k\u00fc\u015f ya\u015fatmaz',
        'Detoks ve metabolizma deste\u011fi'
      ],
      cons: [
        'Kaliteli matcha pahali',
        'Y\u00fcksek tannin demir emilimini azaltabilir',
        'Yanl\u0131\u015f haz\u0131rlan\u0131rsa ac\u0131 olabilir'
      ],
      tip:
          'Tozu 80\u00b0C suyla a\u00e7; kaynar su matchay\u0131 ac\u0131la\u015ft\u0131r\u0131r.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Matcha tozu (1 \u00e7ay ka\u015f\u0131\u011f\u0131)\n2. S\u0131cak su (50 ml)\n3. S\u00fct (150 ml)\n\nYap\u0131l\u0131\u015f:\n1) Matcha tozunu s\u0131cak suyla p\u00fcr\u00fcss\u00fcz olana kadar kar\u0131\u015ft\u0131r\n2) Is\u0131t\u0131lm\u0131\u015f s\u00fctu ekle\n3) K\u00f6p\u00fcrterek s\u0131cak servis et',
      ingredients: ['matcha tozu', 's\u00fct', '\u015feker', 'su'],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF116E3C), Color(0xFF8FBC8F)]),
    ),
    DrinkModel(
      id: 'iced-matcha-latte',
      title: 'Iced Matcha Latte',
      category: 'Matcha',
      description: 'So\u011fuk, kremsi ve ferah matcha latte.',
      history:
          'So\u011fuk matcha latte Tokyo\'nun hipster kafelerinde 2015\'te do\u011fdu; Instagram estetiği ve sa\u011fl\u0131k bilinci ayn\u0131 anda patlama yapt\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        'Yaz aylar\u0131nda so\u011fuk enerji boost',
        'L-theanine + kafein kombinasyonu',
        'Parlak ye\u015fil rengi mood\'u y\u00fckseltir'
      ],
      cons: [
        'Taze haz\u0131rlanmal\u0131d\u0131r',
        'S\u00fct se\u00e7imi aromay\u0131 etkiler'
      ],
      tip:
          'Yulaf s\u00fctu ile yap\u0131l\u0131rsa do\u011fal tatl\u0131l\u0131k artar.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Matcha tozu (1 \u00e7ay ka\u015f\u0131\u011f\u0131)\n2. S\u0131cak su (50 ml)\n3. Buz\n4. So\u011fuk s\u00fct (150 ml)\n\nYap\u0131l\u0131\u015f:\n1) Matcha tozunu suyla a\u00e7\n2) Buz dolu barda\u011fa d\u00f6k\n3) So\u011fuk s\u00fctu ekleyerek servis et',
      ingredients: ['matcha tozu', 's\u00fct', 'buz', 'bal'],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF3CA55C), Color(0xFF7FB069)]),
    ),
    DrinkModel(
      id: 'matcha-white-chocolate',
      title: 'Matcha White Chocolate',
      category: 'Matcha',
      description:
          'Beyaz \u00e7ikolata ve matcha\'n\u0131n zarif kombinasyonu.',
      history:
          'Beyaz \u00e7ikolata ve matcha kombinasyonu Japonya\'daki wagashi gelene\u011finden ilham al\u0131r. Kyoto\'nun ye\u015fil \u00e7ay tatl\u0131lar\u0131 aras\u0131nda en \u00fcnl\u00fcs\u00fc bu ikilidur.',
      temperature: 'S\u0131cak',
      pros: [
        'Beyaz \u00e7ikolata kalsiyum i\u00e7erir',
        'Matcha antioksidanlar\u0131 ile dengelenir',
        'Zengin ve kadifemsi doku'
      ],
      cons: [
        'Y\u00fcksek \u015feker ve kalori',
        'Diyabetiklere \u00f6nerilmez'
      ],
      tip: 'Hediye olarak sunulabilecek en \u015fik s\u0131cak i\u00e7ecek.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Matcha tozu\n2. Eritilmi\u015f beyaz \u00e7ikolata\n3. S\u0131cak s\u00fct\n\nYap\u0131l\u0131\u015f:\n1) Beyaz \u00e7ikolatay\u0131 erit\n2) Matcha ve s\u0131cak s\u00fctle birle\u015ftir\n3) S\u0131cak servis et',
      ingredients: [
        'matcha tozu',
        'beyaz \u00e7ikolata',
        's\u00fct',
        'vanilya'
      ],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF3CA55C), Color(0xFFF5F5DC)]),
    ),
    DrinkModel(
      id: 'matcha-mango-smoothie',
      title: 'Matcha Mango Smoothie',
      category: 'Matcha',
      description:
          'Egzotik mango ve ye\u015fil matcha\'n\u0131n tropikal birle\u015fimi.',
      history:
          'Tropikal meyve ve matcha kar\u0131\u015f\u0131m\u0131 Bali\'nin wellness kafelerinde do\u011fdu. Endonezya ve Japonya k\u00fclt\u00fcrlerinin kesi\u015fim noktas\u0131nda ortaya \u00e7\u0131kan bu i\u00e7ecek, digital nomad topluluklar\u0131yla k\u00fcreselle\u015fti.',
      temperature: 'So\u011fuk',
      pros: [
        'Mango C vitamini ve beta-karoten i\u00e7erir',
        'Matcha L-theanine ile dengeli enerji',
        'Y\u00fcksek lif; tokluk hissi verir'
      ],
      cons: [
        '\u015eeker i\u00e7eri\u011fi y\u00fcksek',
        'Dondurulmu\u015f mango aromay\u0131 zay\u0131flatir'
      ],
      tip: 'Sabah kahvalt\u0131s\u0131 yerini tutabilir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Matcha\n2. Mango\n3. Hindistancevizi s\u00fctu\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda buzla birlikte p\u00fcr\u00fcss\u00fcz olana kadar \u00e7ekin',
      ingredients: [
        'matcha tozu',
        'mango',
        'yo\u011furt',
        'hindistancevizi s\u00fctu',
        'buz'
      ],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF3CA55C), Color(0xFFF7971E)]),
    ),
    DrinkModel(
      id: 'matcha-hibiscus-cooler',
      title: 'Matcha Hibiscus Cooler',
      category: 'Matcha',
      description:
          'Matcha ve hibiskus \u00e7ay\u0131n\u0131n serinletici bulu\u015fmas\u0131.',
      history:
          'Hibiskus M\u0131s\u0131r ve Afrika geleneksel t\u0131bb\u0131nda y\u00fczy\u0131llard\u0131r kullan\u0131lmaktad\u0131r. Bu \u00e7i\u00e7e\u011fi matcha ile bulu\u015fturan konsept 2020\'lerin yarat\u0131c\u0131 barista d\u00fcnyas\u0131ndan do\u011fmu\u015f modern bir icat.',
      temperature: 'So\u011fuk',
      pros: [
        'Hibiskus tansiyonu d\u00fc\u015f\u00fcr\u00fcr',
        'G\u00f6rsel olarak nefes kesici',
        '\u015eekersiz haz\u0131rlanabilir'
      ],
      cons: [
        'Kan inceltici ila\u00e7 kullananlar dikkatli olmal\u0131',
        'Hibiskus asidi di\u015f minesini etkileyebilir'
      ],
      tip: 'S\u0131cak yaz g\u00fcnlerinde serinlemek i\u00e7in birebir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Matcha\n2. Demlenmis hibiskus \u00e7ay\u0131\n3. Buz\n\nYap\u0131l\u0131\u015f:\n1) Barda\u011f\u0131n alt\u0131na buz ve hibiskus \u00e7ay\u0131n\u0131 koy\n2) \u00dczerine matcha kar\u0131\u015f\u0131m\u0131n\u0131 yava\u015f\u00e7a ekle',
      ingredients: ['matcha tozu', 'hibiskus', 'limon', '\u015feker', 'buz'],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF3CA55C), Color(0xFFB31217)]),
    ),
    // ── KOKTEYL ───────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'espresso-martini',
      title: 'Espresso Martini',
      category: 'Kokteyl',
      description: 'Kafein enerjisi ile ak\u015fam kokteyeli bulu\u015fuyor.',
      history:
          '1983 y\u0131l\u0131nda Londra\'da Dick Bradsell, bir s\u00fcper modelin "beni uyand\u0131r sonra i\u00e7ki getir" iste\u011fi \u00fczerine bu kokteyeli yaratt\u0131. Vodka, espresso ve kahve lik\u00f6r\u00fcn\u00fcn bulu\u015fmas\u0131 k\u0131sa s\u00fcrede ikonik bir i\u00e7ece\u011fe d\u00f6n\u00fc\u015ft\u00fc.',
      temperature: 'So\u011fuk',
      pros: [
        'Espresso ile an\u0131nda enerji y\u00fcklemesi',
        'Sosyal ortamlar i\u00e7in ideal',
        'Parlak k\u00f6p\u00fc\u011f\u00fc g\u00f6rsel olarak etkileyici'
      ],
      cons: [
        'Alkol i\u00e7erir',
        'Kafein + alkol uyku d\u00fczenini bozabilir',
        'Y\u00fcksek kalori'
      ],
      tip:
          'G\u00fc\u00e7l\u00fc bir espresso kullan; shakeri 15 saniye kuvvetlice \u00e7alk.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Espresso\n2. Vodka\n3. Kahve lik\u00f6r\u00fc\n4. \u015eeker \u015furubu\n5. Buz\n\nYap\u0131l\u0131\u015f:\n1) Shakera t\u00fcm malzemeleri ekle\n2) Buz ekle\n3) G\u00fc\u00e7l\u00fc sallayarak k\u00f6p\u00fck elde et\n4) Soğuk barda\u011fa s\u00fcz\n5) Kahve \u00e7ekirde\u011fi ile servis et',
      ingredients: [
        'espresso',
        'vodka',
        'kahve lik\u00f6r\u00fc',
        '\u015feker \u015furubu'
      ],
      imageUrl: 'Assets/Categories/kokteyl/espresso martini.png',
      gradient: LinearGradient(colors: [Color(0xFF2C1E1E), Color(0xFF5A3A3A)]),
    ),
    DrinkModel(
      id: 'matcha-coconut-cooler',
      title: 'Matcha Coconut Cooler',
      category: 'Kokteyl',
      description:
          'Ye\u015fil \u00e7ayla tropikal tatlar\u0131n serinletici bulu\u015fmas\u0131.',
      history:
          'Bali wellness retreat k\u00fclt\u00fcr\u00fcnden ilham alan bu kokteyl, Japonya\'n\u0131n matcha gelene\u011fini Polinezya\'n\u0131n hindistancevizi k\u00fclt\u00fcr\u00fcyle birle\u015ftirir.',
      temperature: 'So\u011fuk',
      pros: [
        'Hindistancevizi MCT ya\u011f i\u00e7erir',
        'Serinletici ve tropikal',
        'Alkol i\u00e7ermez (mocktail)'
      ],
      cons: [
        'Hindistancevizi s\u00fctu kalori yo\u011fun',
        'Taze lime bulunmas\u0131 zaman alabilir'
      ],
      tip:
          'Lime suyunu her seferinde taze s\u0131k; haz\u0131r lime aromas\u0131n\u0131 \u00f6ld\u00fcr\u00fcr.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Matcha tozu\n2. S\u0131cak su (50 ml)\n3. Hindistancevizi s\u00fctu (150 ml)\n4. Lime suyu\n5. \u015eeker\n6. Buz\n7. Nane (s\u00fcsleme)\n\nYap\u0131l\u0131\u015f:\n1) Matchay\u0131 s\u0131cak suyla a\u00e7\n2) Hindistancevizi s\u00fctu ekle\n3) Lime ve \u015feker ekle\n4) Buz dolu barda\u011fa d\u00f6k\n5) Nane ile s\u00fcsle',
      ingredients: ['matcha', 'hindistancevizi s\u00fctu', 'lime', 'buz'],
      imageUrl: 'Assets/Categories/kokteyl/matcha coconut cooler.png',
      gradient: LinearGradient(colors: [Color(0xFF3CA55C), Color(0xFFB5AC49)]),
    ),
    DrinkModel(
      id: 'strawberry-daiquiri',
      title: 'Strawberry Daiquiri',
      category: 'Kokteyl',
      description: '\u00c7ilekli, serinletici ve zarif bir kokteyl.',
      history:
          'Daiquiri 1890\'larda K\u00fcba\'da ke\u015ffedildi. \u00c7ilek versiyonu 1930\'lardaki Havana barlar\u0131nda pop\u00fclerle\u015fti. Ernest Hemingway bu kokteylin \u00f6n\u00fcnde uzun saatler harcad\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        '\u00c7ilek C vitamini a\u00e7\u0131s\u0131ndan zengin',
        'Serinletici ve hafif',
        'G\u00f6rsel olarak \u00e7arp\u0131c\u0131'
      ],
      cons: [
        'Alkol i\u00e7erir',
        'Y\u00fcksek \u015feker',
        'Taze \u00e7ilek gerektirir'
      ],
      tip:
          'Taze \u00e7ilek kullan; dondurulmu\u015f \u00e7ilek daha az aromatik.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. \u00c7ilek (250 g)\n2. Rom (45 ml)\n3. Limon suyu\n4. \u015eeker \u015furubu\n5. Buz\n\nYap\u0131l\u0131\u015f:\n1) Blenderda \u00e7ilekleri koy\n2) Rom, limon, \u015feker ekle\n3) Buzla kar\u0131\u015ft\u0131r\n4) Martini barda\u011f\u0131na d\u00f6k\n5) \u00c7ilek dilimi ile servis et',
      ingredients: ['\u00e7ilek', 'rom', 'limon', '\u015feker', 'buz'],
      imageUrl: 'Assets/Categories/kokteyl/strawbery daiquiri.png',
      gradient: LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF69B4)]),
    ),
    DrinkModel(
      id: 'pina-colada',
      title: 'Pina Colada',
      category: 'Kokteyl',
      description: 'Ananas ve hindistancevizi kremiyla tropikal efsane.',
      history:
          '1954 y\u0131l\u0131nda San Juan\'da Caribe Hilton\'da icat edildi. 1978\'de Porto Riko\'nun ulusal i\u00e7ece\u011fi ilan edildi.',
      temperature: 'So\u011fuk',
      pros: [
        'Ananas C vitamini i\u00e7erir',
        'Hindistancevizi sa\u011fl\u0131kl\u0131 ya\u011flar i\u00e7erir',
        'Tropikal ruh hali yarat\u0131r'
      ],
      cons: [
        '\u00c7ok y\u00fcksek kalori',
        'Alkol i\u00e7erir',
        'Doymu\u015f ya\u011f i\u00e7erir'
      ],
      tip:
          'Taze ananas suyu haz\u0131r olan\u0131n 3 kat\u0131 aromaya sahiptir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Ananas suyu (150 ml)\n2. Hindistancevizi kremi (90 ml)\n3. Rom (45 ml)\n4. Buz\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda 40 saniye kar\u0131\u015ft\u0131r\n2) Barda\u011fa d\u00f6k\n3) Ananas dilimi ile servis et',
      ingredients: ['ananas suyu', 'hindistancevizi krem', 'rom', 'buz'],
      imageUrl: 'Assets/Categories/kokteyl/pina colada.png',
      gradient: LinearGradient(colors: [Color(0xFFFFA500), Color(0xFFFFFACD)]),
    ),
    // ── FROZEN ────────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'cocoa-frozen-latte',
      title: 'Cocoa Frozen Latte',
      category: 'Frozen',
      description: 'So\u011fuk, kremsi ve bitter tatl\u0131 bir deneyim.',
      history:
          'Frozen i\u00e7ecekler 1960\'larda ABD\'de Slurpee ile birlikte do\u011fdu. Frozen latte Frappuccino patentiyle Starbucks\'\u0131n 1995 y\u0131l\u0131nda d\u00fcnyaya armagan etti\u011fi konforlu i\u00e7ecektir.',
      temperature: 'So\u011fuk',
      pros: [
        'Kakao magnezyum ve flavonoid i\u00e7erir',
        'S\u0131cak g\u00fcnlerde an\u0131nda serinleme',
        'Hem kahve hem \u00e7ikolata aromas\u0131'
      ],
      cons: [
        'Y\u00fcksek kalori',
        'Haz\u0131r kakao \u015feker i\u00e7erebilir',
        '\u00c7ok so\u011fuk i\u00e7ilirse ba\u015f a\u011fr\u0131s\u0131 yapabilir'
      ],
      tip:
          'Yava\u015f yava\u015f i\u00e7. %70+ kakao tozu tatmin edici ac\u0131l\u0131k katar.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Buz (1 fincan)\n2. S\u00fct (200 ml)\n3. Kakao tozu (2 yemek ka\u015f\u0131\u011f\u0131)\n4. Vanilya ekstresi\n5. \u00c7ikolata par\u00e7alar\u0131\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda p\u00fcr\u00fcss\u00fcz olana kadar kar\u0131\u015ft\u0131r\n2) Barda\u011fa d\u00f6k\n3) \u00c7ikolata par\u00e7alar\u0131 ile s\u00fcsle',
      ingredients: ['buz', 's\u00fct', 'kakao tozu', 'vanilya ekstresi'],
      imageUrl: 'Assets/Categories/frozen/cocoa frozen latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFF20002C), Color(0xFFC58E25)]),
    ),
    DrinkModel(
      id: 'tropical-frozen-mojito',
      title: 'Tropical Frozen Mojito',
      category: 'Frozen',
      description: 'Ananas, mango ve nane ile tropikal donmu\u015f mojito.',
      history:
          'Mojito 16. y\u00fczy\u0131lda Havana\'da ortaya \u00e7\u0131kt\u0131. Frozen mojito 1980\'lerin Miami barlar\u0131nda do\u011fdu.',
      temperature: 'So\u011fuk',
      pros: [
        'Nane sindirim sistemini rahatlatir',
        'Ananas C vitamini kayna\u011f\u0131',
        'Alkol i\u00e7ermeyen versiyonu m\u00fckemmel'
      ],
      cons: ['Alkolle kalori fazla', 'Taze nane temin etmek zaman al\u0131r'],
      tip: 'Naneyi \u00e7ok ezmemek gerekir; hafif\u00e7e dokunmak yeterlidir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Ananas\n2. Mango\n3. Nane\n4. Lime\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm meyveleri ve naneyi buzla blenderda \u00e7ekin\n2) Ferahlatici bir kadehte servis edin',
      ingredients: ['ananas', 'mango', 'nane', 'lime', 'soda', 'buz'],
      imageUrl: 'Assets/Categories/frozen/tropical frozen mojito.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFFA500), Color(0xFF90EE90)]),
    ),
    DrinkModel(
      id: 'mango-sorbet',
      title: 'Mango Sorbet',
      category: 'Frozen',
      description: 'Donmu\u015f mango sorbeti, hafif ve ferah.',
      history:
          'Sorbet Orta Do\u011fu\'dan Osmanl\u0131 saraylar\u0131 arac\u0131l\u0131\u011f\u0131yla Avrupa\'ya ta\u015f\u0131nd\u0131; ad\u0131 Arap\u00e7a "\u015ferbet"ten gelir.',
      temperature: 'So\u011fuk',
      pros: [
        'Laktoz i\u00e7ermez; vegan dostu',
        'Mango beta-karoten ve C vitamini i\u00e7erir',
        'D\u00fc\u015f\u00fck ya\u011f i\u00e7eri\u011fi'
      ],
      cons: [
        'Y\u00fcksek do\u011fal \u015feker',
        'Diyabet kontrol alt\u0131ndaysa dikkat'
      ],
      tip:
          'Portakal suyu ile haz\u0131rlan\u0131rsa \u015feker eklemeye gerek kalmaz.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Mango (250 g)\n2. Portakal suyu (100 ml)\n3. Zencefil\n4. Limon suyu\n\nYap\u0131l\u0131\u015f:\n1) Blenderda mango koy\n2) Di\u011fer malzemeleri ekle\n3) Yumusak k\u0131vama kadar kar\u0131\u015ft\u0131r\n4) Taze mango dilimiyle servis et',
      ingredients: ['mango', 'portakal suyu', 'zencefil'],
      imageUrl: 'Assets/Categories/frozen/mango sorbet.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFFA500), Color(0xFFFFD700)]),
    ),
    // ── SMOOTHIE ──────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'strawberry-basil-smoothie',
      title: 'Strawberry Basil Smoothie',
      category: 'Smoothie',
      description:
          '\u00c7ilek, fesley\u011fen ve yo\u011furdun serinletici kar\u0131\u015f\u0131m\u0131.',
      history:
          'Smoothie kavram\u0131 1930\'larda Bat\u0131 K\u0131y\u0131s\u0131 ABD\'de sa\u011fl\u0131k g\u0131da d\u00fckkanlar\u0131nda do\u011fdu. Fesle\u011fen ve \u00e7ilek kombinasyonu \u0130talyan mutfak gelene\u011fine dayan\u0131r.',
      temperature: 'So\u011fuk',
      pros: [
        '\u00c7ilek antioksidan ve C vitamini deposu',
        'Fesle\u011fen antibakteriyal etki g\u00f6sterir',
        'Yo\u011furt probiyotik i\u00e7erir'
      ],
      cons: [
        'Taze fesle\u011fen \u00e7abuk solar',
        '\u00c7ok fesle\u011fen ac\u0131l\u0131k yapabilir'
      ],
      tip:
          'Sabah kahvalt\u0131s\u0131n\u0131 atlayan ki\u015filer i\u00e7in m\u00fckemmel.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. \u00c7ilek (250 g)\n2. Yo\u011furt (150 g)\n3. Fesle\u011fen yapraklar\u0131\n4. Bal\n5. Buz\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda p\u00fcr\u00fcss\u00fcz kana kadar kar\u0131\u015ft\u0131r\n2) Hemen so\u011fuk servis et',
      ingredients: ['\u00e7ilek', 'yo\u011furt', 'fesle\u011fen', 'bal'],
      imageUrl: 'Assets/Categories/smoothie/strawberry basil smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFFED213A), Color(0xFFFFA500)]),
    ),
    DrinkModel(
      id: 'mango-lassi',
      title: 'Mango Lassi',
      category: 'Smoothie',
      description:
          'Egzotik mango ve yo\u011furdun tazeleyici bulu\u015fmas\u0131.',
      history:
          'Lassi 2500 y\u0131l \u00f6nce Punjab b\u00f6lgesinde ortaya \u00e7\u0131kt\u0131. Mango versiyonu 20. y\u00fczy\u0131lda yayg\u0131nla\u015ft\u0131 ve bug\u00fcn Hindistan\'n en sevilen ulusal i\u00e7ece\u011fi.',
      temperature: 'So\u011fuk',
      pros: [
        'Probiyotik yo\u011furt ba\u011f\u0131rsak floras\u0131n\u0131 destekler',
        'Mango A ve C vitamini i\u00e7erir',
        'Baharatl\u0131 yemekleri dengeler'
      ],
      cons: [
        'Y\u00fcksek kalori ve \u015feker',
        'Laktoz intolerans\u0131 olanlar i\u00e7in s\u0131n\u0131rl\u0131'
      ],
      tip:
          'Kuzey Hintli gelenekte kahvalt\u0131da i\u00e7ilir. Baharatl\u0131 yemeklerin yan\u0131na \u00e7ok yak\u0131\u015fir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Mango\n2. Yo\u011furt (200 g)\n3. So\u011fuk s\u00fct (100 ml)\n4. Tar\u00e7\u0131n\n5. Bal\n6. Buz\n\nYap\u0131l\u0131\u015f:\n1) Mango etini blenderda koy\n2) T\u00fcm malzemeleri ekle\n3) P\u00fcr\u00fcss\u00fcz k\u0131vama kadar kar\u0131\u015ft\u0131r',
      ingredients: ['mango', 'yo\u011furt', 's\u00fct', 'bal'],
      imageUrl: 'Assets/Categories/smoothie/mango lassi.jpg',
      gradient: LinearGradient(colors: [Color(0xFFF7971E), Color(0xFFFFD200)]),
    ),
    DrinkModel(
      id: 'acai-blueberry-smoothie',
      title: 'Acai Blueberry Smoothie',
      category: 'Smoothie',
      description: 'Acai ve blueberry ile antioksidan dolu bir smoothie.',
      history:
          'Acai meyvesi y\u00fczy\u0131llard\u0131r Amazon b\u00f6lgesi yerlileri taraf\u0131ndan "ya\u015fam meyvesi" olarak t\u00fcketilmekteydi. Bat\u0131 d\u00fcnyas\u0131na 1990\'lar\u0131n sonunda Brezilya s\u00f6rf k\u00fclt\u00fcr\u00fcyle girdi.',
      temperature: 'So\u011fuk',
      pros: [
        'Acai ola\u011fanüst\u00fc antioksidan kapasitesi',
        'Yaban mersini beyin fonksiyonlar\u0131n\u0131 destekler',
        'Kalp sa\u011fl\u0131\u011f\u0131na katk\u0131'
      ],
      cons: [
        'Taze acai pahal\u0131 ve bulunmas\u0131 zor',
        'Dondurulmu\u015f besin de\u011ferini k\u0131smen yitirir'
      ],
      tip: 'Sabah egzersizi sonras\u0131 kas iyile\u015fmesi i\u00e7in ideal.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Acai\n2. Yaban mersini\n3. Yo\u011furt\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda buzla p\u00fcr\u00fcss\u00fcz olana kadar \u00e7ekin',
      ingredients: [
        'acai',
        'blueberry',
        'yo\u011furt',
        'hindistancevizi s\u00fctu',
        'bal'
      ],
      imageUrl: 'Assets/Categories/smoothie/acai blueberry smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B0082), Color(0xFF9370DB)]),
    ),
    // ── SODA ──────────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'hibiscus-sparkler',
      title: 'Hibiscus Sparkler',
      category: 'Soda',
      description:
          'Nar \u00e7i\u00e7e\u011fi ve limonla parlak, serinletici bir soda.',
      history:
          'Hibiskus \u00e7ay\u0131 (karkade) M\u0131s\u0131r\'da firavunlar d\u00f6neminden bu yana t\u00fcketilmektedir. Sudan ve Meksika\'da ulusal i\u00e7ecek stat\u00fcs\u00fcnde olan hibiskus, Bat\u0131\'da 2010\'lu y\u0131llarda craft soda hareketiyle pop\u00fclerlik kazand\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        'Zengin C vitamini kayna\u011f\u0131',
        'Kan bas\u0131nc\u0131n\u0131 d\u00fc\u015f\u00fcr\u00fcr',
        'D\u00fc\u015f\u00fck kalori'
      ],
      cons: [
        'Kan inceltici ila\u00e7larla etkilesebilir',
        'Asit di\u015fleri etkileyebilir'
      ],
      tip: 'G\u00fcn i\u00e7inde su yerine t\u00fcketilebilir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Hibiskus (2 \u00e7ay ka\u015f\u0131\u011f\u0131)\n2. S\u0131cak su (200 ml)\n3. \u015eeker\n4. Limon suyu\n5. Maden suyu\n6. Buz\n\nYap\u0131l\u0131\u015f:\n1) Hibiskusu 5 dk demle\n2) So\u011fut\n3) \u015eeker ve limon ekle\n4) Maden suyu ile servis et',
      ingredients: ['hibiskus', '\u015feker', 'limon suyu', 'maden suyu'],
      imageUrl: 'Assets/Categories/soda/hibiscus sparkler.jpg',
      gradient: LinearGradient(colors: [Color(0xFFB31217), Color(0xFFFCE38A)]),
    ),
    DrinkModel(
      id: 'berry-kombucha',
      title: 'Berry Kombucha',
      category: 'Soda',
      description:
          '\u015eerbetçiotu ferahliğiyla k\u0131rm\u0131z\u0131 meyveli kombucha.',
      history:
          'Kombucha 2000 y\u0131l \u00f6nce \u00c7in\'de "\u00f6l\u00fcms\u00fczl\u00fck \u00e7ay\u0131" olarak biliniyordu. 1900\'lerin ba\u015f\u0131nda Do\u011fu Avrupa \u00fczerinden Bat\u0131\'ya yay\u0131ld\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        'Canl\u0131 probiyotikler ba\u011f\u0131rsak floras\u0131n\u0131 destekler',
        'Do\u011fal karbonasyon',
        'Alkol se\u00e7ene\u011fine lezzetli alternatif'
      ],
      cons: [
        'Haz\u0131r kombucha kalitesi farkl\u0131la\u015f\u0131r',
        'Ba\u011f\u0131\u015f\u0131kl\u0131\u011f\u0131 zay\u0131flamis ki\u015filer i\u00e7in riskli'
      ],
      tip:
          '\u00d6\u011f\u00fcn aralar\u0131nda sindirim s\u00fcrecini destekler.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Kombucha (250 ml)\n2. Frambuaz (100 g)\n3. B\u00f6\u011f\u00fcrtlen (100 g)\n4. Buz\n5. Nane\n\nYap\u0131l\u0131\u015f:\n1) Buz dolu barda\u011fa kombucha d\u00f6k\n2) Meyveler ve nane ekle\n3) Hafif kar\u0131\u015ft\u0131r',
      ingredients: ['kombucha', 'frambuaz', 'b\u00f6\u011f\u00fcrtlen', 'buz'],
      imageUrl: 'Assets/Categories/soda/berry kombucha.png',
      gradient: LinearGradient(colors: [Color(0xFF000428), Color(0xFF004e92)]),
    ),
    DrinkModel(
      id: 'elderflower-lemon-soda',
      title: 'Elderflower Lemon Soda',
      category: 'Soda',
      description:
          'A\u011fa\u00e7kak\u0131s\u0131 ve limonla hafif, baharatl\u0131 soda.',
      history:
          'M\u00fcrver \u00e7i\u00e7e\u011fi nektarı \u0130ngiliz k\u0131rsal mutfa\u011f\u0131nda Victorian d\u00f6neminden beri kullanilmaktad\u0131r. Fever-Tree ve Belvoir markalar\u0131 2000\'li y\u0131llarda bunu premium bir i\u00e7ecek kategorisine ta\u015f\u0131d\u0131.',
      temperature: 'So\u011fuk',
      pros: [
        '\u00c7i\u00e7eksi aroma benzersiz',
        'Do\u011fal anti-inflamatuar',
        '\u00c7ok d\u00fc\u015f\u00fck kalori',
        'Alkol i\u00e7ermez'
      ],
      cons: [
        'M\u00fcrver \u00e7i\u00e7e\u011fi nektar\u0131 bulunmas\u0131 zor',
        'Hassas \u00e7i\u00e7ek aromas\u0131 h\u0131zla bozulabilir'
      ],
      tip:
          'A\u00e7\u0131k hava toplant\u0131lar\u0131n\u0131n ideal i\u00e7ece\u011fi.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. A\u011fa\u00e7kak\u0131s\u0131 nektar\u0131 (3 yemek ka\u015f\u0131\u011f\u0131)\n2. Limon suyu\n3. Maden suyu (200 ml)\n4. Taze nane\n5. Buz\n\nYap\u0131l\u0131\u015f:\n1) Nektar ve limon suyunu kar\u0131\u015ft\u0131r\n2) Maden suyu dök\n3) Limon dilimi ile servis et',
      ingredients: [
        'a\u011fa\u00e7kak\u0131s\u0131 nektar\u0131',
        'limon',
        'maden suyu',
        'nane',
        'buz'
      ],
      imageUrl: 'Assets/Categories/soda/elderflower lemon soda.jpg',
      gradient: LinearGradient(colors: [Color(0xFFE1BEE7), Color(0xFFFCE4EC)]),
    ),
    // ── \u00c7AY ──────────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'orange-spiced-tea',
      title: 'Orange Spiced Tea',
      category: '\u00c7ay',
      description:
          'Tar\u00e7\u0131n ve portakal ile s\u0131cak, aromatik bir \u00e7ay deneyimi.',
      history:
          'Baharatl\u0131 \u00e7ay gelene\u011fi Osmanl\u0131 saraylar\u0131nda k\u00f6klenmi\u015ftir; padi\u015fahlar\u0131n \u00f6zel demliklerinde portakal kabu\u011fu ve tar\u00e7\u0131n bulundu\u011fu bilinmektedir.',
      temperature: 'S\u0131cak',
      pros: [
        'Tar\u00e7\u0131n kan \u015fekerini dengeler',
        'Portakal C vitamini ba\u011f\u0131\u015f\u0131kl\u0131\u011f\u0131 g\u00fc\u00e7lendirir',
        '\u0131s\u0131t\u0131c\u0131 ve rahatlatıcı'
      ],
      cons: [
        'Tar\u00e7\u0131n fazlas\u0131 karaci\u011fere zarar verebilir',
        'Portakal kabu\u011fu ila\u00e7larla etkilesebilir'
      ],
      tip:
          'So\u011fuk alg\u0131nl\u0131\u011f\u0131nda bala a\u011f\u0131r basarak i\u00e7; iyile\u015fmeyi h\u0131zland\u0131r\u0131r.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Siyah \u00e7ay\n2. S\u0131cak su (250 ml)\n3. Tar\u00e7\u0131n \u00e7ubu\u011fu\n4. Portakal kabu\u011fu\n5. Bal\n\nYap\u0131l\u0131\u015f:\n1) \u00c7ay\u0131 tar\u00e7\u0131n ve portakal kabu\u011fuyla 5 dk demle\n2) S\u00fcz\n3) Bal ekle\n4) Portakal dilimi ile servis et',
      ingredients: ['\u00e7ay', 'tar\u00e7\u0131n', 'portakal', 'bal'],
      imageUrl: 'Assets/Categories/çay/orange spiced tea.jpg',
      gradient: LinearGradient(colors: [Color(0xFFD2691E), Color(0xFFFFA500)]),
    ),
    DrinkModel(
      id: 'peach-ginger-tea',
      title: 'Peach Ginger Tea',
      category: '\u00c7ay',
      description:
          '\u015eeftali ve zencefil ile s\u0131cak ve aromatik \u00e7ay.',
      history:
          'Zencefil \u00e7ay\u0131 binlerce y\u0131l \u00f6nce G\u00fcney Asya\'da t\u0131bbi ama\u00e7larla kullan\u0131lmaktayd\u0131. \u015eeftali ile birle\u015fimi modern Amerikan kafeteryalar\u0131nda 2000\'li y\u0131llarda hayat buldu.',
      temperature: 'S\u0131cak',
      pros: [
        'Zencefil mide bulant\u0131s\u0131na kar\u015f\u0131 do\u011fal ila\u00e7',
        '\u015eeftali A vitamini ve antioksidan i\u00e7erir',
        'Ba\u011f\u0131\u015f\u0131kl\u0131k g\u00fc\u00e7lendirici'
      ],
      cons: [
        'Zencefil fazlas\u0131 mide tahri\u015fi yapabilir',
        'Taze \u015feftali mevsimle s\u0131n\u0131rl\u0131'
      ],
      tip:
          'Konsantrasyonu art\u0131r\u0131r, masa ba\u015f\u0131nda \u00e7al\u0131\u015f\u0131rken i\u00e7in.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Siyah \u00e7ay\n2. Taze zencefil\n3. \u015eeftali\n\nYap\u0131l\u0131\u015f:\n1) \u00c7ay\u0131 zencefil dilimleriyle demle\n2) Taze \u015feftali dilimleri ekleyerek servis et',
      ingredients: ['\u00e7ay', '\u015feftali', 'zencefil', 'bal'],
      imageUrl: 'Assets/Categories/çay/peach ginger tea.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFF6F61), Color(0xFFFFB84D)]),
    ),
    // ── F\u0130T ──────────────────────────────────────────────────────────────────
    DrinkModel(
      id: 'protein-banana-shake',
      title: 'Protein Banana Shake',
      category: 'Fit',
      description:
          'Protein tozu ve muzla sa\u011fl\u0131kl\u0131, besleyici bir shake.',
      history:
          'Protein shake k\u00fclt\u00fcr\u00fc 1950\'lerde Arnold Schwarzenegger ve Joe Weider ile birlikte v\u00fccut geli\u015ftirme d\u00fcnyas\u0131nda do\u011fdu.',
      temperature: 'So\u011fuk',
      pros: [
        'Y\u00fcksek protein kas iyile\u015fmesini h\u0131zland\u0131r\u0131r',
        'Muz potasyum i\u00e7erir; kramplar\u0131 \u00f6nler',
        'H\u0131zl\u0131 haz\u0131rlanabilir'
      ],
      cons: [
        'Haz\u0131r protein tozu yapay tatland\u0131r\u0131c\u0131 i\u00e7erebilir',
        'Fazla t\u00fcketim b\u00f6breklere y\u00fck bindirebelir'
      ],
      tip:
          'Antrenman bittikten sonra 30 dk i\u00e7inde i\u00e7mek "anabolic window" etkisi yarat\u0131r.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Muz (1 adet)\n2. Protein tozu (1 \u00f6l\u00e7ek)\n3. Yo\u011furt (150 g)\n4. So\u011fuk s\u00fct (100 ml)\n5. Bal\n6. Buz\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda p\u00fcr\u00fcss\u00fcz k\u0131vama kadar kar\u0131\u015ft\u0131r',
      ingredients: ['muz', 'protein tozu', 'yo\u011furt', 'bal', 'buz'],
      imageUrl: 'Assets/Categories/fit/protein banana shake.jpg',
      gradient: LinearGradient(colors: [Color(0xFFF3A55C), Color(0xFFFFA500)]),
    ),
    DrinkModel(
      id: 'green-detox-smoothie',
      title: 'Green Detox Smoothie',
      category: 'Fit',
      description: 'Ye\u015fil yaprakl\u0131, enerji dolu bir detoks smoothie.',
      history:
          'Detoks kavram\u0131 Hippokrates\'in \u00f6\u011fretisine dayan\u0131r. Modern green smoothie trendi Jay Kordich ve Norman Walker\'in 1970\'lerdeki juice therapy hareketinden evrildi.',
      temperature: 'So\u011fuk',
      pros: [
        '\u0130spanak demir ve folik asit kayna\u011f\u0131',
        'Zencefil anti-inflamatuar g\u00fc\u00e7l\u00fc',
        'D\u00fc\u015f\u00fck kalori; tokluk s\u00fcrer'
      ],
      cons: [
        'Yo\u011fun ye\u015fillik baz\u0131 ki\u015filere a\u011f\u0131r gelebilir',
        'Oksalat i\u00e7eri\u011fi y\u00fcksek'
      ],
      tip: 'Sabah a\u00e7 karna i\u00e7mek besin emilimini maksimize eder.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Taze \u0131spanak (100 g)\n2. Ye\u015fil elma\n3. Taze zencefil\n4. Limon suyu\n5. So\u011fuk su (150 ml)\n6. Buz\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda p\u00fcr\u00fcss\u00fcz olana kadar kar\u0131\u015ft\u0131r\n2) Hemen servis et',
      ingredients: [
        '\u0131spanak',
        'ye\u015fil elma',
        'zencefil',
        'limon',
        'buz'
      ],
      imageUrl: 'Assets/Categories/fit/green detox smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFF0B7A75), Color(0xFF71C187)]),
    ),
    DrinkModel(
      id: 'berry-protein-bowl',
      title: 'Berry Protein Bowl',
      category: 'Fit',
      description:
          'K\u0131rm\u0131z\u0131 meyveler ve chia tohumlar\u0131yla super shake.',
      history:
          'Chia tohumlar\u0131 Aztekler taraf\u0131ndan sava\u015f\u00e7\u0131 i\u00e7ece\u011fi olarak t\u00fcketilirdi. Modern bowl k\u00fclt\u00fcr\u00fc Bali ve Avustralya wellness sahnesinde 2015\'te do\u011fdu.',
      temperature: 'So\u011fuk',
      pros: [
        'Chia omega-3 ya\u011f asidi deposu',
        'Y\u00fcksek lif',
        'K\u0131rm\u0131z\u0131 meyveler resveratrol i\u00e7erir'
      ],
      cons: [
        'Chia doku de\u011fi\u015ftirir',
        'Taze k\u0131rm\u0131z\u0131 meyve pahal\u0131'
      ],
      tip: 'Hafta ba\u015f\u0131 batch olarak haz\u0131rlanabilir.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Frambuaz (100 g)\n2. B\u00f6\u011f\u00fcrtlen (100 g)\n3. Protein tozu\n4. Chia tohumlar\u0131 (2 yemek ka\u015f\u0131\u011f\u0131)\n5. Yo\u011furt\n\nYap\u0131l\u0131\u015f:\n1) Meyveleri, protein ve yo\u011furdu blenderda kar\u0131\u015ft\u0131r\n2) Chia tohumlar\u0131n\u0131 \u00fcstüne serpistir',
      ingredients: [
        'frambuaz',
        'b\u00f6\u011f\u00fcrtlen',
        'protein tozu',
        'chia tohumu',
        'yo\u011furt'
      ],
      imageUrl: 'Assets/Categories/fit/berry protein bowl.png',
      gradient: LinearGradient(colors: [Color(0xFFCA1551), Color(0xFFFF6B6B)]),
    ),
    DrinkModel(
      id: 'coconut-almond-fit',
      title: 'Coconut Almond Fit',
      category: 'Fit',
      description:
          'Hindistancevizi ve badem ile vegan sa\u011fl\u0131kl\u0131 i\u00e7ecek.',
      history:
          'Badem s\u00fctu Orta \u00c7a\u011f Avrupa\'s\u0131nda et yemeyenlerin protein kayna\u011f\u0131yd\u0131. \u0130kili kombinasyon modern vegan mutfa\u011f\u0131n\u0131n \u00e7ocu\u011fudur.',
      temperature: 'So\u011fuk',
      pros: [
        'Tamamen vegan',
        'Badem E vitamini i\u00e7erir',
        'Hindistancevizi MCT ya\u011f i\u00e7erir',
        'Hafif ve sindirimi kolay'
      ],
      cons: [
        'Protein i\u00e7eri\u011fi d\u00fc\u015f\u00fck',
        'Haz\u0131r s\u00fctlerde \u015feker ve katk\u0131 maddesi'
      ],
      tip:
          'Sabah meditasyonu veya yoga sonras\u0131 i\u00e7in ideal hafif i\u00e7ecek.',
      preparation:
          'Malzemelerin S\u0131ras\u0131:\n1. Hindistancevizi s\u00fctu (200 ml)\n2. Badem unu (2 yemek ka\u015f\u0131\u011f\u0131)\n3. Protein tozu\n4. Bal\n\nYap\u0131l\u0131\u015f:\n1) T\u00fcm malzemeleri blenderda kar\u0131\u015ft\u0131r\n2) Hindistancevizi k\u0131r\u0131nt\u0131s\u0131 ile s\u00fcslleyerek servis et',
      ingredients: [
        'hindistancevizi s\u00fctu',
        'badem unu',
        'protein tozu',
        'bal'
      ],
      imageUrl: 'Assets/Categories/fit/coconut almond fit.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFFF8DC), Color(0xFFDEB887)]),
    ),
    // Kokteyl Kategorisine Yeni İçecekler
    DrinkModel(
      id: 'mojito-cocktail',
      title: 'Mojito',
      category: 'Kokteyl',
      description: 'Klasik nane, lime ve romlu ferah kokteyl.',
      preparation:
          'Malzemelerin Sırası:\n1. Nane yaprakları (10-12)\n2. Lime (1/2)\n3. Şeker (2 çay kaşığı)\n4. Rom (45 ml)\n5. Soda suyu (100 ml)\n6. Buz (1 fincan)\n\nYapılış:\n1) Bardağa nane yapraklarını koy\n2) Lime parçalarını ekle\n3) Şeker ile hafif ez\n4) Rom dökerek karıştır\n5) Buzla doldurup soda suyu ekle\n6) Nane dalı ve lime dilimi ile servis et',
      ingredients: ['nane', 'lime', 'rom', 'şeker', 'soda', 'buz'],
      imageUrl: 'Assets/Categories/kokteyl/mojito.png',
      gradient: LinearGradient(
        colors: [Color(0xFF228B22), Color(0xFF90EE90)],
      ),
    ),
    DrinkModel(
      id: 'margarita',
      title: 'Margarita',
      category: 'Kokteyl',
      description: 'Tequila, lime ve turuncu likörün klasik kombinasyonu.',
      preparation:
          'Malzemelerin Sırası:\n1. Tequila (45 ml)\n2. Triple sec (20 ml)\n3. Lime suyu (25 ml)\n4. Şeker şurubu (15 ml)\n5. Tuz (kenarı için)\n6. Buz\n\nYapılış:\n1) Shakera tequila, triple sec, lime suyu ve şeker şurubunu ekle\n2) Buz ekle ve kuvvetli şakela\n3) Tuzla kaplanmış margarita bardağına dök\n4) Lime dilimi ile servis et',
      ingredients: ['tequila', 'triple sec', 'lime', 'şeker', 'tuz'],
      imageUrl: 'Assets/Categories/kokteyl/margarita.png',
      gradient: LinearGradient(
        colors: [Color(0xFF228B22), Color(0xFFFFA500)],
      ),
    ),
    DrinkModel(
      id: 'cosmopolitan',
      title: 'Cosmopolitan',
      category: 'Kokteyl',
      description: 'Zarif pembe kokteyl, cranberry ve vodka ile.',
      preparation:
          'Malzemelerin Sırası:\n1. Vodka (45 ml)\n2. Triple sec (20 ml)\n3. Lime suyu (15 ml)\n4. Cranberry suyu (30 ml)\n5. Buz\n6. Portakal kabuğu (susuz)\n\nYapılış:\n1) Shakera tüm malzemeleri buz ile karıştır\n2) Martini bardağına süz\n3) Portakal kabuğu twist ile servis et',
      ingredients: ['vodka', 'triple sec', 'lime', 'cranberry', 'portakal'],
      imageUrl: 'Assets/Categories/kokteyl/cosmopolitan.png',
      gradient: LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFFFFC0CB)],
      ),
    ),
    DrinkModel(
      id: 'long-island-iced-tea',
      title: 'Long Island Iced Tea',
      category: 'Kokteyl',
      description: 'Güçlü ve karışık, seven likörün efsanevi maceraları.',
      preparation:
          'Malzemelerin Sırası:\n1. Beyaz rom (15 ml)\n2. Vodka (15 ml)\n3. Gin (15 ml)\n4. Tequila (15 ml)\n5. Triple sec (15 ml)\n6. Lime suyu (25 ml)\n7. Şeker şurubu (25 ml)\n8. Kola (30 ml)\n9. Buz\n\nYapılış:\n1) Shakera tüm likörleri, lime suyunu ve şeker şurubunu buz ile karıştır\n2) Buz dolu bardağa dök\n3) Üzerine kola ve daha buz ekle\n4) Lime dilimi ile servis et',
      ingredients: [
        'rom',
        'vodka',
        'gin',
        'tequila',
        'triple sec',
        'lime',
        'kola'
      ],
      imageUrl: 'Assets/Categories/kokteyl/long ısland ıced tea.png',
      gradient: LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFF000000)],
      ),
    ),
    // Çay Kategorisine Yeni İçecekler
    DrinkModel(
      id: 'chai-latte',
      title: 'Chai Latte',
      category: 'Çay',
      description: 'Hindistan çayı baharat karışımı ile sıcak latte.',
      preparation:
          'Malzemelerin Sırası:\n1. Siyah çay (1 poşet)\n2. Chai baharat karışımı (tarçın, karanfil, 1 çay kaşığı)\n3. Sıcak su (250 ml)\n4. Süt (100 ml)\n5. Bal (1 yemek kaşığı)\n\nYapılış:\n1) Çayı baharatla sıcak suyla demlemeye bırak\n2) 5 dakika sonra süt ekle\n3) Bala ekle ve karıştır\n4) Sıcak servis et',
      ingredients: ['çay', 'tarçın', 'karanfil', 'ingeber', 'bal', 'süt'],
      imageUrl: 'Assets/Categories/çay/chai latte.png',
      gradient: LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFFA0826D)],
      ),
    ),
    DrinkModel(
      id: 'teh-tarik',
      title: 'Teh Tarik',
      category: 'Çay',
      description: 'Çekilerek hazırlanan, köpüklü Malezya çayı.',
      preparation:
          'Malzemelerin Sırası:\n1. Siyah çay (100 ml)\n2. Yoğun kondense süt (2 yemek kaşığı)\n\nYapılış:\n1) Çayı hazırlayın\n2) İki fincan arasında ileri geri dökerek köpürtün\n3) Bardağa dök ve hemen servis et',
      ingredients: ['çay', 'kondense süt'],
      imageUrl: 'Assets/Categories/çay/teh tarik.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFFFFC0CB)],
      ),
    ),
    DrinkModel(
      id: 'milk-bubble-tea',
      title: 'Bubble Tea (Milk)',
      category: 'Çay',
      description: 'Çewe ve nişasta toplarıyla eğlenceli Tajvan çayı.',
      preparation:
          'Malzemelerin Sırası:\n1. Siyah çay (200 ml)\n2. Tapioka topları (3 yemek kaşığı)\n3. Şeker şurubu (2 yemek kaşığı)\n4. Süt (50 ml)\n5. Buz (1 fincan)\n\nYapılış:\n1) Tapioka toplarını 15 dakika kaynatıp soğut\n2) Bardağın altına tapioka toplarını koy\n3) Buz dolu bardağa buz ekle\n4) Çay ve sütü ekleyerek servis et',
      ingredients: ['çay', 'tapioka topları', 'şeker', 'süt', 'buz'],
      imageUrl: 'Assets/Categories/çay/bubble tea milk.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFFFFC0CB)],
      ),
    ),
    // Frozen Kategorisine Yeni İçecekler
    DrinkModel(
      id: 'watermelon-slushi',
      title: 'Watermelon Slushi',
      category: 'Frozen',
      description: 'Donmuş karpuz, şeker ve buz ile serinletici slushy.',
      preparation:
          'Malzemelerin Sırası:\n1. Karpuz (300 g)\n2. Şeker (2 yemek kaşığı)\n3. Limon suyu (1 yemek kaşıği)\n4. Buz (1 fincan)\n\nYapılış:\n1) Karpuzu blenderda koy\n2) Şeker ve limon suyu ekle\n3) Buzla birlikte pürüzsüz kıvama kadar karıştır\n4) Yoğun bir paste oluşsun\n5) Bardağa dök ve kalın pipet ile servis et',
      ingredients: ['karpuz', 'şeker', 'limon', 'buz'],
      imageUrl: 'Assets/Categories/frozen/watermelon slushi.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFF90EE90)],
      ),
    ),
    DrinkModel(
      id: 'strawberry-ice-granita',
      title: 'Strawberry Ice Granita',
      category: 'Frozen',
      description: 'Çilek ve buz ile İtalyan tarzı granita.',
      preparation:
          'Malzemelerin Sırası:\n1. Çilek (250 g)\n2. Şeker (3 yemek kaşığı)\n3. Su (100 ml)\n4. Limon suyu (1 yemek kaşığı)\n\nYapılış:\n1) Çilekleri ezerek mırra ol\n2) Şeker ve su ile karıştır\n3) Buzluk tepsiye dök\n4) Her 30 dakikada karıştırarak dondurmaya bırak\n5) Kristalize olmuş granita bardağa dök',
      ingredients: ['çilek', 'şeker', 'su', 'limon'],
      imageUrl: 'Assets/Categories/frozen/strawberry granita.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFFFFA500)],
      ),
    ),
    DrinkModel(
      id: 'mint-lime-slushi',
      title: 'Mint Lime Slushi',
      category: 'Frozen',
      description: 'Nane ve lime ile donmuş serinletici içecek.',
      preparation:
          'Malzemelerin Sırası:\n1. Taze nane (20 yaprak)\n2. Lime suyu (50 ml)\n3. Şeker şurubu (30 ml)\n4. Su (100 ml)\n5. Buz (1,5 fincan)\n\nYapılış:\n1) Nane yapraklarını blenderda ezin\n2) Lime suyu, şeker şurubu ve su ekle\n3) Buzla birlikte slushi kıvamına kadar karıştır\n4) Kalın pasta olmuşsa bardağa dök\n5) Nane dalı ile servis et',
      ingredients: ['nane', 'lime', 'şeker', 'su', 'buz'],
      imageUrl: 'Assets/Categories/frozen/mint lime slushi.png',
      gradient: LinearGradient(
        colors: [Color(0xFF228B22), Color(0xFF90EE90)],
      ),
    ),
    // Soda Kategorisine Yeni İçecekler
    DrinkModel(
      id: 'pomegranate-ginger-soda',
      title: 'Pomegranate Ginger Soda',
      category: 'Soda',
      description: 'Nar ve zencefil ile baharatlı, serinletici soda.',
      preparation:
          'Malzemelerin Sırası:\n1. Nar suyu (100 ml)\n2. Zencefil (1 cm parça, rendelenmiş)\n3. Limon suyu (2 çay kaşığı)\n4. Maden suyu (150 ml)\n5. Buz (1 fincan)\n6. Nar taneleri (süsleme)\n\nYapılış:\n1) Nar suyunu zencefil ve limon suyu ile karıştır\n2) Buz dolu bardağa dök\n3) Maden suyu ekle\n4) Hafif karıştır\n5) Nar taneleriyle servis et',
      ingredients: ['nar suyu', 'zencefil', 'limon', 'maden suyu'],
      imageUrl: 'Assets/Categories/soda/pomegranete ginger soda.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFFB31217), Color(0xFFFF6B6B)],
      ),
    ),
    DrinkModel(
      id: 'passion-fruit-soda',
      title: 'Passion Fruit Soda',
      category: 'Soda',
      description: 'Tutum meyvesi ve maden suyu ile tropik soda.',
      preparation:
          'Malzemelerin Sırası:\n1. Tutun meyvesi pulpası (3 yemek kaşığı)\n2. Şeker şurubu (2 yemek kaşıği)\n3. Limon suyu (1 yemek kaşığı)\n4. Maden suyu (150 ml)\n5. Buz (1 fincan)\n\nYapılış:\n1) Bardağa passion fruit pulpasını koy\n2) Şeker şurubu ve limon suyu ekle\n3) Buz dolu bardağa dök\n4) Maden suyu ekle\n5) Hafif karıştırarak servis et',
      ingredients: ['tutum meyvesi', 'şeker', 'limon', 'maden suyu'],
      imageUrl: 'Assets/Categories/soda/passion fruit soda.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFFFFA500), Color(0xFFFFD700)],
      ),
    ),
    // Kahve Kategorisine Yeni İçecekler
    DrinkModel(
      id: 'irish-coffee',
      title: 'Irish Coffee',
      category: 'Kahve',
      description: 'Sıcak kahve, viski ve krem şantiyle İrlandalı sürpriz.',
      preparation:
          'Malzemelerin Sırası:\n1. Sıcak espresso (45 ml)\n2. İrlanda viskisi (45 ml)\n3. Şeker (1 yemek kaşığı)\n4. Krem şanti (30 g)\n\nYapılış:\n1) Bardağa espresso ve viskiyi ekle\n2) Şeker ekle ve karıştır\n3) Üzerine krem şanti örtücü tabaka olarak ekle\n4) Sıcak servis et',
      ingredients: ['espresso', 'viski', 'şeker', 'krem'],
      imageUrl: 'Assets/Categories/kahve/ıris coffee.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFF3E2723), Color(0xFF8D6E63)],
      ),
    ),
    DrinkModel(
      id: 'cortado',
      title: 'Cortado',
      category: 'Kahve',
      description: 'Espresso ve süt eşit oranda, dengeli kahve deneyimi.',
      preparation:
          'Malzemelerin Sırası:\n1. Espresso (30 ml)\n2. Steamed süt (30 ml)\n3. Süt köpüğü (5 ml)\n\nYapılış:\n1) Bardağa espresso ekle\n2) Eşit miktarda steamed sütü ekle\n3) Üzerine hafif köpük katı ekle\n4) Sıcak servis et',
      ingredients: ['espresso', 'süt'],
      imageUrl: 'Assets/Categories/kahve/cortada.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFF8B6F47), Color(0xFFD2B48C)],
      ),
    ),
    // Smoothie Kategorisine Yeni İçecekler
    DrinkModel(
      id: 'kiwi-pineapple-smoothie',
      title: 'Kiwi Pineapple Smoothie',
      category: 'Smoothie',
      description: 'Kivi ve ananas ile tropikal taze smoothie.',
      preparation:
          'Malzemelerin Sırası:\n1. Kivi (2 adet)\n2. Ananas (150 g)\n3. Yoğurt (150 g)\n4. Hindistancevizi sütü (100 ml)\n5. Bal (1 çay kaşığı)\n\nYapılış:\n1) Kivi ve ananaları blenderda koy\n2) Yoğurt ve hindistancevizi sütü ekle\n3) Bal ekle ve pürüzsüz olana kadar karıştır\n4) Ananas dilimi ile servis et',
      ingredients: ['kivi', 'ananas', 'yoğurt', 'hindistancevizi sütü', 'bal'],
      imageUrl: 'Assets/Categories/smoothie/kiwi pineapple smoothie.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFFFFA500), Color(0xFF90EE90)],
      ),
    ),
    DrinkModel(
      id: 'avocado-chocolate-smoothie',
      title: 'Avocado Chocolate Smoothie',
      category: 'Smoothie',
      description: 'Avokado ve çikolata ile kremsi, besleyici smoothie.',
      preparation:
          'Malzemelerin Sırası:\n1. Avokado (1/2)\n2. Kakao tozu (1 yemek kaşığı)\n3. Çikolata protein tozu (1 ölçek)\n4. Almond sütü (200 ml)\n5. Bal (1 yemek kaşığı)\n\nYapılış:\n1) Avokadoyu blenderda koy\n2) Kakao tozu ve protein tozu ekle\n3) Almond sütü ve bal ekle\n4) Pürüzsüz olana kadar çe\n5) Çikolata serpiştirerek servis et',
      ingredients: [
        'avokado',
        'kakao tozu',
        'protein tozu',
        'almond sütü',
        'bal'
      ],
      imageUrl: 'Assets/Categories/smoothie/avocada chocolate smoothie.jpg',
      gradient: LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFF6B4C2F)],
      ),
    ),
    // ── YENİ KAHVELERİ ─────────────────────────────────────────────────────────
    DrinkModel(
      id: 'turkish-coffee',
      title: 'Türk Kahvesi',
      category: 'Kahve',
      description:
          'Geleneksel koyubaşlı Türk kahvesi, sabah enerjisi için ideal.',
      history:
          'Türk kahvesi 16. yüzyılda Osmanlı İmparatorluğu\'na gelmiş ve o günden bu yana bir geleneğe dönüşmüştür.',
      temperature: 'Sıcak',
      pros: [
        'Yüksek antioksidan içeriği',
        'Sosyal bir deneyim',
        'Kalp sağlığına iyi'
      ],
      cons: ['Çok kafein içerir', 'Mide hassasiyeti olanlar için zor'],
      tip: 'Cezve dörtlü kupa ile pişirin, 3 kez kaynatın.',
      preparation:
          '1. Kahve (1 çay kaşığı)\n2. Su (1 fincan)\n3. Şeker (istediğiniz)\n\nYapılış: Cezveye su ve kahve ekleyip 3 kez kaynatın.',
      ingredients: ['kahve', 'su', 'şeker'],
      imageUrl: 'Assets/Categories/kahve/türk kahvesi.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein'],
      alternatives: {'şeker': 'honey', 'su': 'sütlü su'},
    ),
    DrinkModel(
      id: 'cortado-coffee',
      title: 'Cortado',
      category: 'Kahve',
      description:
          'Espresso ve süt eşit oranda karışımı, dengeyi mükemmel kılar.',
      history:
          'İspanya\'dan gelen bu kahve türü, espresso ve süt arasında mükemmel dengeyi sunar.',
      temperature: 'Sıcak',
      pros: [
        'Dengeli kahve tadı',
        'Az kalori (sütlü versiyonda)',
        'Orta kafein seviyesi'
      ],
      cons: [
        'Süt hassasiyeti olanlar için sorun',
        'Az malzeme ile sınırlı tadlar'
      ],
      tip: 'Espresso ve sütü 1:1 oranında karıştırın, köpük az olsun.',
      preparation:
          '1. Espresso (1 shot, 30 ml)\n2. Sıcak süt (30 ml)\n\nYapılış: Espresso yapın, eşit miktarda sütü dökin.',
      ingredients: ['espresso', 'süt'],
      imageUrl: 'Assets/Categories/kahve/cortada.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein', 'süt'],
      alternatives: {'süt': 'vegan süt', 'espresso': 'decaf espresso'},
    ),
    DrinkModel(
      id: 'affogato',
      title: 'Affogato',
      category: 'Kahve',
      description:
          'Vanilla dondurmasının üzerine sıcak espresso dökülerek hazırlanan tatlı içecek.',
      history:
          'İtalya\'dan gelen bu tatlı kahve çeşidi, dondurma ve kahvenin mükemmel kombinasyonudur.',
      pros: ['Tatlı ve enerji verici', 'Hızlı ve kolay', 'Özel bir tadı var'],
      cons: ['Yüksek kalori', 'Şeker açısından zengin'],
      tip: 'Dondurma soğuk, espresso çok sıcak olmalı kontrast için.',
      preparation:
          '1. Vanilla dondurması (2 top)\n2. Espresso (60 ml, sıcak)\n\nYapılış: Fincana dondurma koyup sıcak espresso dökin.',
      ingredients: ['dondurma', 'espresso'],
      imageUrl: 'Assets/Categories/kahve/affogato.jpg',
      gradient: LinearGradient(colors: [Color(0xFFF5DEB3), Color(0xFF8B4513)]),
      allergens: ['kafein', 'süt', 'şeker'],
      alternatives: {'dondurma': 'vegan dondurma', 'şeker': 'stevia'},
    ),
    // ── YENİ ÇAYlar ─────────────────────────────────────────────────────────
    DrinkModel(
      id: 'apple-cinnamon-tea',
      title: 'Elma Tarçın Çayı',
      category: 'Çay',
      description: 'Elma ve tarçın ile ısıtan rahatlatıcı çay.',
      history:
          'Geleneksel meyveli çaylar, Orta Doğu\'da yüzyıllardır içilmektedir.',
      temperature: 'Sıcak',
      pros: ['Soğuk algınlığına iyi', 'Sindirimi iyileştirir', 'Doğal tatı'],
      cons: ['Hassas dişliler için asitli'],
      tip: 'Elmaları küçük parçalar halinde kesin, tarçını az kullanın.',
      preparation:
          '1. Elma (1 adet, dilimlenmiş)\n2. Tarçın çubuğu (1)\n3. Sıcak su (200 ml)\n4. Bal (1 çay kaşığı)\n\nYapılış: Suyu kaynatın, elma ve tarçın ekleyin, 5 dk demleyin.',
      ingredients: ['elma', 'tarçın', 'su', 'bal'],
      imageUrl: 'Assets/Categories/çay/elma tarçın çay.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'bal': 'şeker', 'tarçın': 'zencefil'},
    ),
    DrinkModel(
      id: 'hibiscus-tea-cold',
      title: 'Kırmızı Çiçek Çayı (Soğuk)',
      category: 'Çay',
      description:
          'Hibiskus çiçeği ile yapılan, ferah ve antioksidan açısından zengin soğuk çay.',
      history:
          'Mısır\'da geleneksel olarak içilen hibiskus çayı, dünyada popüler hale gelmiştir.',
      temperature: 'Soğuk',
      pros: [
        'Antioksidan açısından çok zengin',
        'Kan basıncını düşürür',
        'Kalorisi çok az'
      ],
      cons: ['Asitli olabilir', 'İlaç etkileşimleri olabilir'],
      tip: 'Soğuk pişirme yöntemi ile 8 saat bekletebilirsiniz.',
      preparation:
          '1. Hibiskus çiçekleri (2 çay kaşığı)\n2. Soğuk su (250 ml)\n3. Limon (1/2)\n4. Şeker/bal (isteğe bağlı)\n\nYapılış: Çiçekleri suya koyun, 15 dk bekletin, süzün, limon ekleyin.',
      ingredients: ['hibiskus', 'su', 'limon'],
      imageUrl: 'Assets/Categories/çay/kırmızı çiçek çayı.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeker': 'stevia', 'limon': 'lime'},
    ),
    // ── YENİ SMOOTHIE'LER ─────────────────────────────────────────────────
    DrinkModel(
      id: 'protein-berry-smoothie',
      title: 'Protein Berry Smoothie',
      category: 'Smoothie',
      description: 'Çoğul meyveler ve protein ile kas geliştirme smoothie\'si.',
      history:
          'Fitness hareketiyle beraber protein smoothieleri popüler hale gelmiştir.',
      temperature: 'Soğuk',
      pros: [
        'Kas gelişimine yardımcı',
        'Dolu doyurucu',
        'Antoksidanlar içerir'
      ],
      cons: [
        'Yüksek protein alımı her zaman iyi değil',
        'Sindirimi ağır olabilir'
      ],
      tip: 'Buz eklemeden smoothie daha konsantre olur.',
      preparation:
          '1. Karışık meyveler (1 fincan: çilek, böğürtlen, mirtil)\n2. Protein tozu (1 ölçek)\n3. Yunani yoğurdu (150 g)\n4. Almond sütü (200 ml)\n5. Bal (1 çay kaşığı)\n\nYapılış: Tüm malzemeleri blenderda çekin.',
      ingredients: [
        'çilek',
        'böğürtlen',
        'mirtil',
        'protein tozu',
        'yoğurt',
        'almond sütü'
      ],
      imageUrl: 'Assets/Categories/smoothie/protein bery smoothie.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['laktoz (yoğurt)', 'gluten (protein tozu içerebilir)'],
      alternatives: {'yoğurt': 'coconut yogurt', 'almond sütü': 'oat milk'},
    ),
    DrinkModel(
      id: 'green-detox-smoothie',
      title: 'Yeşil Detox Smoothie',
      category: 'Smoothie',
      description: 'Yeşil yapraklı sebzeler ile detoksifikasyon smoothie\'si.',
      history:
          'Modern detoks hareketinin bir parçası, sağlık bilinci ile popüler hale gelmiştir.',
      temperature: 'Soğuk',
      pros: [
        'Detoksifikasyon',
        'Enerji verici',
        'Vitamin ve mineral açısından zengin'
      ],
      cons: [
        'Tadı kuvvetli olabilir',
        'Yüksek klorofil içeriği sindirime zor gelebilir'
      ],
      tip: 'Tatlı elma ekleyerek tadını hafifletebilirsiniz.',
      preparation:
          '1. Ispanak (1 kasa)\n2. Yaşıl elma (1)\n3. Kıvırcık salata (1/2 kasa)\n4. Limon (1/2)\n5. Zencefil (1 parmak)\n6. Coconut sütü (200 ml)\n7. Su (100 ml)\n\nYapılış: Yaprakları koyun, meyveler ekleyin, sıvı döküp çekin.',
      ingredients: [
        'ispanak',
        'yeşil elma',
        'kıvırcık salata',
        'limon',
        'zencefil',
        'coconut sütü'
      ],
      imageUrl: 'Assets/Categories/fit/green detox smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'coconut sütü': 'almond milk', 'limon': 'lime'},
    ),
    // ── YENİ FİT DRINKS ──────────────────────────────────────────────────
    DrinkModel(
      id: 'electrolyte-coconut-water',
      title: 'Hindistancevizi Suyu Elektrolit',
      category: 'Fit',
      description:
          'Doğal elektrolit kaynağı, antrenmandan sonra yenileme içeceği.',
      history:
          'Hindistancevizi suyu tropik ülkelerde geleneksel içecektir, recent olarak fitness alanında popüler olmuştur.',
      temperature: 'Soğuk',
      pros: [
        'Doğal elektrolit',
        'Dehidratasyonu giderir',
        'Potasyum açısından zengin'
      ],
      cons: [
        'Şeker açısından bazı ticari versiyonlar yüksek',
        'Bazı kişilerde mide ağrısı yapabilir'
      ],
      tip: 'Taze hindistancevizinden direkt suyu çıkartmak en iyisidir.',
      preparation:
          '1. Hindistancevizi suyu (250 ml)\n2. Elektrolit tozu (1 paket)\n3. Limon (1/4)\n4. Buz (1 fincan)\n\nYapılış: Hindistancevizi suyunu buz ile dökerek elektrolit tozu ve limon ekleyin.',
      ingredients: ['hindistancevizi suyu', 'elektrolit tozu', 'limon', 'buz'],
      imageUrl: 'Assets/Categories/fit/hindistan cevizi suyu elektrolit.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'hindistancevizi suyu': 'spor içeceği'},
    ),
    DrinkModel(
      id: 'chia-seed-lemon-water',
      title: 'Chia Tohumlu Limonata',
      category: 'Fit',
      description:
          'Chia tohumlu besleyici limonata, metabolizmayı hızlandırıcı.',
      history:
          'Chia tohumu Aztekler tarafından kullanıldı, modern fitness hareketinde popüler hale geldi.',
      temperature: 'Soğuk',
      pros: [
        'Metabolizmayı hızlandırır',
        'Dolu doyurucu',
        'Omega-3 açısından zengin'
      ],
      cons: [
        'Chia tohumları su çekebilir, pişemeden tüketilmeli',
        'Bazı kişilerde alerjik reaksiyon'
      ],
      tip: 'Chia tohumlarını önceden 5 dakika su ile nemlendir.',
      preparation:
          '1. Su (250 ml)\n2. Limon (1/2)\n3. Chia tohumları (1 çay kaşığı)\n4. Stevia/şeker (isteğe bağlı)\n5. Mint (isteğe bağlı)\n\nYapılış: Chia tohumlarını suya koyup 5 dk beklet, limon ve şeker ekle.',
      ingredients: ['su', 'limon', 'chia tohumları', 'stevia'],
      imageUrl: 'Assets/Categories/fit/chia tohumlu limonata.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'stevia': 'bal', 'chia': 'flax tohumu'},
    ),
    // ── YENİ SODAxyz ──────────────────────────────────────────────────────
    DrinkModel(
      id: 'ginger-ale-homemade',
      title: 'Ev Yapımı Ginger Ale',
      category: 'Soda',
      description: 'Taze zencefil ve limon ile yapılmış soda.',
      history:
          'Ginger Ale İrlanda\'dan gelmiştir, asıl sağlık faydaları için yapılmıştır.',
      temperature: 'Soğuk',
      pros: [
        'Sindirimi iyileştirir',
        'Doğal ingredientler',
        'Bulantıya iyi gelir'
      ],
      cons: ['Taze zencefil kolay bulunmayabilir', 'Tadı kuvvetli olabilir'],
      tip: 'Zencefil suyu hafif acı olmadan hazırlanmalı.',
      preparation:
          '1. Taze zencefil (100 g, rendelenmesi)\n2. Limon (2)\n3. Şeker (2 çay kaşığı)\n4. Su (500 ml)\n5. Soda suyu (250 ml)\n\nYapılış: Zencefili suya koyup kaynatın, soğutun, limon ekleyin, soda suyu dökin.',
      ingredients: ['zencefil', 'limon', 'şeker', 'su', 'soda suyu'],
      imageUrl: 'Assets/Categories/soda/ginger ale.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeker': 'stevia', 'zencefil': 'limon'},
    ),
    // ── YENİ KOKTEYL ──────────────────────────────────────────────────────
    DrinkModel(
      id: 'virgin-mojito-mocktail',
      title: 'Virgin Mojito',
      category: 'Kokteyl',
      description: 'Alkosüz Mojito, ferah ve yaz içeceği.',
      history:
          'Mojito Küba\'dan gelmiştir, Virgin versiyonu alkol tarafından uzak duranlar için.',
      temperature: 'Soğuk',
      pros: [
        'Ferah ve enerji verici',
        'Hiçbir alkol yok',
        'Doğal ingredientler'
      ],
      cons: ['Şeker açısından yüksek', 'Mint bulunması zorunlu'],
      tip: 'Mint yapraklarını ezmeyin, hafif bastırın sadece.',
      preparation:
          '1. Mint yaprakları (8-10)\n2. Lime (1/2)\n3. Şeker (1 çay kaşığı)\n4. Soda suyu (200 ml)\n5. Buz (1 fincan)\n\nYapılış: Bardağa mint koyup hafif bastır, lime sık, şeker ekle, buz dök, soda suyu döküp karıştır.',
      ingredients: ['mint', 'lime', 'şeker', 'soda suyu', 'buz'],
      imageUrl: 'Assets/Categories/kokteyl/virgin mojito.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeker': 'stevia', 'soda suyu': 'ginger ale'},
    ),
    DrinkModel(
      id: 'strawberry-passion-fruit-punch',
      title: 'Çilek Passion Fruit Punch',
      category: 'Kokteyl',
      description: 'Çilek ve passion fruit ile tropik punch içeceği.',
      history:
          'Punch içecekleri tropik ülkelerde sosyal etkinliklerde gelenekseldir.',
      temperature: 'Soğuk',
      pros: ['Tropik tatı', 'Vitamin C açısından zengin', 'Grup için ideal'],
      cons: [
        'Şeker açısından yüksek',
        'Taze passion fruit maliyeti',
        'Prep zamanı gerekli'
      ],
      tip: 'Passion fruit suyu taze sıkılmış olmalı.',
      preparation:
          '1. Çilek (1 fincan, dilimlenmiş)\n2. Passion fruit (4 adet, suyu)\n3. Oran suyu (1 fincan)\n4. Şurup (2 çay kaşığı)\n5. Buz\n6. Mint (garnish)\n\nYapılış: Çilekleri pureleyin, passion fruit suyu ekleyin, oran suyu ve şurup döküp buz ekleyin.',
      ingredients: ['çilek', 'passion fruit', 'oran suyu', 'şurup'],
      imageUrl: 'Assets/Categories/kokteyl/çilek passion fruit punch.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'passion fruit': 'mango', 'çilek': 'karpuz'},
    ),
    // ── YENİ MATCHA ───────────────────────────────────────────────────────
    DrinkModel(
      id: 'matcha-latte-vegan',
      title: 'Vegan Matcha Latte',
      category: 'Matcha',
      description: 'Vegan sütü ile yapılmış matcha latte.',
      history:
          'Matcha latte Batı\'da popüler bir trend olmuştur, vegan versiyonu çeşitliliği artırır.',
      temperature: 'Sıcak',
      pros: ['Laktoz-free', 'Antoksidanlar zengin', 'Vegan dostça'],
      cons: [
        'Lezzetler süt versiyonundan farklı',
        'Bazı vegan sütler daha pahallı'
      ],
      tip: 'Oat milk en iyi foam yapımı sağlar.',
      preparation:
          '1. Matcha tozu (1-2 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Vegan süt (150 ml, ısıtılmış)\n4. Bal (isteğe bağlı)\n\nYapılış: Matcha tozunu sıcak su ile (çorbacı taş öpüştürecek) karıştır, vegan sütü ekle ve ısıt.',
      ingredients: ['matcha tozu', 'su', 'vegan süt', 'bal'],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF7CFC00), Color(0xFF32CD32)]),
      alternatives: {'oat milk': 'almond milk', 'bal': 'stevia'},
    ),
    DrinkModel(
      id: 'iced-matcha-lemonade',
      title: 'Soğuk Matcha Limonata',
      category: 'Matcha',
      description: 'Matcha ve limon\'un ferah kombinasyonu.',
      history:
          'Modern matcha tüketiminin yeni bir varyasyonu, yaz içeceği olarak popülerleşti.',
      temperature: 'Soğuk',
      pros: ['Ferah ve enerji verici', 'Antoksidanlar zengin', 'Doğal tatı'],
      cons: ['Limonun tat matcha ile çakışabilir', 'Hazırlama detaylı'],
      tip: 'Matcha suyu ilk olarak soğumaya bırakın, sonra karıştırın.',
      preparation:
          '1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Limon suyu (sıkılmış, 50 ml)\n4. Şeker şurubu (2 çay kaşığı)\n5. Buz (1 fincan)\n6. Su (100 ml)\n\nYapılış: Matcha\'yı sıcak su ile çekin, soğut, limon ve şurup ekle, buz dökerek sun.',
      ingredients: ['matcha tozu', 'su', 'limon', 'şeker şurubu'],
      imageUrl: 'Assets/photos/matcha.jpg',
      gradient: LinearGradient(colors: [Color(0xFF7CFC00), Color(0xFFFFD700)]),
      alternatives: {'şeker şurubu': 'stevia', 'limon': 'lime'},
    ),
    // ── YENİ FROZEN ──────────────────────────────────────────────────────
    DrinkModel(
      id: 'mango-sorbet-frozen',
      title: 'Mango Sorbet Frozen',
      category: 'Frozen',
      description: 'Mango ile yapılmış dondurulmuş şerbet içeceği.',
      history:
          'Sorbetler Orta Doğu\'dan gelmiş, buzlu bir serinletme yöntemidir.',
      temperature: 'Soğuk',
      pros: [
        'Yazlık ferah',
        'Doğal meyve tadı',
        'Şekersiz versiyonu yapılabilir'
      ],
      cons: ['Yüksek kalori (şeker)', 'Mango maliyeti'],
      tip: 'Taze mango en iyi sonuç verir.',
      preparation:
          '1. Mango (2 adet, dilimlenmiş)\n2. Şeker (3 çay kaşığı)\n3. Limon (1/2)\n4. Buz\n\nYapılış: Mangolar, şeker ve limonu blenderda dön, buzlu slushi elde et.',
      ingredients: ['mango', 'şeker', 'limon', 'buz'],
      imageUrl: 'Assets/Categories/frozen/mango frozen.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'mango': 'ananas', 'şeker': 'stevia'},
    ),
    DrinkModel(
      id: 'watermelon-mint-frozen',
      title: 'Karpuz Mint Frozen',
      category: 'Frozen',
      description: 'Karpuz ve mentol ile yapılmış erişmiş buz içeceği.',
      history: 'Yazın yazın en sevilen serinletici içeceklerden biridir.',
      temperature: 'Soğuk',
      pros: [
        'Doğal serinlik',
        'Hidratasyonu destekler',
        'Az kalori (şekersiz)'
      ],
      cons: ['Sezonluk (yaz)', 'Hazırlama zamanı gerekli'],
      tip: 'Karpuzun tohlumsuz kısmını kullanın.',
      preparation:
          '1. Karpuz (3 fincan, küplü)\n2. Mint yaprakları (10)\n3. Limon (1/4)\n4. Şeker (1 çay kaşığı, isteğe bağlı)\n5. Buz\n\nYapılış: Karpuz ve mint\'i blenderda dön, limon ekle, buz dökerek servis et.',
      ingredients: ['karpuz', 'mint', 'limon', 'şeker'],
      imageUrl: 'Assets/Categories/frozen/watermelon slushi.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'karpuz': 'ananas', 'mint': 'dill'},
    ),
    // ── EKLENEN POPÜLER İÇECEKLER ──────────────────────────────────────
    DrinkModel(
      id: 'hibiscus-lemonade',
      title: 'Hibiskus Limonata',
      category: 'Soda',
      description: 'Hibiskus çiçeği ve limonun ferah kombinasyonu.',
      history: 'Mısır\'ın sevilen geleneksel içeceğine Batılı dokunuş.',
      temperature: 'Soğuk',
      pros: ['Antioksidanlar açısından zengin', 'Doğal tat', 'Sağlıklı'],
      cons: ['Çiçek bulunması zorunlu', 'Asitli olabilir'],
      tip: 'Taze hibiskus çiçekleri en iyisidir.',
      preparation:
          '1. Hibiskus (3 çiçek)\n2. Limon (2)\n3. Su (500 ml)\n4. Şeker (2 çay kaşığı)\n5. Buz\n\nYapılış: Hibiskusu sıcak suya koyup 10 dk beklet, soğut, limon ekle.',
      ingredients: ['hibiskus', 'limon', 'su', 'şeker'],
      imageUrl: 'Assets/Categories/soda/hibiskus limonata.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeker': 'stevia'},
    ),
    DrinkModel(
      id: 'iced-turmeric-latte',
      title: 'Soğuk Zerdeçal Latte',
      category: 'Fit',
      description: 'Zerdeçal ve coconut sütü ile anti-inflamatuar içecek.',
      history: 'Geleneksel golden milk\'in modern, soğuk versiyonu.',
      temperature: 'Soğuk',
      pros: [
        'Anti-inflamatuar özellikler',
        'Bağışıklığı güçlendirir',
        'Fırsat enerjisi'
      ],
      cons: ['Tadı kuvvetli', 'Bazı kişilerde alerjik reaksiyon'],
      tip: 'Birkaç damla siyah biber hayati!',
      preparation:
          '1. Zerdeçal (1/2 çay kaşığı)\n2. Coconut sütü (150 ml)\n3. Bal (1 çay kaşığı)\n4. Siyah biber (birkaç tane)\n5. Buz\n\nYapılış: Zerdeçal ve sıcak biraz suyu karıştır, coconut sütü ve buz ekle.',
      ingredients: ['zerdeçal', 'coconut sütü', 'bal', 'siyah biber'],
      imageUrl: 'Assets/Categories/fit/soğuk zerdeçal latte.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'coconut sütü': 'almond milk', 'bal': 'stevia'},
    ),
    DrinkModel(
      id: 'peach-iced-tea',
      title: 'Şeftali Soğuk Çayı',
      category: 'Çay',
      description: 'Şeftali ile yapılmış meyveli soğuk çay.',
      history: 'Meyveli çaylar yaz içeceklerinin tercihi olmuştur.',
      temperature: 'Soğuk',
      pros: ['Doğal şeftali tatı', 'Kalorisi düşük', 'Ferah'],
      cons: ['Taze şeftali sezonluk', 'Hazırlama zamanı gerekli'],
      tip: 'Dondurulmuş şeftali da kullanabilirsiniz.',
      preparation:
          '1. Şeftali (2 adet, dilimlenmiş)\n2. Siyah çay (1 çanta)\n3. Sıcak su (300 ml)\n4. Limon (1/4)\n5. Buz\n\nYapılış: Çayı demlendikten sonra şeftaliyi koyun, soğutun, limon ve buz ekleyin.',
      ingredients: ['şeftali', 'çay', 'su', 'limon'],
      imageUrl: 'Assets/Categories/çay/şeftali soğuk çayı.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeftali': 'nektarin', 'limon': 'lime'},
    ),
    DrinkModel(
      id: 'mango-lassi',
      title: 'Mango Lassi',
      category: 'Smoothie',
      description: 'Mango ve yoğurt ile yapılmış hint içeceği.',
      history: 'Hindistan\'ın geleneksel soğuk içeceğidir, yazda popülerdir.',
      temperature: 'Soğuk',
      pros: [
        'Yoğurt probiyotikler sağlar',
        'Mango Vitamin C açısından zengin',
        'Doyurucu'
      ],
      cons: ['Kalori açısından yüksek', 'Laktoz (yoğurttan)'],
      tip: 'Taze mango en iyi sonuç verir.',
      preparation:
          '1. Mango (1 fincan, dilimlenmiş)\n2. Yunani yoğurdu (150 g)\n3. Su (100 ml)\n4. Bal (1 çay kaşığı)\n5. Kardamom (birkaç tane)\n\nYapılış: Tüm malzemeleri blenderda çekin, buz ekleyerek servis edin.',
      ingredients: ['mango', 'yoğurt', 'su', 'bal', 'kardamom'],
      imageUrl: 'Assets/Categories/smoothie/mango lassi.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['laktoz'],
      alternatives: {'yoğurt': 'coconut yogurt'},
    ),
    DrinkModel(
      id: 'lavender-lemonade',
      title: 'Lavanta Limonata',
      category: 'Soda',
      description: 'Lavanta ve limonun rahatlatıcı kombinasyonu.',
      history:
          'Lavanta şifalı bitkiler arasında bilinen ve içeceklerde kullanılır.',
      temperature: 'Soğuk',
      pros: ['Rahatlatıcı etki', 'Uyku kalitesini iyileştirir', 'Aromatik'],
      cons: ['Lavanta bulunması gerekli', 'Tadı kuvvetli olabilir'],
      tip: 'Kurutulmuş lavantayı filtre ile kullanın.',
      preparation:
          '1. Kurutulmuş lavanta (1 çay kaşığı)\n2. Limon (2)\n3. Su (500 ml)\n4. Şeker (2 çay kaşığı)\n5. Buz\n\nYapılış: Lavantayı sıcak suya koyup 10 dk beklet, limon ve şeker ekle, soğut.',
      ingredients: ['lavanta', 'limon', 'su', 'şeker'],
      imageUrl: 'Assets/Categories/soda/lavanta limonata.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeker': 'honey'},
    ),
    DrinkModel(
      id: 'pineapple-mint-punch',
      title: 'Ananas Mint Punch',
      category: 'Kokteyl',
      description: 'Ananas ve mintli tropik punch.',
      history: 'Tropik bölgelerin sevilen grup içeceğidir.',
      temperature: 'Soğuk',
      pros: ['Tropik tatı', 'Bromelain enzimi içerir', 'Sosyal içecek'],
      cons: ['Şeker açısından yüksek', 'Prep zamanı gerekli'],
      tip: 'Taze ananası keserek kullanın.',
      preparation:
          '1. Ananas (2 fincan, dilimlenmiş)\n2. Mint (15 yaprak)\n3. Lime (2)\n4. Şeker şurubu (3 çay kaşığı)\n5. Su (300 ml)\n6. Buz\n\nYapılış: Ananaları blenderda kısa çekin, mint hafif bastır, diğer malzemeleri ekle.',
      ingredients: ['ananas', 'mint', 'lime', 'şeker'],
      imageUrl: 'Assets/Categories/kokteyl/ananas mint punch.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'ananas': 'mango', 'mint': 'basil'},
    ),
    DrinkModel(
      id: 'rose-water-cooler',
      title: 'Gül Suyu İçeceği',
      category: 'Soda',
      description: 'Gül suyu ve limon ile yapılmış serinletici içecek.',
      history: 'Orta Doğu ve Güney Asya\'nın geleneksel soğuk içeceğidir.',
      temperature: 'Soğuk',
      pros: ['Aromatik ve rahatlatıcı', 'Kalorisi çok az', 'Romantik deneyim'],
      cons: ['Gül suyu bulunması gerekli', 'Tadı kişiye bağlı'],
      tip: 'Yüksek kaliteli organik gül suyu kullanın.',
      preparation:
          '1. Gül suyu (3 çay kaşığı)\n2. Limon (1)\n3. Su (500 ml)\n4. Şeker (1 çay kaşığı)\n5. Buz\n\nYapılış: Gül suyunu suya koyun, limon ekle, şeker ve buz dökerek karıştırın.',
      ingredients: ['gül suyu', 'limon', 'su', 'şeker'],
      imageUrl: 'Assets/Categories/soda/gül suyu soda.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'şeker': 'stevia'},
    ),
    DrinkModel(
      id: 'berry-acai-bowl-drink',
      title: 'Berry Acai Içeceği',
      category: 'Smoothie',
      description: 'Acai ve karışık meyvelerle yapılmış besleyici smoothie.',
      history:
          'Acai smoothie bowl trendi dünyadaki sağlık bilinci ile popüler hale geldi.',
      temperature: 'Soğuk',
      pros: ['Antoksidanlar çok zengin', 'Enerji verici', 'Lezzetli'],
      cons: ['Acai bulunması zorunlu', 'Pahalı', 'Maliyeti yüksek'],
      tip: 'Dondurulmuş acai paketleri kullanabilirsiniz.',
      preparation:
          '1. Acai (1 paket, dondurulmuş)\n2. Karışık meyveler (1 fincan)\n3. Granola (3 çay kaşığı)\n4. Coconut sütü (150 ml)\n5. Bal (1 çay kaşığı)\n\nYapılış: Acai ve meyveler blenderda kısa çekin, granola üzerine serp.',
      ingredients: ['acai', 'meyveler', 'granola', 'coconut sütü', 'bal'],
      imageUrl: 'Assets/Categories/smoothie/acai blueberry smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'coconut sütü': 'almond milk'},
    ),
    DrinkModel(
      id: 'orange-vanilla-smoothie',
      title: 'Portakal Vanilya Smoothie',
      category: 'Smoothie',
      description:
          'Taze portakal ve vanilya ile yapılmış güne başlama içeceği.',
      history: 'Basit ama etkili bir kombinasyon, kahvaltı klasiğidir.',
      temperature: 'Soğuk',
      pros: [
        'Vitamin C açısından zengin',
        'Doğal şeker içerir',
        'Basit ve hızlı'
      ],
      cons: ['Portakal suyu yapılması gerekli', 'Posa içerir'],
      tip: 'Taze portakal sıkı daha iyi olur.',
      preparation:
          '1. Portakal (3 adet, sıkılmış)\n2. Vanilya yoğurdu (150 g)\n3. Buz (1/2 fincan)\n4. Bal (1 çay kaşığı)\n\nYapılış: Portakal suyunu yoğurt ile karıştır, buz ekleyip çekin.',
      ingredients: ['portakal', 'yoğurt', 'buz', 'bal'],
      imageUrl: 'Assets/Categories/smoothie/portakal vaniya smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['laktoz'],
      alternatives: {'yoğurt': 'coconut cream'},
    ),
    DrinkModel(
      id: 'pomegranate-blueberry-tea',
      title: 'Nar Mirtil Çayı',
      category: 'Çay',
      description: 'Nar ve mirtillerle yapılmış antioksidan çayı.',
      history: 'Meyveli çayların modern sağlık bilinci versiyonu.',
      temperature: 'Soğuk',
      pros: ['Antoksidanlar çok zengin', 'Kalp sağlığına iyi', 'Doğal tat'],
      cons: ['Taze nar bulmak zor', 'Prep zamanı gerekli'],
      tip: 'Çayı ilk demlendikten sonra meyveler ekleyin.',
      preparation:
          '1. Yeşil çay (1 çanta)\n2. Nar (1 fincan suyu)\n3. Mirtil (1/2 fincan)\n4. Su (250 ml)\n5. Limon (1/4)\n\nYapılış: Çayı demlendikten sonra nar suyu ve mirtil ekle, soğut.',
      ingredients: ['çay', 'nar', 'mirtil', 'su', 'limon'],
      imageUrl: 'Assets/Categories/çay/nar mirtil çayı.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'mirtil': 'çilek'},
    ),
    // ── YENİ EKLENEN POPÜLER İÇECEKLER ──────────────────────────────────
    DrinkModel(
      id: 'hot-chocolate-deluxe',
      title: 'Lüks Sıcak Çikolata',
      category: 'Kahve',
      description:
          'Kıyılmış çikolata ve marshmallow ile hazırlanan zengin sıcak çikolata.',
      history:
          'Sıcak çikolata 16. yüzyılda İspanyol saraylarında asilzadelerin içeceği idi.',
      temperature: 'Sıcak',
      pros: [
        'Fenilletilmemiş (mood enhancer)',
        'Antoksidanlar zengin',
        'Rahatlatıcı'
      ],
      cons: ['Yüksek kalori', 'Şeker açısından yüksek', 'Kafein içerir'],
      tip: 'Süt açılı ruh hallerinde ideal. Gerçek çikolata kullanın.',
      preparation:
          '1. Koyu çikolata (50 g, kıyılmış)\n2. Tam yağlı süt (200 ml)\n3. Marshmallow (20 g)\n4. Vanilya (birkaç damla)\n5. Tatlı biber (çimdik)\n\nYapılış: Sütü ısıtın, çikolatayı ekleyin, pürüzsüz olana kadar karıştırın, marshmallow üstüne koyun.',
      ingredients: ['çikolata', 'süt', 'marshmallow', 'vanilya'],
      imageUrl: 'Assets/Categories/kahve/sıcak çikolata.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['laktoz', 'gluten (marshmallow)'],
      alternatives: {'marshmallow': 'whipped cream'},
    ),
    DrinkModel(
      id: 'kiwi-lemon-smoothie',
      title: 'Kivi Limon Smoothie',
      category: 'Smoothie',
      description: 'Taze kivi ve limon ile yapılmış canlı yeşil smoothie.',
      history:
          'Kivi Yeni Zelanda\'dan gelmiş, modern smoothie kültürüyle popüler olmuştur.',
      temperature: 'Soğuk',
      pros: [
        'Vitamin C açısından çok zengin',
        'Sindiriyi kolaylaştırır',
        'Enerji verici'
      ],
      cons: ['Kivi pahalı', 'Taze bulunması gerekli'],
      tip: 'Tam olgunlaşmış kivi kullanın.',
      preparation:
          '1. Kivi (4 adet, dilimlenmiş)\n2. Limon (1/2)\n3. Çiçek pekmezi (1 çay kaşığı)\n4. Barley rumba (100 ml)\n5. Buz (1/2 fincan)\n\nYapılış: Tüm malzemeleri blenderda pürüzsüz olana kadar çekin.',
      ingredients: ['kivi', 'limon', 'pekmez', 'barley rumba', 'buz'],
      imageUrl: 'Assets/Categories/smoothie/kivi limon smoothie.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'barley rumba': 'almond milk'},
    ),
    DrinkModel(
      id: 'rooibos-honey-tea',
      title: 'Rooibos Bal Çayı',
      category: 'Çay',
      description:
          'Güney Afrika\'nın kırmızı çayı rooibos ve balın kombinasyonu.',
      history:
          'Rooibos, Güney Afrika\'nın Xhosa halkı tarafından binlerce yıldır kullanılmaktadır.',
      temperature: 'Sıcak',
      pros: ['Kafein içermez', 'Mineral zengin', 'Uyku engeli yok'],
      cons: ['Farklı bir tat profili', 'Bulunması nadir'],
      tip: 'Akşam saatlerinde uyku kalitesini artırır.',
      preparation:
          '1. Rooibos çayı (1 çanta)\n2. Sıcak su (250 ml)\n3. Bal (1 yemek kaşığı)\n4. Limoncu cilantro (isteğe bağlı)\n\nYapılış: Çayı 5-7 dk demlendikten sonra balı ekleyip karıştırın.',
      ingredients: ['rooibos', 'su', 'bal', 'limon'],
      imageUrl: 'Assets/Categories/çay/rooibos bal çayı.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'bal': 'stevia'},
    ),
    DrinkModel(
      id: 'melon-cantaloupe-cooler',
      title: 'Kavun İçeceği',
      category: 'Frozen',
      description: 'Kavun ve limonun tatlı, serinletici kombinasyonu.',
      history: 'Yazın klasik serinletici içeceklerin başında gelir.',
      temperature: 'Soğuk',
      pros: ['Hidratasyonu destekler', 'Düşük kalori', 'Elektroliti dengeler'],
      cons: ['Sezonluk (yaz)', 'Taze kavun bulunması gerekli'],
      tip: 'Olgun kavun seçin, tadı daha tatlı olur.',
      preparation:
          '1. Kavun (3 fincan, küplü)\n2. Limon (1)\n3. Nane (5 yaprak)\n4. Su (150 ml)\n5. Buz\n\nYapılış: Kavun, limon ve mintı blenderda dön, buz ekleyip servis et.',
      ingredients: ['kavun', 'limon', 'nane', 'su', 'buz'],
      imageUrl: 'Assets/Categories/frozen/kavun frozen.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'kavun': 'mango'},
    ),
    DrinkModel(
      id: 'espresso-coconut-cream',
      title: 'Espresso Hindistancevizi Kremi',
      category: 'Kahve',
      description:
          'Güçlü espresso ile hindistancevizi kremi ve şeker tadının buluşması.',
      history: 'Filipin ve Tayland\'da popüler olan kahve çeşidi.',
      temperature: 'Sıcak',
      pros: [
        'Hindistancevizi yağları sağlıklı',
        'Yavaş enerji salınımı',
        'Kremamsı tat'
      ],
      cons: ['Kalori yüksek', 'Hindistancevizi kremi bulunması zorunlu'],
      tip:
          'Hindistancevizi kremi tabaka tabaka oluşturur, güzel görüntü sağlar.',
      preparation:
          '1. Espresso (60 ml)\n2. Hindistancevizi kremi (30 ml)\n3. Sıcak süt (100 ml)\n4. Şeker (1 çay kaşığı)\n\nYapılış: Bardağa hindistancevizi kremini koyun, sıcak espresso ekleyin, üstten sütü yavaşça döküp karıştırın.',
      ingredients: ['espresso', 'hindistancevizi kremi', 'süt', 'şeker'],
      imageUrl: 'Assets/Categories/kahve/espresso hindistan cevizi kremi.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein'],
      alternatives: {'hindistancevizi kremi': 'oat cream'},
    ),
    DrinkModel(
      id: 'açai-dragon-fruit-smoothie',
      title: 'Açaı Ejder Meyve Smoothie',
      category: 'Smoothie',
      description: 'Açaı ve ejder meyvesi ile renkli, besleyici smoothie bowl.',
      history:
          'Dragon fruit dünyada wellness trends ile birlikte popüler olmuştur.',
      temperature: 'Soğuk',
      pros: [
        'Antoksidanlar çok zengin',
        'Düşük kalori',
        'Vitaminler açısından başarılı'
      ],
      cons: ['Ejder meyve pahalı', 'Dondurulmuş burada tercih'],
      tip: 'Renkli bir görüntü için üste granola serpiştirebilirsiniz.',
      preparation:
          '1. Açaı paket (100 g)\n2. Ejder meyvesi (1 adet, dilimlenmiş)\n3. Elma (1/2)\n4. Coconut sütü (150 ml)\n5. Granola (3 çay kaşığı)\n\nYapılış: Açaı, ejder meyvesi ve elmayı blenderda dön, coconut sütü ekle, granola ile servis et.',
      ingredients: ['açaı', 'ejder meyvesi', 'elma', 'coconut sütü', 'granola'],
      imageUrl: 'Assets/Categories/smoothie/ejder meyve smoothie.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      alternatives: {'coconut sütü': 'almond milk'},
    ),
    DrinkModel(
      id: 'iced-brown-sugar-latte',
      title: 'Soğuk Kahverengi Şeker Latte',
      category: 'Kahve',
      description: 'Kahverengi şeker şurubu ile yapılmış tatlı soğuk latte.',
      history: 'Taiwanese bubble tea kültüründen esinlenmiş modern trend.',
      temperature: 'Soğuk',
      pros: [
        'Kahverengi şeker doğal tat',
        'Ferah ve tatlı denge',
        'Popüler trend'
      ],
      cons: ['Şeker açısından yüksek', 'Kahverengi şeker bulunması zorunlu'],
      tip:
          'Bardağın dibinde kahverengi şeker birikmesi normal, güzel görüntü yaratır.',
      preparation:
          '1. Kahverengi şeker (2 çay kaşığı)\n2. Sıcak su (1 çay kaşığı)\n3. Espresso (30 ml)\n4. Soğuk süt (150 ml)\n5. Buz (1 fincan)\n\nYapılış: Kahverengi şekeri suyla özelleştir, bardağa koy, espresso ve soğuk sütü ekle, buz dök.',
      ingredients: ['kahverengi şeker', 'espresso', 'süt', 'buz'],
      imageUrl: 'Assets/Categories/kahve/soğuk kahverengi şeker latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein', 'laktoz'],
      alternatives: {'süt': 'vegan milk'},
    ),
    DrinkModel(
      id: 'ginger-turmeric-shot',
      title: 'Zencefil Zerdeçal Şotu',
      category: 'Fit',
      description:
          'Güçlü ve sağlıklı zencefil ve zerdeçal karışımı, güne başlama içeceği.',
      history: 'Geleneksel Ayurveda tıbbından esinlenen modern sağlık trendi.',
      temperature: 'Sıcak',
      pros: [
        'Anti-inflamatuar güçlü',
        'İçeriğin soğuk algınlığına çok iyi',
        'Sindirim kolaylaştırır'
      ],
      cons: [
        'Tadı çok kuvvetli',
        'Mide hassasiyeti olan kişilere zor gelebilir'
      ],
      tip: 'Sabah açık karına içince daha etkili olur.',
      preparation:
          '1. Taze zencefil (2 cm)\n2. Zerdeçal (1 çay kaşığı)\n3. Siyah biber (çimdik)\n4. Limon (1/4)\n5. Sıcak su (50 ml)\n\nYapılış: Zencefili rendele, zerdeçal ve biber ekle, sıcak suyla ısıt, limon sık, tek yudumda iç.',
      ingredients: ['zencefil', 'zerdeçal', 'siyah biber', 'limon'],
      imageUrl: 'Assets/Categories/fit/zencefil zerdeçal shot.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
    ),
    DrinkModel(
      id: 'elderflower-spritzer',
      title: 'Elderflower Spritzer',
      category: 'Soda',
      description: 'Beyaz üzüm ve yabani filizle ferahlatıcı alkolsüz soda.',
      history:
          'Elderflower, Avrupa kırsalında yüzyıllardır yaz içeceklerinde kullanılır; modern spritzerlarla yeniden popüler oldu.',
      temperature: 'Soğuk',
      pros: ['Ferahlık verir', 'Düşük kalorili', 'Doğal antioksidanlar içerir'],
      cons: ['Elderflower şurubu her yerde bulunmayabilir', 'Hafif tatlıdır'],
      tip: 'Buzlu olarak servis edin ve limon kabuğu ekleyin.',
      preparation:
          '1. Elderflower şurubu (30 ml)\n2. Soda suyu (150 ml)\n3. Limon suyu (10 ml)\n4. Buz\n\nYapılış:\n1) Bardağa buz koyun\n2) Elderflower şurubunu ve limon suyunu ekleyin\n3) Soda suyunu yavaşça döküp karıştırın',
      ingredients: ['elderflower şurubu', 'soda suyu', 'limon', 'buz'],
      imageUrl: 'Assets/Categories/soda/elderflower spritzer.jpg',
      gradient: LinearGradient(colors: [Color(0xFFE8EAF6), Color(0xFFB3E5FC)]),
    ),
    DrinkModel(
      id: 'black-sesame-latte',
      title: 'Black Sesame Latte',
      category: 'Kahve',
      description: 'Susamlı, kremamsı ve hafif fındıksı bir latte deneyimi.',
      history:
          'Siyah susam, Doğu Asya mutfağında tatlı ve içecek tariflerinde uzun zamandır tercih edilir.',
      temperature: 'Sıcak',
      pros: [
        'Besleyici yağlar içerir',
        'Aromatik bir tat sunar',
        'Farklı bir latte alternatifi'
      ],
      cons: [
        'Susam alerjisi olanlar için uygun değil',
        'Yoğun kıvamı herkes sevmez'
      ],
      tip: 'Süt köpüğünü hafif tutun, üzerinde susam serpin.',
      preparation:
          '1. Siyah susam ezmesi (1 yemek kaşığı)\n2. Süt (200 ml)\n3. Şeker/honey (1 çay kaşığı)\n\nYapılış:\n1) Susam ezmesini az miktar sıcak sütte ezin\n2) Kalan sütü ısıtıp ekleyin\n3) Tatlandırıcıyı karıştırıp servis edin',
      ingredients: ['siyah susam', 'süt', 'şeker'],
      imageUrl: 'Assets/Categories/kahve/black sessame latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4E342E), Color(0xFFBCAAA4)]),
    ),
    DrinkModel(
      id: 'mango-green-tea',
      title: 'Mango Green Tea',
      category: 'Çay',
      description: 'Yeşil çay ve mango aromasıyla tropikal yaz çayı.',
      history:
          'Mango ve yeşil çay, Asya kültürlerinde tazeleyici içecekler olarak birlikte sunulur.',
      temperature: 'Soğuk',
      pros: ['Antioksidanlar sağlar', 'Ferahlık verir', 'Vitamin dolu'],
      cons: ['Mango mevsimsel olabilir', 'Çay tadı baskılanabilir'],
      tip: 'Soğuk demleme ile daha yumuşak bir tat elde edin.',
      preparation:
          '1. Yeşil çay poşeti (1)\n2. Sıcak su (200 ml)\n3. Mango suyu (100 ml)\n4. Buz\n\nYapılış:\n1) Yeşil çayı demlendirin ve soğutun\n2) Mango suyunu ekleyip buzla servis edin',
      ingredients: ['yeşil çay', 'mango suyu', 'buz'],
      imageUrl: 'Assets/Categories/çay/mango green tea.png',
      gradient: LinearGradient(colors: [Color(0xFF7CB342), Color(0xFFFFEB3B)]),
    ),
    DrinkModel(
      id: 'greek-yogurt-berry-smoothie',
      title: 'Greek Yogurt Berry Smoothie',
      category: 'Smoothie',
      description: 'Yoğurt bazlı kırmızı meyveli besleyici smoothie.',
      history:
          'Yunan yoğurdu, smoothie tarifleriyle küresel popülerliğe ulaşmıştır.',
      temperature: 'Soğuk',
      pros: ['Protein yüksektir', 'Probiyotik destekler', 'Tatlı ve hafif'],
      cons: ['Laktoz içerebilir', 'Yoğun kıvamlı olabilir'],
      tip: 'Granola ile servis edebilirsiniz.',
      preparation:
          '1. Yunan yoğurdu (150 g)\n2. Karışık kırmızı meyveler (1 fincan)\n3. Ballı şurup (1 çay kaşığı)\n4. Buz\n\nYapılış:\n1) Tüm malzemeleri blenderda pürüzsüz olana kadar çekin',
      ingredients: ['yoğurt', 'çilek', 'böğürtlen', 'bal', 'buz'],
      imageUrl: 'Assets/Categories/smoothie/greek yogurt berry smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFFBA68C8), Color(0xFFFFCDD2)]),
    ),
    DrinkModel(
      id: 'spiced-apple-cider',
      title: 'Spiced Apple Cider',
      category: 'Çay',
      description: 'Sıcak elma suyu, tarçın ve karanfil ile baharatlı içecek.',
      history:
          'Baharatlı elma suyu, soğuk kış günlerinde Avrupa ve Amerika’da sevilen bir gelenektir.',
      temperature: 'Sıcak',
      pros: [
        'Rahatlatıcı bir aroma',
        'Bağışıklık sistemini destekler',
        'Kış için ideal'
      ],
      cons: ['Şeker içerir', 'Bazı baharatlar hassas mideye neden olabilir'],
      tip: 'Tarçın çubuğu ile servis edin.',
      preparation:
          '1. Elma suyu (200 ml)\n2. Tarçın çubuğu (1)\n3. Karanfil (3 adet)\n4. Portakal kabuğu\n\nYapılış:\n1) Tüm malzemeleri 10 dk kaynatın\n2) Süzüp sıcak servis edin',
      ingredients: ['elma suyu', 'tarçın', 'karanfil', 'portakal kabuğu'],
      imageUrl: 'Assets/Categories/çay/spiced apple cider.png',
      gradient: LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFD84315)]),
    ),
    DrinkModel(
      id: 'cucumber-mint-water',
      title: 'Cucumber Mint Water',
      category: 'Fit',
      description: 'Salatalık ve nane ile düşük kalorili detoks suyu.',
      history:
          'Nane ve salatalık suyu, yaz aylarında ferahlatıcı bir hidrate kaynağı olarak kullanılır.',
      temperature: 'Soğuk',
      pros: ['Hafif ve ferahlatıcı', 'Düşük kalorili', 'Cilt için faydalı'],
      cons: ['Taze malzeme ister', 'Kısa sürede bozulabilir'],
      tip: 'Nane yapraklarını hafifçe ezin.',
      preparation:
          '1. Salatalık (yarım, dilimlenmiş)\n2. Taze nane (5-6 yaprak)\n3. Su (300 ml)\n4. Limon dilimi\n\nYapılış:\n1) Malzemeleri suya ekleyin\n2) 1 saat buzdolabında bekletip servis edin',
      ingredients: ['salatalık', 'nane', 'su', 'limon'],
      imageUrl: 'Assets/Categories/fit/cucumber mint water.jpg',
      gradient: LinearGradient(colors: [Color(0xFF81C784), Color(0xFFB2FF59)]),
    ),
    DrinkModel(
      id: 'blue-lagoon-mocktail',
      title: 'Blue Lagoon Mocktail',
      category: 'Kokteyl',
      description: 'Mavi curacao aroması olmayan, alkolsüz tropik kokteyl.',
      history:
          'Mocktail kültürü, alkol yerine aromatik karışımlar sunarak herkes için keyifli içecekler yaratır.',
      temperature: 'Soğuk',
      pros: ['Alkolsüz', 'Renkli ve eğlenceli', 'Yaz için ideal'],
      cons: [
        'Mavi tonlu katkı maddeleri içerebilir',
        'Çocuklar için tatlı olabilir'
      ],
      tip: 'Garnitür olarak kiraz kullanın.',
      preparation:
          '1. Ananas suyu (100 ml)\n2. Lime suyu (15 ml)\n3. Mavi şurup (10 ml)\n4. Soda suyu (100 ml)\n5. Buz\n\nYapılış:\n1) Tüm sıvıları karıştırın\n2) Bardağa buz ekleyip servis edin',
      ingredients: ['ananas suyu', 'lime', 'mavi şurup', 'soda suyu', 'buz'],
      imageUrl: 'Assets/Categories/kokteyl/blue lagoon mocktail.png',
      gradient: LinearGradient(colors: [Color(0xFF03A9F4), Color(0xFF81D4FA)]),
    ),
    DrinkModel(
      id: 'pumpkin-spice-latte',
      title: 'Pumpkin Spice Latte',
      category: 'Kahve',
      description: 'Balkabağı baharatı ve espresso ile mevsimsel sıcak latte.',
      history:
          'Pumpkin spice latte, son yıllarda sonbahar cafelerinin simgesi haline geldi.',
      temperature: 'Sıcak',
      pros: ['Mevsimsel tatlı aroma', 'Rahatlatıcı', 'Kahve ile uyumlu'],
      cons: [
        'Şeker içeriği yüksek olabilir',
        'Balkabağı aroması herkesin tercihi değil'
      ],
      tip: 'Tarçın serpiştirerek servis edin.',
      preparation:
          '1. Espresso (30 ml)\n2. Balkabağı püresi (1 yemek kaşığı)\n3. Balkabağı baharatı (1 çay kaşığı)\n4. Süt (200 ml)\n5. Vanilya şurubu (1 çay kaşığı)\n\nYapılış:\n1) Espressoyu hazırlayın\n2) Balkabağı püresi ve baharatları sütle ısıtın\n3) Espressoya ekleyip karıştırın',
      ingredients: ['espresso', 'balkabağı püresi', 'süt', 'tarçın', 'vanilya'],
      imageUrl: 'Assets/Categories/kahve/pumpkin spice latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFEF6C00)]),
    ),
    DrinkModel(
      id: 'spiced-caramel-cold-brew',
      title: 'Spiced Caramel Cold Brew',
      category: 'Kahve',
      description: 'Karamel baharatı ile tatlandırılmış soğuk demleme kahve.',
      history:
          'Soğuk demleme kahve, 21. yüzyılın coffee shop trendlerinden biridir; baharatlı karamel dokunuşu ise son zamanlarda popülerleşti.',
      temperature: 'Soğuk',
      pros: ['Düşük asitli', 'Zengin tat profili', 'Enerji verici'],
      cons: ['Yüksek şeker içerebilir', 'Hazırlama süresi uzun'],
      tip: 'Karamel ve tarçını şeker yerine gerçek baharatlarla dengeleyin.',
      preparation:
          '1. Cold brew (150 ml)\n2. Karamel şurubu (2 çay kaşığı)\n3. Tarçın (bir tutam)\n4. Buz\n5. Süt (50 ml)\n\nYapılış:\n1) Bardağa buz koyun\n2) Cold brew ekleyin\n3) Karamel şurubu ve tarçını ekleyin\n4) Sütü ilave edin\n5) Karıştırarak servis edin',
      ingredients: ['cold brew', 'karamel şurubu', 'tarçın', 'buz', 'süt'],
      imageUrl: 'Assets/Categories/kahve/spiced caramel cold brew.jpg',
      gradient: LinearGradient(colors: [Color(0xFF5D4037), Color(0xFFFFD54F)]),
    ),
    DrinkModel(
      id: 'blueberry-elderflower-soda',
      title: 'Blueberry Elderflower Soda',
      category: 'Soda',
      description:
          'Yaban mersini ve ağaçkakışı şurubu ile hafif ve ferahlatıcı soda.',
      history:
          'Ağaçkakışı şurubu 19. yüzyıldan beri Avrupa içeceklerinde kullanılır; yaban mersini ile birleşimi modern soda trendidir.',
      temperature: 'Soğuk',
      pros: ['Doğal antioksidanlar', 'Düşük kalori', 'Göz alıcı renk'],
      cons: [
        'Ağaçkakışı şurubu bulmak zor olabilir',
        'Hafif şekerli tadı herkese hitap etmeyebilir'
      ],
      tip: 'Taze nane yaprağıyla servis edin.',
      preparation:
          '1. Ağaçkakışı şurubu (20 ml)\n2. Yaban mersini (50 g)\n3. Limon suyu (10 ml)\n4. Soda suyu (150 ml)\n5. Buz\n\nYapılış:\n1) Yaban mersinlerini hafifçe ezin\n2) Şurup ve limon suyunu ekleyin\n3) Soda suyunu ilave edin\n4) Buz ekleyerek servis edin',
      ingredients: [
        'ağaçkakışı şurubu',
        'yaban mersini',
        'limon',
        'soda suyu',
        'buz'
      ],
      imageUrl: 'Assets/Categories/soda/blueberry elderflower soda.jpg',
      gradient: LinearGradient(colors: [Color(0xFF283593), Color(0xFF7C4DFF)]),
    ),
    DrinkModel(
      id: 'almond-matcha-protein-smoothie',
      title: 'Almond Matcha Protein Smoothie',
      category: 'Smoothie',
      description:
          'Matcha, badem sütü ve protein tozu ile besleyici bir smoothie.',
      history:
          'Matcha smoothie konsepti, sağlıklı yaşam ve protein içeriklerinin buluşmasıyla fitness kafe menülerinde yaygınlaştı.',
      temperature: 'Soğuk',
      pros: [
        'Yüksek protein',
        'L-theanine ile dengeli enerji',
        'Vegan alternatifli'
      ],
      cons: ['Matcha pahalı olabilir', 'Bazı kişiler için yoğun tatlı'],
      tip: 'Oat milk veya badem sütü ile hafif bir kıvam elde edin.',
      preparation:
          '1. Matcha tozu (1 çay kaşığı)\n2. Badem sütü (200 ml)\n3. Vanilyalı protein tozu (1 ölçek)\n4. Muz (1/2)\n5. Buz\n\nYapılış:\n1) Tüm malzemeleri blenderda pürüzsüz olana kadar karıştır\n2) Hemen servis et',
      ingredients: ['matcha tozu', 'badem sütü', 'protein tozu', 'muz', 'buz'],
      imageUrl: 'Assets/Categories/smoothie/almond matchaprotein smoothie.jpg',
      gradient: LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF4A148C)]),
    ),
    DrinkModel(
      id: 'sparkling-apple-tea',
      title: 'Sparkling Apple Tea',
      category: 'Çay',
      description: 'Gazlı elma çayı, ferahlatıcı ve hafif meyveli bir içecek.',
      history:
          'Meyveli çaylara soda ekleme trendi, batı café kültüründe son yıllarda hızla yayıldı.',
      temperature: 'Soğuk',
      pros: ['Ferahlatıcı', 'Düşük kalori', 'Doğal meyve aroması'],
      cons: [
        'Soda karbonasyonu bazılarını rahatsız edebilir',
        'Tat yoğunluğu meyveye bağlı'
      ],
      tip: 'Soğuk demleme elma çayı kullanırsanız acılığı azaltır.',
      preparation:
          '1. Demlenmiş elma çayı (150 ml)\n2. Elma suyu (50 ml)\n3. Soda suyu (100 ml)\n4. Limon dilimi\n5. Buz\n\nYapılış:\n1) Bardağa buz koy\n2) Elma çayı ve elma suyunu ekle\n3) Soda suyunu ilave et\n4) Limon dilimi ile servis et',
      ingredients: ['elma çayı', 'elma suyu', 'soda suyu', 'limon', 'buz'],
      imageUrl: 'Assets/Categories/çay/sparkling apple tea.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFFA000), Color(0xFFFFEB3B)]),
    ),
    DrinkModel(
      id: 'raw-ginger-shot',
      title: 'Raw Ginger Shot',
      category: 'Fit',
      description: 'Doğal zencefil ile hazırlanan sıcak ve canlandırıcı şot.',
      history:
          'Zencefil şotları, doğal sağlık içeceği trendi içinde popülerleşen güçlü bir bağışıklık desteğidir.',
      temperature: 'Soğuk',
      pros: ['Anti-inflamatuar', 'Sindirim destekleyici', 'Hızlı enerji'],
      cons: ['Tadi çok kuvvetli', 'Mide hassasiyeti olanlar için zorlayıcı'],
      tip: 'Aç karnına küçük bir yudum alın.',
      preparation:
          '1. Taze zencefil (30 g)\n2. Limon suyu (15 ml)\n3. Bal (1 çay kaşığı)\n4. Su (50 ml)\n\nYapılış:\n1) Zencefili rendeleyin ve suyla blenderda çekin\n2) Limon suyu ve bal ekleyin\n3) Süzerek küçük bir bardakta servis edin',
      ingredients: ['zencefil', 'limon', 'bal', 'su'],
      imageUrl: 'Assets/Categories/fit/raw ginder shot.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFF8A65), Color(0xFFFF7043)]),
    ),
    DrinkModel(
      id: 'stevia-lemonade',
      title: 'Stevia Limonata',
      category: 'Soda',
      description: 'Şeker ilavesiz, stevia ile tatlandırılmış doğal limonata.',
      temperature: 'Soğuk',
      pros: ['Sıfır şeker', 'Düşük kalori', 'C vitamini deposu'],
      cons: ['Stevia tadı herkesin damak zevkine uymayabilir'],
      tip:
          'Taze nane yaprakları ile servis edildiğinde ferahlığı ikiye katlanır.',
      preparation:
          '1. 2 adet limonun suyu\n2. 500ml su\n3. 1 çay kaşığı stevia\n4. Buz\n\nYapılış: Limon suyunu su ve stevia ile karıştırın, buz ekleyin.',
      ingredients: ['limon', 'su', 'stevia', 'nane'],
      imageUrl: 'Assets/Categories/soda/stevia limonata.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: [],
      alternatives: {},
    ),
    DrinkModel(
      id: 'oat-milk-iced-latte',
      title: 'Yulaf Sütlü Soğuk Latte',
      category: 'Kahve',
      description:
          'Süt (laktoz) içermeyen, yulaf sütünün kremsi dokusuyla hazırlanan latte.',
      temperature: 'Soğuk',
      pros: ['Vegan dostu', 'Laktozsuz', 'Doğal yulaf tatlılığı'],
      cons: ['Kafein içerir'],
      tip:
          'Yulaf sütünü çalkalayarak eklerseniz daha köpüklü bir doku elde edersiniz.',
      preparation:
          '1. 1 shot espresso\n2. 200ml yulaf sütü\n3. Buz\n\nYapılış: Bardağa buz ve yulaf sütünü koyun, üzerine espressoyu yavaşça dökün.',
      ingredients: ['espresso', 'yulaf sütü', 'buz'],
      imageUrl: 'Assets/Categories/kahve/yulaf sütlü soğuk latte.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein'],
      alternatives: {'kafein': 'decaf espresso'},
    ),
    DrinkModel(
      id: 'keto-bulletproof-coffee',
      title: 'Keto Bulletproof Kahve',
      category: 'Kahve',
      description: 'Şeker ve süt içermeyen, yüksek enerjili ketojenik kahve.',
      temperature: 'Sıcak',
      pros: ['Uzun süre tokluk sağlar', 'Odaklanmayı artırır', 'Şekersiz'],
      cons: ['Yüksek yağ oranı', 'Alışık olmayanlar için ağır gelebilir'],
      tip: 'Hindistancevizi yağı yerine MCT yağı da kullanabilirsiniz.',
      preparation:
          '1. 1 kupa filtre kahve\n2. 1 tatlı kaşığı tuzsuz tereyağı\n3. 1 tatlı kaşığı hindistancevizi yağı\n\nYapılış: Tüm malzemeleri blenderda köpürene kadar 30 saniye çekin.',
      ingredients: ['kahve', 'tereyağı', 'hindistancevizi yağı'],
      imageUrl: 'Assets/Categories/kahve/ketto bulletproof kahve.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein', 'süt (tereyağı)'],
      alternatives: {'tereyağı': 'vegan tereyağı'},
    ),
    DrinkModel(
      id: 'detox-green-tea-no-sugar',
      title: 'Detoks Yeşil Çay',
      category: 'Çay',
      description:
          'Şekersiz, ödem attıran ve metabolizma hızlandıran bitki çayı.',
      temperature: 'Sıcak',
      pros: ['Antioksidan zengini', 'Şekersiz', 'Detoks etkili'],
      cons: ['Hamilelerin tüketimi öncesi danışması önerilir'],
      tip:
          'İçine bir adet çubuk tarçın atarak doğal bir tatlılık verebilirsiniz.',
      preparation:
          '1. Yeşil çay\n2. Bir dilim taze zencefil\n3. Çeyrek limon\n\nYapılış: Yeşil çayı zencefil ile demleyin, süzdükten sonra limon ekleyin.',
      ingredients: ['yeşil çay', 'zencefil', 'limon'],
      imageUrl: 'Assets/Categories/çay/detoks yeşil çay.png',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: [],
      alternatives: {},
    ),
    DrinkModel(
      id: 'pure-black-americano',
      title: 'Sade Americano',
      category: 'Kahve',
      description: 'Süt ve şeker içermeyen, en saf kahve deneyimi.',
      temperature: 'Sıcak',
      pros: ['Sıfır kalori', 'Net kahve aroması', 'Hızlı hazırlama'],
      cons: ['Sert tadı herkese hitap etmeyebilir'],
      tip:
          'Yumuşak içim için çekirdeklerin orta kavrulmuş olmasını tercih edin.',
      preparation:
          '1. Double shot espresso\n2. Sıcak su\n\nYapılış: Espressonun üzerine sıcak su ekleyerek servis edin.',
      ingredients: ['espresso', 'su'],
      imageUrl: 'Assets/Categories/kahve/americano.jpg',
      gradient: LinearGradient(colors: [Color(0xFF4B2C20), Color(0xFF8B4513)]),
      allergens: ['kafein'],
      alternatives: {'kafein': 'decaf espresso'},
    ),
    DrinkModel(
      id: 'flat-white-classic',
      title: 'Flat White',
      category: 'Kahve',
      description: 'Kadifemsi süt dokusu ve yoğun espresso dengesi.',
      history: '1980\'lerde Avustralya ve Yeni Zelanda\'da popülerleşen bu içecek, latteye göre daha az süt köpüğü ve daha yoğun kahve tadı sunar.',
      temperature: 'Sıcak',
      pros: ['Güçlü kahve aroması', 'Pürüzsüz içim', 'Düşük süt oranı'],
      cons: ['Hızlı soğuyabilir', 'Kafein oranı yüksektir'],
      tip: 'Sütün mikro köpük kıvamında olması çok önemlidir; kalın köpük latteye dönüştürür.',
      preparation: '1. Double shot espresso (60 ml) hazırlayın.\n2. Sütü 65 derecede ısıtıp mikro köpük oluşturun.\n3. Espresso üzerine yavaşça dökün.',
      ingredients: ['espresso', 'süt'],
      imageUrl: 'Assets/Categories/kahve/flat white.jpg',
      gradient: LinearGradient(colors: [Color(0xFF6F4E37), Color(0xFFD2B48C)]),
    ),
    DrinkModel(
      id: 'london-fog-tea',
      title: 'London Fog',
      category: 'Çay',
      description: 'Earl Grey, vanilya ve sütün huzurlu buluşması.',
      history: 'Adına rağmen Kanada\'nın Vancouver şehrinde ortaya çıkmıştır. Sisli sabahları andıran görüntüsü nedeniyle bu adı almıştır.',
      temperature: 'Sıcak',
      pros: ['Sakinleştirici etki', 'Egzotik bergamot kokusu', 'Hafif tatlı'],
      cons: ['Sütlü çay sevmeyenler için uygun olmayabilir'],
      tip: 'Bergamot aromasını bozmamak için vanilya şurubunu çok az kullanın.',
      preparation: '1. Earl Grey çayını demleyin.\n2. İçine vanilya özütü veya şurubu ekleyin.\n3. Üzerine köpürtülmüş sıcak süt ekleyerek servis edin.',
      ingredients: ['earl grey', 'süt', 'vanilya'],
      imageUrl: 'Assets/Categories/çay/london fog.jpg',
      gradient: LinearGradient(colors: [Color(0xFFBDBDBD), Color(0xFF5D4037)]),
    ),
    DrinkModel(
      id: 'pb-banana-smoothie',
      title: 'Fıstık Ezmeli Muzlu Smoothie',
      category: 'Smoothie',
      description: 'Doyurucu fıstık ezmesi ve muzun enerji dolu uyumu.',
      history: 'Ev yapımı enerji içeceklerinin atasıdır. Protein barlarının sıvı versiyonu olarak spor dünyasında kabul görmüştür.',
      temperature: 'Soğuk',
      pros: ['Yüksek protein ve potasyum', 'Çok doyurucu', 'Tatlı ihtiyacını giderir'],
      cons: ['Kalorisi yüksektir'],
      tip: 'Muzları dondurarak kullanırsanız buz eklemenize gerek kalmaz ve daha kremsi olur.',
      preparation: '1. Bir adet olgun muzu dilimleyin.\n2. 1 yemek kaşığı fıstık ezmesi ve 1 bardak süt ekleyin.\n3. Blenderdan geçirin.',
      ingredients: ['muz', 'fistik ezmesi', 'süt', 'bal'],
      imageUrl: 'Assets/Categories/smoothie/pb banana.jpg',
      gradient: LinearGradient(colors: [Color(0xFFD2B48C), Color(0xFFF5DEB3)]),
    ),
    DrinkModel(
      id: 'cucumber-lime-soda',
      title: 'Salatalık & Lime Soda',
      category: 'Soda',
      description: 'Salatalık ve lime ile ultra ferahlatıcı düşük kalorili içecek.',
      history: 'Spa merkezlerinde detoks suyu olarak başlayan bu ikili, maden suyu ile birleşerek sağlıklı bir gazlı içecek alternatifine dönüşmüştür.',
      temperature: 'Soğuk',
      pros: ['Sıfıra yakın kalori', 'Ödem attırıcı', 'Anında ferahlık'],
      cons: ['Taze salatalık şarttır'],
      tip: 'Salatalıkları ince şeritler halinde kesip bardağın kenarına yapıştırarak şık bir sunum yapabilirsiniz.',
      preparation: '1. Salatalık dilimlerini bardağa koyun.\n2. Yarım lime suyunu sıkın.\n3. Üzerine soğuk maden suyu ekleyin ve nane ile süsleyin.',
      ingredients: ['salatalik', 'lime', 'maden suyu', 'nane'],
      imageUrl: 'Assets/Categories/soda/cucumber soda.jpg',
      gradient: LinearGradient(colors: [Color(0xFFDCEDC8), Color(0xFF4CAF50)]),
    ),
    DrinkModel(
      id: 'golden-milk-hot',
      title: 'Altın Süt (Golden Milk)',
      category: 'Fit',
      description: 'Zerdeçal ve baharatlarla hazırlanan şifalı bir sıcak içecek.',
      history: 'Ayurvedik tıbbın binlerce yıllık reçetesidir. Hindistan\'da "Haldi Doodh" adıyla bağışıklık güçlendirici olarak bilinir.',
      temperature: 'Sıcak',
      pros: ['Güçlü anti-inflamatuar', 'Uykuyu düzenler', 'Metabolizmayı hızlandırır'],
      cons: ['Zerdeçalın tadı herkese uymayabilir'],
      tip: 'Zerdeçaldaki kurkuminin emilmesi için bir tutam karabiber eklemek zorunludur.',
      preparation: '1. Bir bardak sütü ısıtın.\n2. Yarım çay kaşığı zerdeçal, bir tutam karabiber ve tarçın ekleyin.\n3. Bal ile tatlandırıp süzerek için.',
      ingredients: ['süt', 'zerdeçal', 'karabiber', 'tarçin', 'bal'],
      imageUrl: 'Assets/Categories/fit/golden milk.jpg',
      gradient: LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFFF6F00)]),
    ),
  ];
}
