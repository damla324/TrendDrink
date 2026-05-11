import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:trenddrink/domain/models/membership_model.dart';

class AIServiceAccessControl {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  late final GenerativeModel _model;
  
  AIServiceAccessControl() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  /// Check if user can access AI features
  bool canAccessAI(MembershipModel membership) {
    if (membership.isPro) return true;
    return membership.aiRequestsRemaining > 0;
  }

  /// Throws exception if user cannot access AI
  void validateAIAccess(MembershipModel membership) {
    if (!canAccessAI(membership)) {
      throw AIAccessDeniedException(
        'AI features are only available for Pro members or you have reached your daily limit.',
      );
    }
  }

  /// Get AI response with membership validation
  Future<String> askAI(String prompt, MembershipModel membership) async {
    validateAIAccess(membership);

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw AIServiceException('No response from AI model');
      }

      return response.text!;
    } catch (e) {
      throw AIServiceException('Failed to get AI response: $e');
    }
  }

  /// Stream AI response with membership validation
  Stream<String> askAIStream(String prompt, MembershipModel membership) async* {
    validateAIAccess(membership);

    try {
      final content = [Content.text(prompt)];
      final stream = _model.generateContentStream(content);

      await for (final response in stream) {
        if (response.text != null) {
          yield response.text!;
        }
      }
    } catch (e) {
      throw AIServiceException('Failed to get AI response: $e');
    }
  }

  /// Get usage quota info
  Map<String, dynamic> getUsageInfo(MembershipModel membership) {
    if (membership.isPro) {
      return {
        'canUseAI': true,
        'remaining': -1,
        'unlimited': true,
        'message': 'You have unlimited AI requests as a Pro member.',
      };
    }

    return {
      'canUseAI': membership.aiRequestsRemaining > 0,
      'remaining': membership.aiRequestsRemaining,
      'unlimited': false,
      'message': 'You have ${membership.aiRequestsRemaining} AI requests remaining today.',
    };
  }
}

class AIAccessDeniedException implements Exception {
  final String message;
  AIAccessDeniedException(this.message);

  @override
  String toString() => 'AIAccessDeniedException: $message';
}

class AIServiceException implements Exception {
  final String message;
  AIServiceException(this.message);

  @override
  String toString() => 'AIServiceException: $message';
}
