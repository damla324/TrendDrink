import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/domain/services/ai_service_access.dart';

final aiServiceProvider = Provider<AIServiceAccessControl>((ref) {
  return AIServiceAccessControl();
});
