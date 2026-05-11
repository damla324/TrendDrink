import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trenddrink/domain/models/membership_model.dart';

class MembershipPreferences {
  static const String _membershipKey = 'membership_data';
  static const String _themeIndexKey = 'theme_index';
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences _prefs;

  MembershipPreferences(this._prefs);

  // Membership
  Future<void> saveMembership(MembershipModel membership) async {
    await _prefs.setString(_membershipKey, jsonEncode(membership.toJson()));
  }

  MembershipModel? getMembership() {
    final json = _prefs.getString(_membershipKey);
    if (json == null) return null;
    try {
      return MembershipModel.fromJson(jsonDecode(json));
    } catch (e) {
      return null;
    }
  }

  Future<void> upgradeToPro() async {
    await saveMembership(MembershipModel.pro());
  }

  Future<void> resetToFree() async {
    await saveMembership(MembershipModel.free());
  }

  // Theme preferences
  Future<void> saveThemeIndex(int index) async {
    await _prefs.setInt(_themeIndexKey, index);
  }

  int getThemeIndex() {
    return _prefs.getInt(_themeIndexKey) ?? 0;
  }

  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? 'system';
  }
}
