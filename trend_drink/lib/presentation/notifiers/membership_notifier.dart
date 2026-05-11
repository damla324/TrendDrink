import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trenddrink/data/repositories/membership_preferences.dart';
import 'package:trenddrink/domain/models/membership_model.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final membershipPreferencesProvider = FutureProvider<MembershipPreferences?>((ref) async {
  try {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return MembershipPreferences(prefs);
  } catch (_) {
    return null;
  }
});

class MembershipController extends StateNotifier<MembershipModel> {
  final MembershipPreferences? _prefs;

  MembershipController(this._prefs) : super(MembershipModel.free()) {
    _initialize();
  }

  void _initialize() {
    final saved = _prefs?.getMembership();
    state = saved ?? MembershipModel.free();
  }

  Future<void> upgradeToPro() async {
    await _prefs?.upgradeToPro();
    state = MembershipModel.pro();
  }

  Future<void> resetToFree() async {
    await _prefs?.resetToFree();
    state = MembershipModel.free();
  }

  void consumeAIRequest() {
    if (!state.isPro && state.aiRequestsRemaining > 0) {
      final newState = state.copyWith(
        aiRequestsRemaining: state.aiRequestsRemaining - 1,
      );
      _prefs?.saveMembership(newState);
      state = newState;
    }
  }

  void resetDailyQuota() {
    if (!state.isPro) {
      final newState = state.copyWith(
        aiRequestsRemaining: state.maxDailyAIRequests,
      );
      _prefs?.saveMembership(newState);
      state = newState;
    }
  }
}

final membershipProvider = StateNotifierProvider<MembershipController, MembershipModel>((ref) {
  final prefsAsync = ref.watch(membershipPreferencesProvider);
  
  return prefsAsync.when(
    data: (prefs) => MembershipController(prefs),
    loading: () => MembershipController(null),
    error: (_, __) => MembershipController(null),
  );
});
