import 'package:flutter/material.dart';
import 'package:trenddrink/core/models/drink_model.dart';

class DrinkLocalSource {
  Future<List<DrinkModel>> fetchDrinks() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _mockDrinks;
  }

  static final List<DrinkModel> _mockDrinks = [
    DrinkModel(
      id: 'espresso-martini',
      title: 'Espresso Martini',
      category: 'Kokteyl',
      description: 'Kafein enerjisi ile akşam kokteyli buluşuyor.',
      preparation:
          'Malzemelerin Sırası:\n1. Espresso\n2. Vodka\n3. Kahve likörü\n4. Şeker şurubu\n5. Buz\n\nYapılış:\n1) Shakera espresso, vodka ve şeker şurubunu ekle\n2) Buz ekle\n3) Güçlü sallayarak köpük elde et\n4) Soğuk kokteyl bardağına süz\n5) Kahve çekirdeği ile servis et',
      ingredients: ['espresso', 'vodka', 'kahve likörü', 'şeker şurubu'],
      imageUrl: 'https://images.unsplash.com/photo-1603593786277-22749449f225?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Keep this image
      gradient: const LinearGradient(
        colors: [Color(0xFF2C1E1E), Color(0xFF5A3A3A)], // Darker, coffee-like gradient
      ),
    ),
    DrinkModel(
      id: 'cocoa-frozen-latte',
      title: 'Cocoa Frozen Latte',
      category: 'Frozen',
      description: 'Soğuk, kremsi ve bitter tatlı bir deneyim.',
      preparation:
          'Malzemelerin Sırası:\n1. Buz (1 fincan)\n2. Süt (200 ml)\n3. Kakao tozu (2 yemek kaşığı)\n4. Vanilya ekstresi (1 çay kaşığı)\n5. Çikolata parçaları (süsleme)\n\nYapılış:\n1) Blenderda buz, süt ve kakao tozunu ekle\n2) Vanilya ekstresi ekle\n3) Pürüzsüz doku elde edene kadar karıştır\n4) Bardağa dök\n5) Çikolata parçaları ile süsle',
      ingredients: ['buz', 'süt', 'kakao tozu', 'vanilya ekstresi'],
      imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF20002C), Color(0xFFC58E256A)],
      ),
    ),
    DrinkModel(
      id: 'iced-hazelnut-mocha',
      title: 'Iced Hazelnut Mocha',
      category: 'Kahve',
      description: 'Fındıklıyken soğuk, çikolatalı ve ferah bir kahve seçeneği.',
      preparation:
          'Malzemelerin Sırası:\n1. Espresso (1 shot, 30 ml)\n2. Fındık şurubu (2 yemek kaşığı)\n3. Süt (150 ml)\n4. Buz (1 fincan)\n5. Krem şanti (süsleme)\n6. Kakao tozu (süsleme)\n\nYapılış:\n1) Bardağa espresso ve fındık şurubunu ekle\n2) Soğuk sütü ekle ve karıştır\n3) Buz dolu bardağa dök\n4) Üzerine krem şanti ekle\n5) Kakao tozu serpiştirerek servis et',
      ingredients: ['espresso', 'süt', 'fındık şurubu', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1596041113649-3011c0349899?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Keep this image
      gradient: const LinearGradient(
        colors: [Color(0xFF4B2C20), Color(0xFF8B4513)], // Brown/nutty gradient
      ),
    ),
    DrinkModel(
      id: 'matcha-coconut-cooler',
      title: 'Matcha Coconut Cooler',
      category: 'Kokteyl',
      description: 'Yeşil çayla tropikal tatların serinletici buluşması.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Hindistancevizi sütü (150 ml)\n4. Lime suyu (2 çay kaşığı)\n5. Şeker (1 yemek kaşığı)\n6. Buz (1 fincan)\n7. Nane yaprakları (süsleme)\n\nYapılış:\n1) Matcha tozunu sıcak suyla çalkala\n2) Hindistancevizi sütü ekle ve karıştır\n3) Lime suyu ve şeker ekle\n4) Buz dolu bardağa dök\n5) Nane yaprakları ile süsle',
      ingredients: ['matcha', 'hindistancevizi sütü', 'lime', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF3CA55C), Color(0xB0B5AC49)],
      ),
    ),
    DrinkModel(
      id: 'caramel-cold-brew',
      title: 'Caramel Cold Brew',
      category: 'Kahve',
      description: 'Karamelin derinliği ile soğuk demleme kahvenin harmanı.',
      preparation:
          'Malzemelerin Sırası:\n1. Buz (1 fincan)\n2. Cold brew (150 ml)\n3. Karamelli süt (100 ml)\n4. Karamel sos (3 yemek kaşığı)\n5. Çırpılmış krem (süsleme)\n\nYapılış:\n1) Bardağa buz ekle\n2) Cold brew dökerek yarısına kadar dol\n3) Karamelli sütü ekle\n4) Karamel sosu bardağın kenarından gezdir\n5) Çırpılmış krem ile servis et',
      ingredients: ['buz', 'cold brew', 'karamelli süt', 'karamel sos'],
      imageUrl: 'https://images.unsplash.com/photo-1580613854894-37517173e659?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // More specific caramel cold brew
      gradient: const LinearGradient(
        colors: [Color(0xFFA0522D), Color(0xFFD2B48C)], // Caramel/tan gradient
      ),
    ),
    DrinkModel(
      id: 'hibiscus-sparkler',
      title: 'Hibiscus Sparkler',
      category: 'Soda',
      description: 'Nar çiçeği ve limonla parlak, serinletici bir soda.',
      preparation:
          'Malzemelerin Sırası:\n1. Hibiskus (kurutulmuş, 2 çay kaşığı)\n2. Sıcak su (200 ml)\n3. Şeker (2 çay kaşığı)\n4. Limon suyu (3 çay kaşığı)\n5. Maden suyu (100 ml)\n6. Buz (1 fincan)\n7. Nane yaprakları (süsleme)\n\nYapılış:\n1) Hibiskusu sıcak suyla 5 dakika demlemeye bırak\n2) Demlenmiş çayı soğut\n3) Şeker ekle ve karıştır\n4) Limon suyu ekle\n5) Buz dolu bardağa dök\n6) Maden suyu ekle\n7) Nane ile süsle',
      ingredients: ['hibiskus', 'şeker', 'limon suyu', 'maden suyu'],
      imageUrl: 'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFB31217), Color(0xFFFCE38A)],
      ),
    ),
    DrinkModel(
      id: 'citrus-cold-brew',
      title: 'Citrus Cold Brew',
      category: 'Kahve',
      description: 'Taze turunçgil ve soğuk demleme kahvenin ferah buluşması.',
      preparation:
          'Malzemelerin Sırası:\n1. Cold brew (150 ml)\n2. Portakal suyu (100 ml)\n3. Limon suyu (1 çay kaşığı)\n4. Süt (50 ml)\n5. Buz (1 fincan)\n6. Portakal dilimi (süsleme)\n\nYapılış:\n1) Bardağa buz ekle\n2) Cold brew ekle\n3) Portakal ve limon suyunu karıştır\n4) Soğuk sütü ekle\n5) Hafif karıştır\n6) Portakal dilimi ile süsle',
      ingredients: ['cold brew', 'portakal', 'buz', 'şeker'],
      imageUrl: 'https://images.unsplash.com/photo-1517712981146-06dc73adc36d?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF0B486B), Color(0xFFF56217)],
      ),
    ),
    DrinkModel(
      id: 'strawberry-basil-smoothie',
      title: 'Strawberry Basil Smoothie',
      category: 'Smoothie',
      description: 'Çilek, fesleğen ve yoğurdun serinletici karışımı.',
      preparation:
          'Malzemelerin Sırası:\n1. Çilek (250 g)\n2. Yoğurt (150 g)\n3. Fesleğen yaprakları (10-12 adet)\n4. Bal (1 yemek kaşığı)\n5. Buz (1 fincan)\n\nYapılış:\n1) Blenderda çilekleri koy\n2) Yoğurt ekle ve karıştır\n3) Fesleğen yapraklarını ekle\n4) Bal ve buz ekle\n5) Pürüzsüz kıvama kadar karıştır\n6) Hemen soğuk servis et',
      ingredients: ['çilek', 'yoğurt', 'fesleğen', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1543644009-1d206f47094b?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFED213A), Color(0xFFFFA500)],
      ),
    ),
    DrinkModel(
      id: 'vanilla-iced-cappuccino',
      title: 'Vanilla Iced Cappuccino',
      category: 'Kahve',
      description: 'Kremamsı vanilya aroması ile klasik cappuccino tazeliği.',
      preparation:
          'Malzemelerin Sırası:\n1. Espresso (30 ml)\n2. Vanilya şurubu (2 yemek kaşığı)\n3. Soğuk süt (150 ml)\n4. Buz (1 fincan)\n5. Çırpılmış krem (süsleme)\n\nYapılış:\n1) Şekerli bir bardağa espresso ve vanilya şurubunu ekle\n2) Buz dolu bardağa dök\n3) Soğuk sütü yavaşça ekle ve karıştır\n4) Üzerine çırpılmış krem ekle\n5) Kakao tozu veya vanilya serpiştirerek servis et',
      ingredients: ['espresso', 'süt', 'vanilya', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFF5DEB3), Color(0xFFD2B48C)], // Creamy/vanilla gradient
      ),
    ),
    DrinkModel(
      id: 'orange-spiced-tea',
      title: 'Orange Spiced Tea',
      category: 'Çay',
      description: 'Tarçın ve portakal ile sıcak, aromatik bir çay deneyimi.',
      preparation:
          'Malzemelerin Sırası:\n1. Siyah çay (1 poşet veya 1 çay kaşığı)\n2. Sıcak su (250 ml)\n3. Tarçın çubuğu (1 adet)\n4. Portakal kabuğu (kurutulmuş, 1 çay kaşığı)\n5. Bal (1-2 yemek kaşığı)\n6. Portakal dilimi (süsleme)\n\nYapılış:\n1) Sıcak suya çay poşetini koy\n2) Tarçın çubuğu ve portakal kabuğunu ekle\n3) 5 dakika demlemeye bırak\n4) Çayı süz\n5) Bala ekle ve karıştır\n6) Portakal dilimiyle servis et',
      ingredients: ['çay', 'tarçın', 'portakal', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1576092762740-410023a10526?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      gradient: const LinearGradient(
        colors: [Color(0xFFD2691E), Color(0xFFFFA500)], // Orange/spiced gradient
      ),
    ),
    DrinkModel(
      id: 'berry-kombucha',
      title: 'Berry Kombucha',
      category: 'Soda',
      description: 'Şerbetçiotu ferahlığıyla kırmızı meyveli kombucha.',
      preparation:
          'Malzemelerin Sırası:\n1. Kombucha (250 ml)\n2. Frambuaz (100 g)\n3. Böğürtlen (100 g)\n4. Buz (1 fincan)\n5. Nane yaprakları (5-6 yaprak)\n\nYapılış:\n1) Buz dolu bardağa kombucha dök\n2) Frambuaz ve böğürtlenleri ekle\n3) Hafif karıştır\n4) Nane yapraklarını sapından çıkar ve ekle\n5) Taze servis et',
      ingredients: ['kombucha', 'frambuaz', 'böğürtlen', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1594498653385-d5172b532c00?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF000428), Color(0xFF004e92)],
      ),
    ),
    DrinkModel(
      id: 'mango-lassi',
      title: 'Mango Lassi',
      category: 'Smoothie',
      description: 'Egzotik mango ve yoğurdun tazeleyici buluşması.',
      preparation:
          'Malzemelerin Sırası:\n1. Mango (1 adet, 300 g)\n2. Yoğurt (200 g)\n3. Soğuk süt (100 ml)\n4. Tarçın (1 çay kaşığı)\n5. Bal (1 yemek kaşığı)\n6. Buz (1/2 fincan)\n\nYapılış:\n1) Mangonun etini blenderda koy\n2) Yoğurt ekle\n3) Soğuk sütü ekle\n4) Tarçın ve bal ekle\n5) Buzla birlikte pürüzsüz kıvama kadar karıştır\n6) Buzlu bardağa dök ve hemen servis et',
      ingredients: ['mango', 'yoğurt', 'süt', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1594056294711-28562479e491?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
      ),
    ),
    DrinkModel(
      id: 'lavender-latte',
      title: 'Lavender Latte',
      category: 'Kahve',
      description: 'Lavanta notaları ile hafif, çiçeksi sıcak latte.',
      preparation:
          'Malzemelerin Sırası:\n1. Espresso (30 ml)\n2. Lavanta şurubu (2 yemek kaşığı)\n3. Süt (150 ml)\n4. Bal (1 çay kaşığı isteğe bağlı)\n5. Kurutulmuş lavanta (süsleme)\n\nYapılış:\n1) Kahve fincanına espresso ve lavanta şurubunu ekle\n2) Sütü 60°C derecede ısıt\n3) Sütü kahveye yavaşça ekle\n4) İnce köpük oluşana kadar karıştır\n5) Kurutulmuş lavanta çiçekleriyle servis et',
      ingredients: ['espresso', 'süt', 'lavanta', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1620999516664-946979219468?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      gradient: const LinearGradient(
        colors: [Color(0xFF927FA0), Color(0xFFC9D6FF)],
      ),
    ),
    // Fit Kategorisi - Sağlıklı Shake'ler ve İçecekler
    DrinkModel(
      id: 'protein-banana-shake',
      title: 'Protein Banana Shake',
      category: 'Fit',
      description: 'Protein tozu ve muzla sağlıklı, besleyici bir shake.',
      preparation:
          'Malzemelerin Sırası:\n1. Muz (1 adet, 120 g)\n2. Protein tozu (1 ölçek, 30 g)\n3. Yoğurt (150 g)\n4. Soğuk süt (100 ml)\n5. Bal (1 yemek kaşığı)\n6. Buz (1 fincan)\n\nYapılış:\n1) Muzun kabuğunu soy ve blenderda koy\n2) Protein tozunu ve yoğurtu ekle\n3) Soğuk sütü dök\n4) Bal ekle\n5) Buzla birlikte pürüzsüz kıvama kadar karıştır\n6) Protein bardağına dök ve hemen servis et',
      ingredients: ['muz', 'protein tozu', 'yoğurt', 'bal', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1577805947697-89e18249d767?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFF3A55C), Color(0xFFFFA500)],
      ),
    ),
    DrinkModel(
      id: 'green-detox-smoothie',
      title: 'Green Detox Smoothie',
      category: 'Fit',
      description: 'Yeşil yapraklı, enerji dolu bir detoks smoothie.',
      preparation:
          'Malzemelerin Sırası:\n1. Taze ıspanak (100 g)\n2. Yeşil elma (1 adet)\n3. Taze zencefil (1 parça)\n4. Limon suyu (2 çay kaşığı)\n5. Soğuk su (150 ml)\n6. Buz (1/2 fincan)\n\nYapılış:\n1) Ispanakları blenderda koy\n2) Elma ve zencefili parçala\n3) Tüm malzemeleri blenderda pürüzsüz olana kadar karıştır\n4) Hemen servis et',
      ingredients: ['ıspanak', 'yeşil elma', 'zencefil', 'limon', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF0B7A75), Color(0xFF71C187)],
      ),
    ),
    DrinkModel(
      id: 'berry-protein-bowl',
      title: 'Berry Protein Bowl',
      category: 'Fit',
      description: 'Kırmızı meyveler ve chia tohumlarıyla super shake.',
      preparation:
          'Malzemelerin Sırası:\n1. Frambuaz (100 g)\n2. Böğürtlen (100 g)\n3. Protein tozu (1 ölçek)\n4. Chia tohumları (2 yemek kaşığı)\n5. Yoğurt (150 g)\n\nYapılış:\n1) Meyveleri, protein tozunu ve yoğurdu blenderda karıştır\n2) Bardağa dök\n3) Chia tohumlarını üstüne serpiştir\n4) Kaşıkla servis et',
      ingredients: ['frambuaz', 'böğürtlen', 'protein tozu', 'chia tohumu', 'yoğurt'],
      imageUrl: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFCA1551), Color(0xFFFF6B6B)],
      ),
    ),
    DrinkModel(
      id: 'coconut-almond-fit',
      title: 'Coconut Almond Fit',
      category: 'Fit',
      description: 'Hindistancevizi ve badem ile vegan sağlıklı içecek.',
      preparation:
          'Malzemelerin Sırası:\n1. Hindistancevizi sütü (200 ml)\n2. Badem unu (2 yemek kaşığı)\n3. Protein tozu (1 ölçek)\n4. Bal (1 yemek kaşığı)\n\nYapılış:\n1) Tüm malzemeleri blenderda pürüzsüz olana kadar karıştır\n2) Hindistancevizi kırıntısı ile süsleyerek servis et',
      ingredients: ['hindistancevizi sütü', 'badem unu', 'protein tozu', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1626078436897-62846d03f677?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF8DC), Color(0xFFDEB887)],
      ),
    ),
    // Matcha Kategorisi - Matcha İçli İçecekler
    DrinkModel(
      id: 'matcha-latte',
      title: 'Matcha Latte',
      category: 'Matcha',
      description: 'Klasik sıcak matcha latte, kremsi ve tatmin edici.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Süt (150 ml)\n\nYapılış:\n1) Matcha tozunu sıcak suyla pürüzsüz olana kadar karıştır\n2) Isıtılmış sütü ekle\n3) Köpürterek sıcak servis et',
      ingredients: ['matcha tozu', 'süt', 'şeker', 'su'],
      imageUrl: 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF116E3C), Color(0xFF8FBC8F)],
      ),
    ),
    DrinkModel(
      id: 'iced-matcha-latte',
      title: 'Iced Matcha Latte',
      category: 'Matcha',
      description: 'Soğuk, kremsi ve ferah matcha latte.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Buz\n4. Soğuk süt (150 ml)\n\nYapılış:\n1) Matcha tozunu suyla aç\n2) Buz dolu bardağa dök\n3) Soğuk sütü ekleyerek servis et',
      ingredients: ['matcha tozu', 'süt', 'buz', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1590373190805-4c04221a719c?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF3CA55C), Color(0xFF7FB069)],
      ),
    ),
    DrinkModel(
      id: 'matcha-white-chocolate',
      title: 'Matcha White Chocolate',
      category: 'Matcha',
      description: 'Beyaz çikolata ve matcha\'nın zarif kombinasyonu.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha tozu\n2. Eritilmiş beyaz çikolata\n3. Sıcak süt\n\nYapılış:\n1) Beyaz çikolatayı eritin\n2) Matcha ve sıcak sütle birleştirip karıştırın\n3) Sıcak servis edin.',
      ingredients: ['matcha tozu', 'beyaz çikolata', 'süt', 'vanilya'],
      imageUrl: 'https://images.unsplash.com/photo-1543255006-d6395b6f1171?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF3CA55C), Color(0xFFF5F5DC)],
      ),
    ),
    DrinkModel(
      id: 'matcha-mango-smoothie',
      title: 'Matcha Mango Smoothie',
      category: 'Matcha',
      description: 'Egzotik mango ve yeşil matcha\'nın tropikal birleşimi.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha\n2. Mango\n3. Hindistancevizi sütü\n\nYapılış:\n1) Tüm malzemeleri blenderda buzla birlikte pürüzsüz olana kadar çekin.',
      ingredients: ['matcha tozu', 'mango', 'yoğurt', 'hindistancevizi sütü', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF3CA55C), Color(0xFFF7971E)],
      ),
    ),
    DrinkModel(
      id: 'matcha-hibiscus-cooler',
      title: 'Matcha Hibiscus Cooler',
      category: 'Matcha',
      description: 'Matcha ve hibiskus çayının serinletici buluşması.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha\n2. Demlenmiş hibiskus çayı\n3. Buz\n\nYapılış:\n1) Bardağın altına buz ve hibiskus çayını koyun\n2) Üzerine hazırladığınız matcha karışımını yavaşça ekleyerek katmanlı bir görüntü oluşturun.',
      ingredients: ['matcha tozu', 'hibiskus', 'limon', 'şeker', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1588631165487-95f782c5f137?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF3CA55C), Color(0xFFB31217)],
      ),
    ),
    // Diğer Kategorilere Yeni İçecekler
    DrinkModel(
      id: 'pistachio-cold-brew',
      title: 'Pistachio Cold Brew',
      category: 'Kahve',
      description: 'Pistasya ve soğuk demlenmiş kahvenin muhteşem uyumu.',
      preparation:
          'Malzemelerin Sırası:\n1. Cold brew (150 ml)\n2. Pistasya şurubu (2 yemek kaşığı)\n3. Soğuk süt (100 ml)\n4. Buz (1 fincan)\n5. Pistasya parçaları (süsleme)\n\nYapılış:\n1) Buz dolu bardağa cold brew dök\n2) Pistasya şurubunu ekle\n3) Soğuk sütü yavaşça ekle\n4) Hafif karıştır\n5) Pistasya parçalarıyla servis et',
      ingredients: ['cold brew', 'pistasya şurubu', 'süt', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1621251025068-19e2c6e61f2f?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Keep this image
      gradient: const LinearGradient(
        colors: [Color(0xFF8FBC8F), Color(0xFF4B2C20)], // Pistachio/coffee gradient
      ),
    ),
    DrinkModel(
      id: 'tropical-frozen-mojito',
      title: 'Tropical Frozen Mojito',
      category: 'Frozen',
      description: 'Ananas, mango ve nane ile tropikal donmuş mojito.',
      preparation:
          'Malzemelerin Sırası:\n1. Ananas\n2. Mango\n3. Nane\n4. Lime\n\nYapılış:\n1) Tüm meyveleri ve naneyi buzla blenderda çekin\n2) Ferahlatıcı bir kadehte servis edin.',
      ingredients: ['ananas', 'mango', 'nane', 'lime', 'soda', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFA500), Color(0xFF90EE90)],
      ),
    ),
    DrinkModel(
      id: 'peach-ginger-tea',
      title: 'Peach Ginger Tea',
      category: 'Çay',
      description: 'Şeftali ve zencefil ile sıcak ve aromatik çay.',
      preparation:
          'Malzemelerin Sırası:\n1. Siyah çay\n2. Taze zencefil\n3. Şeftali\n\nYapılış:\n1) Çayı zencefil dilimleriyle demleyin\n2) Taze şeftali dilimleri ekleyerek servis edin.',
      ingredients: ['çay', 'şeftali', 'zencefil', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6F61), Color(0xFFFFB84D)],
      ),
    ),
    DrinkModel(
      id: 'elderflower-lemon-soda',
      title: 'Elderflower Lemon Soda',
      category: 'Soda',
      description: 'Ağaçkakısı ve limonla hafif, baharatlı soda.',
      preparation:
          'Malzemelerin Sırası:\n1. Ağaçkakısı nektarı (3 yemek kaşığı)\n2. Limon suyu (3 çay kaşığı)\n3. Maden suyu (200 ml)\n4. Taze nane yaprakları (8-10 yaprak)\n5. Buz (1 fincan)\n6. Limon dilimi (süsleme)\n\nYapılış:\n1) Buz dolu bardağa ağaçkakısı nektarını dök\n2) Limon suyunu ekle\n3) Nane yapraklarını hafif ez\n4) Naneyi ekle\n5) Maden suyu dök\n6) Hafif karıştır\n7) Limon dilimi ile servis et',
      ingredients: ['ağaçkakısı nektarı', 'limon', 'maden suyu', 'nane', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1095968?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      gradient: const LinearGradient(
        colors: [Color(0xFFE1BEE7), Color(0xFFFCE4EC)],
      ),
    ),
    DrinkModel(
      id: 'acai-blueberry-smoothie',
      title: 'Acai Blueberry Smoothie',
      category: 'Smoothie',
      description: 'Acai ve blueberry ile antioksidan dolu bir smoothie.',
      preparation:
          'Malzemelerin Sırası:\n1. Acai\n2. Yaban mersini\n3. Yoğurt\n\nYapılış:\n1) Tüm malzemeleri blenderda buzla pürüzsüz olana kadar çekin.',
      ingredients: ['acai', 'blueberry', 'yoğurt', 'hindistancevizi sütü', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF4B0082), Color(0xFF9370DB)],
      ),
    ),
    DrinkModel(
      id: 'vietnamese-iced-coffee',
      title: 'Vietnamese Iced Coffee',
      category: 'Kahve',
      description: 'Yoğun, tatlı ve kremsi Vietnamca soğuk kahve.',
      preparation:
          'Malzemelerin Sırası:\n1. Filtre kahve (30 ml)\n2. Kondense süt (3 yemek kaşığı)\n3. Buz (1 fincan)\n4. Sıcak su (filtre için, 150 ml)\n\nYapılış:\n1) Buz dolu bardağa kondense sütü dök\n2) Vietnamca kahve filtresini bardağın üstüne yerleştir\n3) Sıcak suyu yavaşça dök\n4) 3-4 dakika damlamasını bekle\n5) Kabaca karıştır\n6) Hemen soğuk servis et',
      ingredients: ['filtre kahve', 'kondense süt', 'buz', 'su'],
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      gradient: const LinearGradient(
        colors: [Color(0xFF3E2723), Color(0xFF8D6E63)],
      ),
    ),
    DrinkModel(
      id: 'affogato',
      title: 'Affogato',
      category: 'Kahve',
      description: 'Sıcak espresso ile vanilya dondurmaya dökülüyor.',
      preparation:
          'Malzemelerin Sırası:\n1. Vanilya dondurması (2 kaşık)\n2. Sıcak espresso\n\nYapılış:\n1) Kaseye dondurmayı koyun\n2) Üzerine taze demlenmiş sıcak espressoyu gezdirin.',
      ingredients: ['espresso', 'vanilya dondurmasi', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1594631252845-29fc4586c552?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFFF4A460)],
      ),
    ),
    DrinkModel(
      id: 'tiramisu-latte',
      title: 'Tiramisu Latte',
      category: 'Kahve',
      description: 'Tiramisu aroması ile zarif sıcak kahve.',
      preparation:
          'Malzemelerin Sırası:\n1. Espresso\n2. Tiramisu şurubu\n3. Süt\n\nYapılış:\n1) Espresso ve şurubu karıştırın\n2) Isıtılmış sütü ekleyip üzerine kakao serpin.',
      ingredients: ['espresso', 'süt', 'tiramisu şurubu', 'mascarpone'],
      imageUrl: 'https://images.unsplash.com/photo-1541167760496-162955ed8a9f?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFA0826D), Color(0xFFF5DEB3)],
      ),
    ),
    DrinkModel(
      id: 'strawberry-daiquiri',
      title: 'Strawberry Daiquiri',
      category: 'Kokteyl',
      description: 'Çilekli, serinletici ve zarif bir kokteyl.',
      preparation:
          'Malzemelerin Sırası:\n1. Çilek (250 g)\n2. Rom (45 ml)\n3. Limon suyu (30 ml)\n4. Şeker şurubu (20 ml)\n5. Buz (1 fincan)\n6. Çilek dilimi (süsleme)\n\nYapılış:\n1) Blenderda çilekleri koy\n2) Rom ekle\n3) Limon suyu ve şeker şurubunu ekle\n4) Buzla 30 saniye karıştır\n5) Pürüzsüz buzlu kıvamda martini bardağına dök\n6) Çilek dilimi ile servis et',
      ingredients: ['çilek', 'rom', 'limon', 'şeker', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1595981267035-7b04ca84a82d?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFFFF69B4)],
      ),
    ),
    DrinkModel(
      id: 'pina-colada',
      title: 'Pina Colada',
      category: 'Kokteyl',
      description: 'Ananas ve hindistancevizi kremiyla tropikal efsane.',
      preparation:
          'Malzemelerin Sırası:\n1. Ananas suyu (150 ml)\n2. Hindistancevizi kremi (90 ml)\n3. Rom (45 ml)\n4. Buz (1,5 fincan)\n5. Ananas dilimi (süsleme)\n6. Maça çiçeği (süsleme)\n\nYapılış:\n1) Blenderda ananas suyunu koy\n2) Hindistancevizi kremi ekle\n3) Rom ekle\n4) Buzla 40 saniye güçlü şekilde karıştır\n5) Piña Colada bardağına dök\n6) Ananas dilimi ve maça ile servis et',
      ingredients: ['ananas suyu', 'hindistancevizi krem', 'rom', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1587883012610-e3df17d41270?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFA500), Color(0xFFFFFACD)],
      ),
    ),
    DrinkModel(
      id: 'mango-sorbet',
      title: 'Mango Sorbet',
      category: 'Frozen',
      description: 'Donmuş mango sorbeti, hafif ve ferah.',
      preparation:
          'Malzemelerin Sırası:\n1. Mango dondurmesi (250 g)\n2. Portakal suyu (100 ml)\n3. Zencefil (1 çay kaşığı, rendelenmiş)\n4. Limon suyu (1 yemek kaşığı)\n5. Mango dilimi (süsleme)\n\nYapılış:\n1) Blenderda mango dondurmesi koy\n2) Portakal suyu ekle\n3) Zencefil ve limon suyu ekle\n4) Yumuşak kıvama kadar karıştır\n5) Bardağa dök\n6) Taze mango dilimiyle servis et',
      ingredients: ['mango dondurmesi', 'portakal suyu', 'zencefil'],
      imageUrl: 'https://images.unsplash.com/photo-1553621042-f6e7609bbcd7?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFA500), Color(0xFFFFD700)],
      ),
    ),
    DrinkModel(
      id: 'chocolate-peanut-shake',
      title: 'Chocolate Peanut Shake',
      category: 'Frozen',
      description: 'Çikolata ve yer fıstığının lezzetli donmuş shake.',
      preparation:
          'Malzemelerin Sırası:\n1. Çikolata dondurması\n2. Yer fıstığı ezmesi\n3. Süt\n\nYapılış:\n1) Tüm malzemeleri blenderda buzla çekip soğuk servis edin.',
      ingredients: ['çikolata dondurmesi', 'yer fıstığı unu', 'süt', 'buz'],
      imageUrl: 'https://images.unsplash.com/photo-1590089415225-401ed6f9db8e?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
      ),
    ),
    DrinkModel(
      id: 'cherry-blossom-tea',
      title: 'Cherry Blossom Tea',
      category: 'Çay',
      description: 'Kiraz çiçeği aromalı, çiçeksi ve hafif bir çay.',
      preparation:
          'Malzemelerin Sırası:\n1. Beyaz çay (1 poşet veya 1 çay kaşığı)\n2. Sıcak su (250 ml)\n3. Kurutulmuş kiraz çiçeği (1 yemek kaşığı)\n4. Bal (1 yemek kaşığı)\n5. Taze nane yaprakları (opsiyonel, süsleme)\n\nYapılış:\n1) Sıcak suya beyaz çay poşetini dök\n2) Kurutulmuş kiraz çiçeklerini ekle\n3) 4-5 dakika demlemeye bırak\n4) Çayı süz\n5) Bal ekle ve karıştır\n6) Nane yapraklarıyla garne edip servis et',
      ingredients: ['beyaz çay', 'kiraz çiçeği', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1588725838023-3b1b1b1b1b1b?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFB6C1), Color(0xFFFFC0CB)],
      ),
    ),
    DrinkModel(
      id: 'lemongrass-mint-soda',
      title: 'Lemongrass Mint Soda',
      category: 'Soda',
      description: 'Limonota ve nane ile serinletici bir soda.',
      preparation:
          'Malzemelerin Sırası:\n1. Limonotu\n2. Nane\n3. Maden suyu\n\nYapılış:\n1) Limonotu ve naneyi bardakta ezin\n2) Buz ve maden suyu ekleyerek servis edin.',
      ingredients: ['limonotu', 'nane', 'limon', 'şeker', 'maden suyu'],
      imageUrl: 'https://images.unsplash.com/photo-1554866585-e45889d5b0cf?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF228B22), Color(0xFF90EE90)],
      ),
    ),
    DrinkModel(
      id: 'pomegranate-smoothie',
      title: 'Pomegranate Smoothie',
      category: 'Smoothie',
      description: 'Nar ve antioxidan meyveler ile güçlü smoothie.',
      preparation:
          'Malzemelerin Sırası:\n1. Nar\n2. Böğürtlen\n3. Yoğurt\n\nYapılış:\n1) Tüm malzemeleri blenderda pürüzsüz olana kadar çekin\n2) Nar taneleriyle süsleyin.',
      ingredients: ['nar', 'böğürtlen', 'yoğurt', 'hindistancevizi sütü'],
      imageUrl: 'https://images.unsplash.com/photo-1623065640702-30399ef78484?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFFB31217), Color(0xFFFF6B6B)],
      ),
    ),
    DrinkModel(
      id: 'energy-supercharge',
      title: 'Energy Supercharge',
      category: 'Fit',
      description: 'Enerji ve güç için super kahvaltı shake.',
      preparation:
          'Malzemelerin Sırası:\n1. Muz\n2. Hurma\n3. Badem sütü\n\nYapılış:\n1) Enerji veren tüm malzemeleri blenderda çekip taze servis edin.',
      ingredients: ['muz', 'tarih', 'badem unu', 'protein tozu', 'almond sütü'],
      imageUrl: 'https://images.unsplash.com/photo-1610970881699-44a5587cabcc?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFFFFD700)],
      ),
    ),
    DrinkModel(
      id: 'matcha-mochi-latte',
      title: 'Matcha Mochi Latte',
      category: 'Matcha',
      description: 'Matcha ve mochi ile Japonca keyifli bir latte.',
      preparation:
          'Malzemelerin Sırası:\n1. Matcha\n2. Süt\n3. Mochi topları\n\nYapılış:\n1) Matcha lattenizi hazırlayın\n2) İçine küçük mochi parçaları ekleyerek servis edin.',
      ingredients: ['matcha tozu', 'mochi', 'süt', 'şeker'],
      imageUrl: 'https://images.unsplash.com/photo-1615399955958-43a9f59e01d4?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF228B22), Color(0xFFF5DEB3)],
      ),
    ),
    DrinkModel(
      id: 'blueberry-yogurt-parfait',
      title: 'Blueberry Yogurt Parfait',
      category: 'Smoothie',
      description: 'Blueberry ve yoğurt ile katmanlı bir parfait.',
      preparation:
          'Malzemelerin Sırası:\n1. Yaban mersini\n2. Yoğurt\n3. Granola\n\nYapılış:\n1) Katmanlar halinde yoğurt, meyve ve granolayı dizerek servis edin.',
      ingredients: ['blueberry', 'yoğurt', 'granola', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF4B0082), Color(0xFF6A5ACD)],
      ),
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
      imageUrl: 'https://images.unsplash.com/photo-1559181286-d3fee14d55b7?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1556742212-5b321f3c261d?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1514432324607-2df86e7f718d?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      ingredients: ['rom', 'vodka', 'gin', 'tequila', 'triple sec', 'lime', 'kola'],
      imageUrl: 'https://images.unsplash.com/photo-1536042904634-2a19c5e36df9?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1598318906914-b3efc1dfe9eb?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1605352573261-f2d2f23ae65d?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1599599810694-b5ac4dd64b73?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1569003222316-4da3f63a506d?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1541810298000-33eaf8f70f70?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1585897913619-99739e88e19f?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1544568100-847a948585b0?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1556231669979-95d6773ae296?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1541182286-92d11f0efbf7?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1559056199-641a0ac8b3f7?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      imageUrl: 'https://images.unsplash.com/photo-1611076857029-d8fb0018d693?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
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
      ingredients: ['avokado', 'kakao tozu', 'protein tozu', 'almond sütü', 'bal'],
      imageUrl: 'https://images.unsplash.com/photo-1591957840635-bfd9d25b90c7?q=80&w=1974&auto=format&fit=crop',
      gradient: const LinearGradient(
        colors: [Color(0xFF8B4513), Color(0xFF6B4C2F)],
      ),
    ),
  ];
}
