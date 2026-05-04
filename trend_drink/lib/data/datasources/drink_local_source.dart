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
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF3A1C71), Color(0xFFD76D77)],
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
      imageUrl:
          'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF141E30), Color(0xFF243B55)],
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
      imageUrl:
          'https://images.unsplash.com/photo-1510627498534-cf7e9002facc?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF42275A), Color(0x734F1C3D)],
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
      imageUrl:
          'https://images.unsplash.com/photo-1506086679521-8c0cb5a8dd2b?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1485795049026-6b6f1cca5f64?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Çilek (250 g)\n2. Yoğurt (150 g)\n3. Fesleğen yaprakları (10-12 adet)\n4. Bal (1 yemek kaşığı)\n5. Buz (1 fincan)\n\nYapılış:\n1) Blenderda çilekleri koy\n2) Yoğurt ekle ve karıştır\n3) Fesleğen yapraklarını ekle\n4) Bal ve buz ekle\n5) Pürüzsüz kıvama kadar karıştır\n6) Hemen soğuk servis et'
      ingredients: ['çilek', 'yoğurt', 'fesleğen', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Espresso (30 ml)\n2. Vanilya şurubu (2 yemek kaşığı)\n3. Soğuk süt (150 ml)\n4. Buz (1 fincan)\n5. Çırpılmış krem (süsleme)\n\nYapılış:\n1) Şekerli bir bardağa espresso ve vanilya şurubunu ekle\n2) Buz dolu bardağa dök\n3) Soğuk sütü yavaşça ekle ve karıştır\n4) Üzerine çırpılmış krem ekle\n5) Kakao tozu veya vanilya serpiştirerek servis et'
      ingredients: ['espresso', 'süt', 'vanilya', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1517685352821-92cf88aee5a5?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF42275A), Color(0xFF734B6D)],
      ),
    ),
    DrinkModel(
      id: 'orange-spiced-tea',
      title: 'Orange Spiced Tea',
      category: 'Çay',
      description: 'Tarçın ve portakal ile sıcak, aromatik bir çay deneyimi.',
      preparation:
          'Malzemelerin Sırası:\n1. Siyah çay (1 poşet veya 1 çay kaşığı)\n2. Sıcak su (250 ml)\n3. Tarçın çubuğu (1 adet)\n4. Portakal kabuğu (kurutulmuş, 1 çay kaşığı)\n5. Bal (1-2 yemek kaşığı)\n6. Portakal dilimi (süsleme)\n\nYapılış:\n1) Sıcak suya çay poşetini koy\n2) Tarçın çubuğu ve portakal kabuğunu ekle\n3) 5 dakika demlemeye bırak\n4) Çayı süz\n5) Bala ekle ve karıştır\n6) Portakal dilimiyle servis et'
      ingredients: ['çay', 'tarçın', 'portakal', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF7B2FF7), Color(0xFF5E5CE6)],
      ),
    ),
    DrinkModel(
      id: 'berry-kombucha',
      title: 'Berry Kombucha',
      category: 'Soda',
      description: 'Şerbetçiotu ferahlığıyla kırmızı meyveli kombucha.',
      preparation:
          'Malzemelerin Sırası:\n1. Kombucha (250 ml)\n2. Frambuaz (100 g)\n3. Böğürtlen (100 g)\n4. Buz (1 fincan)\n5. Nane yaprakları (5-6 yaprak)\n\nYapılış:\n1) Buz dolu bardağa kombucha dök\n2) Frambuaz ve böğürtlenleri ekle\n3) Hafif karıştır\n4) Nane yapraklarını sapından çıkar ve ekle\n5) Taze servis et'
      ingredients: ['kombucha', 'frambuaz', 'böğürtlen', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Mango (1 adet, 300 g)\n2. Yoğurt (200 g)\n3. Soğuk süt (100 ml)\n4. Tarçın (1 çay kaşığı)\n5. Bal (1 yemek kaşığı)\n6. Buz (1/2 fincan)\n\nYapılış:\n1) Mangonun etini blenderda koy\n2) Yoğurt ekle\n3) Soğuk sütü ekle\n4) Tarçın ve bal ekle\n5) Buzla birlikte pürüzsüz kıvama kadar karıştır\n6) Buzlu bardağa dök ve hemen servis et'
      ingredients: ['mango', 'yoğurt', 'süt', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1572449043410-13659d414b1d?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Espresso (30 ml)\n2. Lavanta şurubu (2 yemek kaşığı)\n3. Süt (150 ml)\n4. Bal (1 çay kaşığı isteğe bağlı)\n5. Kurutulmuş lavanta (süsleme)\n\nYapılış:\n1) Kahve fincanına espresso ve lavanta şurubunu ekle\n2) Sütü 60°C derecede ısıt\n3) Sütü kahveye yavaşça ekle\n4) İnce köpük oluşana kadar karıştır\n5) Kurutulmuş lavanta çiçekleriyle servis et'
      ingredients: ['espresso', 'süt', 'lavanta', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Muz (1 adet, 120 g)\n2. Protein tozu (1 ölçek, 30 g)\n3. Yoğurt (150 g)\n4. Soğuk süt (100 ml)\n5. Bal (1 yemek kaşığı)\n6. Buz (1 fincan)\n\nYapılış:\n1) Muzun kabuğunu soy ve blenderda koy\n2) Protein tozunu ve yoğurtu ekle\n3) Soğuk sütü dök\n4) Bal ekle\n5) Buzla birlikte pürüzsüz kıvama kadar karıştır\n6) Protein bardağına dök ve hemen servis et'
      ingredients: ['muz', 'protein tozu', 'yoğurt', 'bal', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1590618946828-25b8f5df9dae?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Taze spinat (100 g)\n2. Yeşil elma (1 adet, 150 g)\n3. Taze ginger (1 inç parça)\n4. Limon suyu (2 çay kaşığı)\n5. Soğuk su (150 ml)\n6. Buz (1/2 fincan)\n7. Bal (1 çay kaşığı isteğe bağlı)\n\nYapılış:\n1) Spinatı blenderda koy\n2) Elmanın çekirdeklerini çıkar ve parçala\n3) Ginger'i soy ve rendeleme\n4) Blenderde elma ve ginger'ı ekle\n5) Limon suyu, su ve buz ekle\n6) 30 saniye pürüzsüz olana kadar karıştır\n7) Hemen buzlu bardağa dök ve servis et'
      ingredients: ['spinat', 'açı elma', 'ginger', 'limon', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1610970881917-475aa4ec6b94?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Frambuaz (100 g)\n2. Böğürtlen (100 g)\n3. Protein tozu (1 ölçek, 30 g)\n4. Chia tohumları (2 yemek kaşığı)\n5. Yoğurt (150 g)\n6. Soğuk süt (50 ml)\n\nYapılış:\n1) Frambuaz ve böğürlen blenderda koy\n2) Protein tozu ekle\n3) Yoğurt ve süt dök\n4) Kalın kıvamda olana kadar karıştır\n5) Bardağa dök\n6) Chia tohumlarını üstüne serpişt ir\n7) Kaşıkla servis et'
      ingredients: ['frambuaz', 'böğürtlen', 'protein tozu', 'chia tohumu', 'yoğurt'],
      imageUrl:
          'https://images.unsplash.com/photo-1590779033100-9f60a05a2000?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Hindistancevizi sütü (200 ml)\n2. Badem unu (2 yemek kaşığı)\n3. Protein tozu (1 ölçek, 30 g)\n4. Bal (1 yemek kaşığı)\n5. Buz (1/2 fincan)\n6. Hindistancevizi kırıntısı (süsleme)\n\nYapılış:\n1) Blenderda hindistancevizi sütünü koy\n2) Badem unu ekle ve karıştır\n3) Protein tozu ve bal ekle\n4) Buzla 30 saniye karıştır\n5) Bardağa dök\n6) Hindistancevizi kırıntısıyla servis et'
      ingredients: ['hindistancevizi sütü', 'badem unu', 'protein tozu', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1608848541803-ba4f8c70ae0b?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Süt (150 ml)\n4. Şeker veya Bal (1 çay kaşığı isteğe bağlı)\n\nYapılış:\n1) Matcha tozunu çay kaşığı sıcak suyla çalkala\n2) Pürüzsüz kıvam elde edene kadar karıştır\n3) Sütü 60°C derecede ısıt\n4) Sütü yavaşça matcha karışımına ekle\n5) İnce köpük oluşana kadar karıştır\n6) Sıcak servis et'
      ingredients: ['matcha tozu', 'süt', 'şeker', 'su'],
      imageUrl:
          'https://images.unsplash.com/photo-1533521257763-c860a94d4ce0?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Buz (1 fincan)\n4. Soğuk süt (150 ml)\n5. Bal (1 yemek kaşığı isteğe bağlı)\n\nYapılış:\n1) Matcha tozunu sıcak suyla çalkala\n2) Pürüzsüz kıvama kadar karıştır\n3) Buz dolu bardağa dök\n4) Soğuk sütü ekle\n5) Hafif karıştır\n6) Balla tatlandırıp servis et'
      ingredients: ['matcha tozu', 'süt', 'buz', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1599858827595-e58a5bfe0e37?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Beyaz çikolata (50 g)\n3. Sıcak su (50 ml)\n4. Süt (150 ml)\n5. Vanilya ekstresi (birkaç damla)\n\nYapılış:\n1) Beyaz çikolatayı bain-marie'de eritin\n2) Matcha tozunu sıcak suyla çalkala\n3) Eri miş çikolatayı matcha karışımına ekle\n4) Sütü ısıt ve ekle\n5) Vanilya ekstresi ekle\n6) Hafif köpük oluşana kadar karıştır ve servis et'
      ingredients: ['matcha tozu', 'beyaz çikolata', 'süt', 'vanilya'],
      imageUrl:
          'https://images.unsplash.com/photo-1577318810033-73fadebe3fb0?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Mango (1 adet, 300 g)\n3. Yoğurt (150 g)\n4. Hindistancevizi sütü (100 ml)\n5. Bal (1 yemek kaşığı)\n6. Buz (1/2 fincan)\n\nYapılış:\n1) Blenderda matcha tozunu koy\n2) Mango etini ekle\n3) Yoğurt ve hindistancevizi sütünü dök\n4) Bal ekle\n5) Buzla 30 saniye pürüzsüz olana kadar karıştır\n6) Buzlu bardağa dök ve servis et'
      ingredients: ['matcha tozu', 'mango', 'yoğurt', 'hindistancevizi sütü', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd33e2f?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Hibiskus demlenmiş çayı (150 ml, soğutulmuş)\n4. Limon suyu (2 çay kaşığı)\n5. Şeker (1 yemek kaşığı)\n6. Buz (1 fincan)\n7. Nane yaprakları (süsleme)\n\nYapılış:\n1) Hibiskus çayını demle ve soğut\n2) Matcha tozunu sıcak suyla çalkala\n3) Buz dolu bardağa dök\n4) Soğutulmuş hibiskus çayını ekle\n5) Limon suyu ve şeker ekle\n6) Hafif karıştır\n7) Nane yaprakları ile servis et'
      ingredients: ['matcha tozu', 'hibiskus', 'limon', 'şeker', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1567521464027-f127ff144326?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Cold brew (150 ml)\n2. Pistasya şurubu (2 yemek kaşığı)\n3. Soğuk süt (100 ml)\n4. Buz (1 fincan)\n5. Pistasya parçaları (süsleme)\n\nYapılış:\n1) Buz dolu bardağa cold brew dök\n2) Pistasya şurubunu ekle\n3) Soğuk sütü yavaşça ekle\n4) Hafif karıştır\n5) Pistasya parçalarıyla servis et'
      ingredients: ['cold brew', 'pistasya şurubu', 'süt', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd33e2f?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFFC64043), Color(0xFF7A3E37)],
      ),
    ),
    DrinkModel(
      id: 'tropical-frozen-mojito',
      title: 'Tropical Frozen Mojito',
      category: 'Frozen',
      description: 'Ananas, mango ve nane ile tropikal donmuş mojito.',
      preparation:
          'Malzemelerin Sırası:\n1. Ananas (200 g, parçalanmış)\n2. Mango (150 g, parçalanmış)\n3. Taze nane yaprakları (15-20 yaprak)\n4. Lime suyu (2 çay kaşığı)\n5. Şeker şurubu (2 yemek kaşığı)\n6. Maden suyu (100 ml)\n7. Buz (1,5 fincan)\n\nYapılış:\n1) Blenderda ananas ve mango parçalarını koy\n2) Nane yapraklarını ezercesine ekle\n3) Lime suyu ve şeker şurubunu ekle\n4) Buzla 45 saniye karıştır\n5) Buzlu bir bokal bardağa dök\n6) Maden suyu ekle\n7) Nane ve ananas dilimiyle servis et'
      ingredients: ['ananas', 'mango', 'nane', 'lime', 'soda', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1585518419759-3db8b14b39ec?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Siyah çay (1 poşet veya 1 çay kaşığı)\n2. Sıcak su (250 ml)\n3. Taze zencefil (1 inç parça)\n4. Şeftali parçaları (150 g)\n5. Bal (1 yemek kaşığı)\n6. Limon dilimi (süsleme)\n\nYapılış:\n1) Sıcak suya çay poşetini dök\n2) Zencefiili soy ve rendeleme\n3) Zencefil ve Şeftali parçalarını ekle\n4) 5 dakika demlemeye bırak\n5) Çayı süz\n6) Bal ekle ve karıştır\n7) Limon dilimi ile servis et'
      ingredients: ['çay', 'şeftali', 'zencefil', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1597318301267-ee11a55eed5e?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Ağaçkakısı nektarı (3 yemek kaşığı)\n2. Limon suyu (3 çay kaşığı)\n3. Maden suyu (200 ml)\n4. Taze nane yaprakları (8-10 yaprak)\n5. Buz (1 fincan)\n6. Limon dilimi (süsleme)\n\nYapılış:\n1) Buz dolu bardağa ağaçkakısı nektarını dök\n2) Limon suyunu ekle\n3) Nane yapraklarını hafif ez\n4) Naneyi ekle\n5) Maden suyunu dök\n6) Hafif karıştır\n7) Limon dilimi ile servis et'
      ingredients: ['ağaçkakısı nektarı', 'limon', 'maden suyu', 'nane', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1599599810694-b5ac4dd33e2f?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Acai hamuru (100 g)\n2. Blueberry (120 g)\n3. Yoğurt (150 g)\n4. Hindistancevizi sütü (100 ml)\n5. Bal (1 yemek kaşığı)\n6. Buz (1/2 fincan)\n\nYapılış:\n1) Blenderda acai hamurunu koy\n2) Blueberry ekle\n3) Yoğurt dök\n4) Hindistancevizi sütünü ekle\n5) Bal ekle\n6) Buzla 30 saniye pürüzsüz olana kadar karıştır\n7) Hemen buzlu bardağa dök ve servis et'
      ingredients: ['acai', 'blueberry', 'yoğurt', 'hindistancevizi sütü', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1590624466453-bcf5f10a93ba?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Filtre kahve (30 ml)\n2. Kondense süt (3 yemek kaşığı)\n3. Buz (1 fincan)\n4. Sıcak su (filtre için, 150 ml)\n\nYapılış:\n1) Buz dolu bardağa kondense sütü dök\n2) Vietnamca kahve filtresini bardağın üstüne yerleştir\n3) Sıcak suyu yavaşça dök\n4) 3-4 dakika damlamasını bekle\n5) Kabaca karıştır\n6) Hemen soğuk servis et'
      ingredients: ['filtre kahve', 'kondense süt', 'buz', 'su'],
      imageUrl:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Vanilya dondurmasi (2 kçıkık)\n2. Espresso (30-40 ml)\n3. Çikolata çiçekleri veya kakao (süsleme)\n\nYapılış:\n1) Derin bir fincan veya bardağa vanilya dondurmasi koy\n2) Espressosunu hazırla\n3) Sıcak espressoyu dondurmaya yavaşça dök\n4) Hemen karıştır ve alımını deneyimle\n5) Çikolata çiçekleriyle servis et'
      ingredients: ['espresso', 'vanilya dondurmasi', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1541440573542-3bac8dc8f3bc?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Espresso (30 ml)\n2. Tiramisu şurubu (2 yemek kaşığı)\n3. Süt (150 ml)\n4. Mascarpone peyniri (2 yemek kaşığı)\n5. Kakao tozu (süsleme)\n6. Kakaolu bisküvi kırıntısı (süsleme)\n\nYapılış:\n1) Kahve fincanına espresso dök\n2) Tiramisu şurubunu ekle\n3) Sütü 60°C derecede ısıt\n4) Sütü yavaşça kahveye ekle\n5) Mascarpone'nin bir kçıkığını üstüne koy\n6) Kakao tozu ve bisküvi kırıntısı serpiştirerek servis et'
      ingredients: ['espresso', 'süt', 'tiramisu şurubu', 'mascarpone'],
      imageUrl:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1610566134055-688f5dba53d9?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1556481687175-f5e9a0fe7e64?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Çikolata dondurmesi (250 g)\n2. Yer fıstığı unu (2 yemek kaşığı)\n3. Soğuk süt (100 ml)\n4. Bal (1 yemek kaşığı)\n5. Buz (1/2 fincan)\n6. Çikolata parçaları (süsleme)\n\nYapılış:\n1) Blenderda çikolata dondurmesini koy\n2) Yer fıstığı unu ekle\n3) Soğuk sütü dök\n4) Bal ekle\n5) Buzla 30 saniye pürüzsüz olana kadar karıştır\n6) Bardağa dök\n7) Çikolata parçalarıyla servis et',
      ingredients: ['çikolata dondurmesi', 'yer fıstığı unu', 'süt', 'buz'],
      imageUrl:
          'https://images.unsplash.com/photo-1546260453-fa375faded35?auto=format&fit=crop&w=900&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1597318301267-ee11a55eed5e?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Taze limonotu (30 g, domalı)\n2. Taze nane yaprakları (15-20 yaprak)\n3. Limon suyu (3 çay kaşığı)\n4. Şeker şurubu (2 yemek kaşığı)\n5. Maden suyu (250 ml)\n6. Buz (1 fincan)\n\nYapılış:\n1) Bardağa limonotu ve nane yapraklarını koy\n2) Hafif ezdikten sonra limon suyu ekle\n3) Şeker şurubunu ekle ve karıştır\n4) Buz dök\n5) Maden suyu ekle\n6) Limonotu dalı ile servis et',
      ingredients: ['limonotu', 'nane', 'limon', 'şeker', 'maden suyu'],
      imageUrl:
          'https://images.unsplash.com/photo-1554866585-e45889d5b0cf?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Nar (1 adet)\n2. Böğürtlen (100 g)\n3. Yoğurt (150 g)\n4. Hindistancevizi sütü (100 ml)\n5. Bal (1 yemek kaşığı)\n6. Buz (1/2 fincan)\n7. Nar tohumu (süsleme)\n\nYapılış:\n1) Narı yarısına böl ve tohumlarını çıkar\n2) Blenderda nar tohumlarını koy\n3) Böğürtlen ekle\n4) Yoğurt dök\n5) Hindistancevizi sütünü ekle\n6) Bal ekle\n7) Buzla 30 saniye pürüzsüz olana kadar karıştır\n8) Hemen buzlu bardağa dök ve nar tohumu ile servis et',
      ingredients: ['nar', 'böğürtlen', 'yoğurt', 'hindistancevizi sütü'],
      imageUrl:
          'https://images.unsplash.com/photo-1590080876543-1fd9347228b6?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Muz (1 adet, 120 g)\n2. Tarih (3-4 adet)\n3. Badem unu (2 yemek kaşığı)\n4. Protein tozu (1 ölçek, 30 g)\n5. Almond sütü (150 ml)\n6. Bal (1 yemek kaşığı)\n7. Buz (1/2 fincan)\n\nYapılış:\n1) Muzun kabuğunu soy ve blenderda koy\n2) Tarih ekle\n3) Badem unu ve protein tozu ekle\n4) Almond sütünü dök\n5) Bal ekle\n6) Buzla 30 saniye pürüzsüz kıvama kadar karıştır\n7) Enerji bardağına dök ve hemen servis et',
      ingredients: ['muz', 'tarih', 'badem unu', 'protein tozu', 'almond sütü'],
      imageUrl:
          'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Matcha tozu (1 çay kaşığı)\n2. Sıcak su (50 ml)\n3. Mochi (2-3 parça, küçük boyuta kesilmiş)\n4. Süt (150 ml)\n5. Şeker (1 çay kaşığı istege bağlı)\n\nYapılış:\n1) Matcha tozunu sıcak suyla çalkala\n2) Pürüzsüz kıvama kadar karıştır\n3) Mochi parçalarını bardağın dibine koy\n4) Sütü 60°C derecede ısıt\n5) Sütü matcha karışımına ekle\n6) İnce köpük oluşana kadar karıştır\n7) Sıcak servis et',
      ingredients: ['matcha tozu', 'mochi', 'süt', 'şeker'],
      imageUrl:
          'https://images.unsplash.com/photo-1615399955958-43a9f59e01d4?auto=format&fit=crop&w=900&q=80',
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
          'Malzemelerin Sırası:\n1. Blueberry (150 g)\n2. Yoğurt (200 g)\n3. Granola (50 g)\n4. Bal (2 yemek kaşığı)\n5. Hindistancevizi kırıntısı (süsleme)\n\nYapılış:\n1) Blenderda blueberry ve balı karıştır\n2) Pürüzsüz puriye dök\n3) Tall glass\'a yoğurt katmanını koy\n4) Blueberry mixture katmanını ekle\n5) Granola katı ekle\n6) Tekrar yoğurt ekle\n7) Üstüne hindistancevizi kırıntısı serpişit\n8) Kaşıkla servis et',
      ingredients: ['blueberry', 'yoğurt', 'granola', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1590592087614-1d79162e2e0d?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF4B0082), Color(0xFF6A5ACD)],
      ),
    ),
  ];
}
