import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class FavoriteService {
  static const String _key = 'favorites';

  Future<List<Article>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => Article.fromJson(jsonDecode(e), '')).toList();
  }

  Future<bool> isFavorite(int id) async {
    final favs = await getFavorites();
    return favs.any((a) => a.id == id);
  }

  Future<void> toggleFavorite(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final favs = raw.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    final index = favs.indexWhere((e) => e['id'] == article.id);
    if (index >= 0) {
      favs.removeAt(index);
    } else {
      favs.add(article.toJson());
    }

    await prefs.setStringList(
      _key,
      favs.map((e) => jsonEncode(e)).toList(),
    );
  }
}