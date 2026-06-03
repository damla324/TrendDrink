/// Centralised bilingual string table.
/// Usage: final s = ref.watch(appStringsProvider);  s.historyTitle
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/presentation/notifiers/theme_notifier_v2.dart';

// ─── Language Notifier ────────────────────────────────────────────────────────
final languageProvider = NotifierProvider<LanguageNotifier, String>(
  LanguageNotifier.new,
);

class LanguageNotifier extends Notifier<String> {
  static const String _key = 'app_language';

  @override
  String build() {
    final prefsAsync = ref.watch(sharedPrefsProvider);
    return prefsAsync.whenData((prefs) {
          return prefs.getString(_key) ?? 'tr';
        }).value ??
        'tr';
  }

  Future<void> setLanguage(String code) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    state = code;
    await prefs.setString(_key, code);
  }

  bool get isTurkish => state == 'tr';
}

// ─── Strings Provider ─────────────────────────────────────────────────────────
final appStringsProvider = Provider<AppStrings>((ref) {
  final lang = ref.watch(languageProvider);
  return AppStrings._(lang);
});

// ─── AppStrings ───────────────────────────────────────────────────────────────
class AppStrings {
  const AppStrings._(this.locale);
  final String locale;

  bool get _tr => locale == 'tr';
  bool get isTr => locale == 'tr';

  // ── Navigation ───────────────────────────────────────────────────────────
  String get navHome => _tr ? 'Ana Sayfa' : 'Home';
  String get navDrinks => _tr ? 'İçecekler' : 'Drinks';
  String get navAI => _tr ? 'İçecek AI' : 'Drink AI';
  String get navFortuneAI => _tr ? 'Fal AI' : 'Fortune AI';
  String get navSettings => _tr ? 'Ayarlar' : 'Settings';
  String get navAbout => _tr ? 'Hakkında' : 'About';

  // ── Home ─────────────────────────────────────────────────────────────────
  String get homeTitle => 'TrendDrink';
  String get homeSubtitle => _tr
      ? 'Lezzet, sanat ve teknolojinin buluştuğu içecek atölyeniz.'
      : 'Where taste, art and technology meet.';
  String get featuredDrinks => _tr ? 'ÖNE ÇIKAN İÇECEKLER' : 'FEATURED DRINKS';
  String get categories => _tr ? 'KATEGORİLER' : 'CATEGORIES';
  String get explore => _tr ? 'KEŞFET' : 'EXPLORE';

  // ── Drink Detail ─────────────────────────────────────────────────────────
  String get historyTitle => _tr ? 'Tarih & Kültür' : 'History & Culture';
  String get prosConsTitle => _tr ? 'Artıları & Eksileri' : 'Pros & Cons';
  String get benefitsLabel => _tr ? 'Faydaları' : 'Benefits';
  String get cautionsLabel => _tr ? 'Dikkat Edilmesi Gerekenler' : 'Cautions';
  String get preparationTitle => _tr ? 'Hazırlanışı' : 'Preparation';
  String get tipLabel => _tr ? 'İpucu' : 'Pro Tip';
  String get suggestionsTitle => _tr ? 'Benzer İçecekler' : 'Similar Drinks';
  String get askAI => _tr ? 'AI ile Sor' : 'Ask AI';
  String get hot => _tr ? 'Sıcak' : 'Hot';
  String get cold => _tr ? 'Soğuk' : 'Cold';

  // ── Settings ─────────────────────────────────────────────────────────────
  String get settingsTitle => _tr ? 'Ayarlar' : 'Settings';
  String get settingsSubtitle =>
      _tr ? 'Premium kontrol paneli' : 'Premium control panel';
  String get appearance => _tr ? 'Görünüm' : 'Appearance';
  String get themes => _tr ? 'Temalar' : 'Themes';
  String get language => _tr ? 'Dil' : 'Language';
  String get account => _tr ? 'Hesap' : 'Account';
  String get profile => _tr ? 'Profil' : 'Profile';
  String get profileSubtitle =>
      _tr ? 'Profil ayarlarını yönet' : 'Manage profile settings';
  String get security => _tr ? 'Güvenlik' : 'Security';
  String get securitySubtitle =>
      _tr ? 'Parola ve oturum yönetimi' : 'Password & session management';
  String get notifications => _tr ? 'Bildirimler' : 'Notifications';
  String get notificationsSubtitle =>
      _tr ? 'Push & uygulama içi bildirimler' : 'Push & in-app notifications';
  String get usage => _tr ? 'Kullanım' : 'Usage';
  String get dailyAIQuery => _tr ? 'Bugünkü AI sorgu' : 'Daily AI queries';
  String get upgradePro => _tr ? 'Pro\'ya Geç' : 'Upgrade to Pro';
  String get backToFree => _tr ? 'Free\'ye Dön' : 'Back to Free';
  String get unlimitedAccess =>
      _tr ? 'Sınırsız erişim · 100 ₺/ay' : 'Unlimited access · ₺100/mo';
  String get upgradeCta =>
      _tr ? 'Premium\'a yükselt — 100 ₺/ay' : 'Upgrade to Premium — ₺100/mo';

  // ── Assistant ────────────────────────────────────────────────────────────
  String get assistantTitle => _tr ? 'İçecek AI' : 'Drink AI';
  String get assistantSubtitle => _tr
      ? 'Kişisel içecek danışmanın — her sorun için buradayım.'
      : 'Your personal beverage advisor — here for every question.';
  String get chatHint => _tr ? 'Bir içecek sor...' : 'Ask about a drink...';
  String get chatbotName => _tr ? 'TrendBot' : 'TrendBot';
  String get chatbotGreeting => _tr
      ? 'Merhaba! Ben TrendBot 🤖 İçecekler hakkında her şeyi sorabileceğin kişisel asistanın. Nasıl yardımcı olabilirim?'
      : 'Hello! I\'m TrendBot 🤖 Your personal assistant for everything about beverages. How can I help you?';
  String get fortuneTitle => _tr ? 'Mistik Falcı' : 'Mystic Seer';
  String get fortuneSubtitle => _tr
      ? 'Gelecek fincanın dibinde gizli... Kahveni içtiysen anlatayım.'
      : 'The future is hidden in the cup... If you drank your coffee, I shall tell.';
  String get fortuneGreeting => _tr
      ? 'Ruhunun derinliklerine yolculuğa hazır mısın? ✨ Kahveni içip fincanını kapattıysan, kaderin fısıltılarını duymak için seni bekliyorum. Fincanını gönder, gizemi çözelim... 🔮'
      : "Are you ready for a journey into the depths of your soul? ✨ If you've finished your coffee and turned the cup, I'm here to listen to the whispers of fate. Send your cup, let's unveil the mystery... 🔮";

  // ── Membership ───────────────────────────────────────────────────────────
  String get proMember => _tr ? 'PRO ÜYE' : 'PRO MEMBER';
  String get freeMember => _tr ? 'FREE' : 'FREE';

  // ── Category Page ────────────────────────────────────────────────────────
  String get allDrinks => _tr ? 'Tüm İçecekler' : 'All Drinks';
  String get searchHint => _tr ? 'İçecek ara...' : 'Search drinks...';
}
