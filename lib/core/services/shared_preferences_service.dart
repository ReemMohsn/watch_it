import 'package:e_learning/core/constants/shared_preferences_keys.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<bool> get isOnboardingCompleted async =>
      await _preferences.getBool(SharedPreferencesKeys.onboardingCompleted) ??
      false;

  Future<void> setOnboardingCompleted() =>
      _preferences.setBool(SharedPreferencesKeys.onboardingCompleted, true);
}
