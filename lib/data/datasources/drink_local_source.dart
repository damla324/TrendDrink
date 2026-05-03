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
      imageTag: 'espresso_martini',
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
      imageTag: 'cocoa_frozen_latte',
      gradient: const LinearGradient(
        colors: [Color(0xFF20002C), Color(0xC58E256A)],
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
      imageTag: 'iced_hazelnut_mocha',
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
      imageTag: 'matcha_coconut_cooler',
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
      imageTag: 'caramel_cold_brew',
      gradient: const LinearGradient(
        colors: [Color(0xFF42275A), Color(0x734F1C3D)],
      ),
    ),
  ];
}
