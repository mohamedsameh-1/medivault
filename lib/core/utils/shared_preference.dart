import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static const String _kOnboardingCompletedKey = 'is_onboarding_completed';

  static Future<bool> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_kOnboardingCompletedKey, value);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingCompletedKey) ?? false;
  }
}
