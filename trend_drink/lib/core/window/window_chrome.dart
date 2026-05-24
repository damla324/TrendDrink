import 'dart:io' show Platform;
import 'dart:ui' show Color, Size;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_manager/window_manager.dart';

/// Desktop pencere yapılandırması: frameless, transparan, yuvarlak köşe.
class WindowChrome {
  WindowChrome._();

  static Future<void> init() async {
    if (kIsWeb) return;
    if (!(Platform.isWindows || Platform.isMacOS || Platform.isLinux)) return;

    await windowManager.ensureInitialized();

    const options = WindowOptions(
      size: Size(1440, 920),
      minimumSize: Size(1024, 680),
      center: true,
      backgroundColor: Color(0x00000000), // transparent
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
      title: 'TrendDrink – Premium Beverage Experience',
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setBackgroundColor(const Color(0x00000000));
      await windowManager.setHasShadow(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
