import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';

class FavoritesProvider extends ChangeNotifier {
  bool isDarkMode = false;

  final cities = sampleCities;
  final hobbies = sampleHobbies;
  final books = sampleBooks;

  FavoritesProvider() {
    loadFavorites();
  }

  void toggleCityFavorite(int cityId) {
    final city = cities.firstWhere(
          (city) => city.id == cityId,
    );

    city.isFavorite = !city.isFavorite;
    notifyListeners();
    unawaited(saveFavorites());
  }

  void toggleHobbyFavorite(int hobbyId) {
    final hobby = hobbies.firstWhere(
          (hobby) => hobby.id == hobbyId,
    );

    hobby.isFavorite = !hobby.isFavorite;
    notifyListeners();
    unawaited(saveFavorites());
  }

  void toggleBookFavorite(int bookId) {
    final book = books.firstWhere(
          (book) => book.id == bookId,
    );

    book.isFavorite = !book.isFavorite;
    notifyListeners();
    unawaited(saveFavorites());
  }

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
    unawaited(saveTheme());
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final cityIds = cities
        .where((city) => city.isFavorite)
        .map((city) => city.id.toString())
        .toList();

    final hobbyIds = hobbies
        .where((hobby) => hobby.isFavorite)
        .map((hobby) => hobby.id.toString())
        .toList();

    final bookIds = books
        .where((book) => book.isFavorite)
        .map((book) => book.id.toString())
        .toList();

    await prefs.setStringList('favoriteCities', cityIds);
    await prefs.setStringList('favoriteHobbies', hobbyIds);
    await prefs.setStringList('favoriteBooks', bookIds);
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDarkMode);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final cityIds =
        prefs.getStringList('favoriteCities') ?? [];
    final hobbyIds =
        prefs.getStringList('favoriteHobbies') ?? [];
    final bookIds =
        prefs.getStringList('favoriteBooks') ?? [];

    for (final city in cities) {
      city.isFavorite =
          cityIds.contains(city.id.toString());
    }

    for (final hobby in hobbies) {
      hobby.isFavorite =
          hobbyIds.contains(hobby.id.toString());
    }

    for (final book in books) {
      book.isFavorite =
          bookIds.contains(book.id.toString());
    }

    isDarkMode = prefs.getBool('darkMode') ?? false;

    notifyListeners();
  }

  Future<void> clearFavorites() async {
    for (final city in cities) {
      city.isFavorite = false;
    }

    for (final hobby in hobbies) {
      hobby.isFavorite = false;
    }

    for (final book in books) {
      book.isFavorite = false;
    }

    notifyListeners();
    await saveFavorites();
  }
}
