enum MembershipTier {
  free,
  pro,
}

class MembershipModel {
  final MembershipTier tier;
  final DateTime? purchaseDate;
  final bool hasUnlimitedAI;
  final bool hasPremiumThemes;
  final int aiRequestsRemaining;
  final int maxDailyAIRequests;

  MembershipModel({
    required this.tier,
    this.purchaseDate,
    required this.hasUnlimitedAI,
    required this.hasPremiumThemes,
    required this.aiRequestsRemaining,
    required this.maxDailyAIRequests,
  });

  bool get isPro => tier == MembershipTier.pro;

  bool get canAccessAI {
    if (isPro) return true;
    return aiRequestsRemaining > 0;
  }

  factory MembershipModel.free() {
    return MembershipModel(
      tier: MembershipTier.free,
      hasUnlimitedAI: false,
      hasPremiumThemes: false,
      aiRequestsRemaining: 5,
      maxDailyAIRequests: 5,
    );
  }

  factory MembershipModel.pro() {
    return MembershipModel(
      tier: MembershipTier.pro,
      purchaseDate: DateTime.now(),
      hasUnlimitedAI: true,
      hasPremiumThemes: true,
      aiRequestsRemaining: -1,
      maxDailyAIRequests: -1,
    );
  }

  MembershipModel copyWith({
    MembershipTier? tier,
    DateTime? purchaseDate,
    bool? hasUnlimitedAI,
    bool? hasPremiumThemes,
    int? aiRequestsRemaining,
    int? maxDailyAIRequests,
  }) {
    return MembershipModel(
      tier: tier ?? this.tier,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      hasUnlimitedAI: hasUnlimitedAI ?? this.hasUnlimitedAI,
      hasPremiumThemes: hasPremiumThemes ?? this.hasPremiumThemes,
      aiRequestsRemaining: aiRequestsRemaining ?? this.aiRequestsRemaining,
      maxDailyAIRequests: maxDailyAIRequests ?? this.maxDailyAIRequests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tier': tier.toString(),
      'purchaseDate': purchaseDate?.toIso8601String(),
      'hasUnlimitedAI': hasUnlimitedAI,
      'hasPremiumThemes': hasPremiumThemes,
      'aiRequestsRemaining': aiRequestsRemaining,
      'maxDailyAIRequests': maxDailyAIRequests,
    };
  }

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      tier: json['tier'] == 'MembershipTier.pro' ? MembershipTier.pro : MembershipTier.free,
      purchaseDate: json['purchaseDate'] != null ? DateTime.parse(json['purchaseDate']) : null,
      hasUnlimitedAI: json['hasUnlimitedAI'] ?? false,
      hasPremiumThemes: json['hasPremiumThemes'] ?? false,
      aiRequestsRemaining: json['aiRequestsRemaining'] ?? 5,
      maxDailyAIRequests: json['maxDailyAIRequests'] ?? 5,
    );
  }
}
