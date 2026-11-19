import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Favorites
  List<String> getFavorites() {
    return _prefs.getStringList('favorite_prompts') ?? [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    await _prefs.setStringList('favorite_prompts', favorites);
  }

  // Search History
  List<String> getSearchHistory() {
    return _prefs.getStringList('search_history') ?? [];
  }

  Future<void> addSearchQuery(String query) async {
    List<String> history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 20) history = history.sublist(0, 20);
      await _prefs.setStringList('search_history', history);
    }
  }

  Future<void> clearSearchHistory() async {
    await _prefs.remove('search_history');
  }

  // Recently Viewed
  List<String> getRecentlyViewed() {
    return _prefs.getStringList('recently_viewed') ?? [];
  }

  Future<void> addRecentlyViewed(String promptId) async {
    List<String> recent = getRecentlyViewed();
    recent.remove(promptId);
    recent.insert(0, promptId);
    if (recent.length > 15) recent = recent.sublist(0, 15);
    await _prefs.setStringList('recently_viewed', recent);
  }

  // Settings / Theme
  bool isDarkMode() {
    return _prefs.getBool('is_dark_mode') ?? true;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool('onboarding_completed', completed);
  }
}
