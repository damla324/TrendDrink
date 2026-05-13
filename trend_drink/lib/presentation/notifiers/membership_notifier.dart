import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trenddrink/data/repositories/membership_preferences.dart';
import 'package:trenddrink/domain/models/membership_model.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final membershipPreferencesProvider = FutureProvider<MembershipPreferences>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return MembershipPreferences(prefs);
});

final membershipProvider = NotifierProvider<MembershipNotifier, MembershipModel>(
  MembershipNotifier.new,
);

class MembershipNotifier extends Notifier<MembershipModel> {
  @override
  MembershipModel build() {
    final prefsAsync = ref.watch(membershipPreferencesProvider);
    return prefsAsync.whenData((prefs) {
      final saved = prefs.getMembership();
      return saved ?? MembershipModel.free();
    }).value ?? MembershipModel.free();
  }

  Future<void> upgradeToPro() async {
    final prefs = await ref.read(membershipPreferencesProvider.future);
    await prefs.upgradeToPro();
    state = MembershipModel.pro();
  }

  Future<void> resetToFree() async {
    final prefs = await ref.read(membershipPreferencesProvider.future);
    await prefs.resetToFree();
    state = MembershipModel.free();
  }

  void consumeAIRequest() {
    if (!state.isPro && state.aiRequestsRemaining > 0) {
      final newState = state.copyWith(
        aiRequestsRemaining: state.aiRequestsRemaining - 1,
      );
      ref.read(membershipPreferencesProvider.future).then((prefs) {
        prefs.saveMembership(newState);
      });
      state = newState;
    }
  }

  void resetDailyQuota() {
    if (!state.isPro) {
      final newState = state.copyWith(
        aiRequestsRemaining: state.maxDailyAIRequests,
      );
      ref.read(membershipPreferencesProvider.future).then((prefs) {
        prefs.saveMembership(newState);
      });
      state = newState;
    }
  }
}
