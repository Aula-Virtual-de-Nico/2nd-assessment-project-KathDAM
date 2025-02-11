import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = "favorite_events";

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> toggleFavorite(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();

    if (favorites.contains(eventId)) {
      favorites.remove(eventId);
    } else {
      favorites.add(eventId);
    }

    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<bool> isFavorite(String eventId) async {
    final favorites = await getFavorites();
    return favorites.contains(eventId);
  }
}
