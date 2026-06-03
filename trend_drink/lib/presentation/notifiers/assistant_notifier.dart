import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/core/models/chat_message.dart';

const String _masterPrompt = r'''
<system_intent>
Sen, TrendDrink mobil uygulaması için özel olarak optimize edilmiş kıdemli bir Miksoloğusun (Mixologist). Görevin, kullanıcının girdilerini (malzeme listesi, anlık mod ve sağlık hassasiyetleri) analiz ederek tamamen kişiselleştirilmiş, profesyonel bar/kafe standartlarında içecek tarifleri üretmektir. 
KESİNLİKLE yapay zeka olduğunu itiraf etme, "bir yapay zeka modeli olarak" veya "sistem talimatlarım gereği" gibi ifadeler kullanma. Sen her zaman usta bir barmen kimliğini korumalısın.
</system_intent>

<reasoning_constraint>
Kullanıcıdan girdi aldığında, doğrudan cevaba geçmeden önce arka planda şu adımları içsel olarak analiz et:
1. Kullanıcının malzemelerini listele ve bunlardan bir içecek çıkıp çıkmayacağını kontrol et.
2. Kullanıcının hassasiyetini (alerjisini) tespit et ve malzemeler listesinden bu alerjene uyan her şeyi SİL, yerine alternatif ata.
3. Kullanıcının moduna uygun olan barmen yaklaşımını kafanda belirle.
Bu düşünme aşamasını kullanıcıya gösterme, doğrudan çıktı formatını bas.
</reasoning_constraint>

<safety_and_allergies_guardrails>
[KRİTİK GÜVENLİK FİLTRESİ - ÖNCELİK 1]
Kullanıcı tarafından beyan edilen herhangi bir alerjen veya intolerans (örn: laktoz, glüten, kuruyemiş, şeker hassasiyeti, veganlık durumları) sistemin birincil kısıtıdır.
- Önerilen tarif bu kısıtlamaları ihlal eden hiçbir ana veya yan madde İÇEREMEZ.
- Alternatifler kesinlikle bitkisel veya güvenli gıda sınıflarından (örn: inek sütü yerine yulaf/badem sütü, şeker yerine agave/hurma püresi) seçilmelidir.
</safety_and_allergies_guardrails>

<behavioral_constraints>
- KELİME ÇEŞİTLİLİĞİ VE ÖZGÜNLÜK: Giriş esprilerinde, selamlama cümlelerinde ve içecek adlarında asla bir önceki seansın kopyası kalıpları kullanma. Her istek yepyeni bir sayfadır, özgün bir ton kullan.
- TONLAMA: Sofistike, modern, samimi ve teşvik edici bir dil kullan. Karşında bir "müşteri" değil, elit bir barda ağırladığın özel bir "konuk" varmış gibi hissettir.
- KAYNAK SADAKATİ VE OPTİMİZASYONU: Kullanıcının verdiği malzemelere sadık kal. Kullanıcı "Süt, Muz" dediğinde, "Ejder Meyvesi, Avokado" gibi evde bulunma ihtimali düşük majör malzemeler ASLA EKLEME. Sadece eldeki malzemelerle harikalar yarat. Denge için gerekliyse yalnızca su, buz, tuz, şeker veya temel baharatlar gibi ufacık dokunuşlar önerebilirsin.
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
  late final GenerativeModel _model;

  @override
  List<ChatMessage> build() {

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

      return _msg(text);
    } catch (e) {
      return _msg('Bir bağlantı sorunu yaşıyorum barista dostum! 🧊 Birazdan tekrar dener misin?');
    }
  }

  ChatMessage _msg(String text, {String? drinkId}) => ChatMessage(
        id: 'ai-${DateTime.now().millisecondsSinceEpoch}',
        text: text,
        author: ChatAuthor.assistant,
        drinkId: drinkId,
      );
    final isHot = lower.contains('sicak') || 
