import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class FavoritesService {
  static const _kPrefsKey = 'favorite_books';

  FavoritesService._privateConstructor();
  static final FavoritesService instance =
      FavoritesService._privateConstructor();

  final ValueNotifier<Map<String, Book>> favorites =
      ValueNotifier<Map<String, Book>>(<String, Book>{});

  SharedPreferences? _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? stored = _prefs!.getStringList(_kPrefsKey);
    if (stored == null) {
      favorites.value = <String, Book>{};
      return;
    }
    final books = stored.map(
      (s) => Book.fromStoredJson(json.decode(s) as Map<String, dynamic>),
    );
    favorites.value = {for (final b in books) b.id: b};
  }

  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    final encoded =
        favorites.value.values.map((b) => json.encode(b.toJson())).toList();
    await _prefs!.setStringList(_kPrefsKey, encoded);
  }

  bool isFavorite(String bookId) => favorites.value.containsKey(bookId);

  Future<void> toggleFavorite(Book book) async {
    final current = Map<String, Book>.from(favorites.value);
    if (current.containsKey(book.id)) {
      current.remove(book.id);
    } else {
      current[book.id] = book;
    }
    favorites.value = current;
    await _save();
  }

  List<Book> getFavoriteBooks() => favorites.value.values.toList();
}
