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
          '1) Espresso ve vodka ile shakera buz ekle.\n2) Suyla köpük elde edene kadar güçlü sallama.\n3) Soğuk kokteyl bardağına süz ve kahve çekirdeği ile servis et.',
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
          '1) Buz, süt ve kakao tozunu blendera ekle.\n2) Pürüzsüz bir doku elde edene kadar karıştır.\n3) Bardağa dök ve çikolata parçalarıyla tamamla.',
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
          '1) Espresso, süt ve fındık şurubunu karıştır.\n2) Buz dolu bardağa dök.\n3) Üzerine krem şanti ve kakao serpiştir.',
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
          '1) Matcha ve hindistancevizi sütünü çalkala.\n2) Buz ve lime dilimleri ekle.\n3) Nane yapraklarıyla süsle.',
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
          '1) Buzlu bardağa cold brew ve karamelli süt ekle.\n2) Üzerine karamelli sos gezdir.\n3) Hafif karıştırıp servis et.',
      ingredients: ['cold brew', 'süt', 'karamel sos', 'buz'],
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
          '1) Hibiskus demlenmiş çayı soğut.\n2) Limon, şeker ve maden suyuyla karıştır.\n3) Taze nane ve buzla servis et.',
      ingredients: ['hibiskus', 'limo', 'şeker', 'maden suyu'],
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
          '1) Cold brew ve portakal suyunu karıştır.\n2) Buz ekle.\n3) Üzerine portakal dilimi koy.',
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
          '1) Çilek, yoğurt ve fesleğeni blenderda çek.\n2) Kıvamını ayarla.\n3) Soğuk servis et.',
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
          '1) Espresso, süt ve vanilya şurubunu karıştır.\n2) Buz ekle.\n3) Çırpılmış krema ile tamamla.',
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
          '1) Çayı demle, tarçın ve portakal kabuğu ekle.\n2) Bal ile tatlandır.\n3) Sıcak servis et.',
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
          '1) Kombuchayı frambuaz ve böğürtlenle karıştır.\n2) Buz ekle.\n3) Nane ile süsle.',
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
          '1) Mango, yoğurt ve sütü blenderda çek.\n2) Biraz kartopu tarçın ekle.\n3) Soğuk servis et.',
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
          '1) Espresso ve sütü ısıt.\n2) Lavanta şurubu ekle.\n3) İnce köpük ile servis et.',
      ingredients: ['espresso', 'süt', 'lavanta', 'bal'],
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=900&q=80',
      gradient: const LinearGradient(
        colors: [Color(0xFF927FA0), Color(0xFFC9D6FF)],
      ),
    ),
  ];
}
