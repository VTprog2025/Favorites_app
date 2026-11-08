
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();

    final cities = provider.cities
        .where((city) => city.isFavorite)
        .toList();

    final hobbies = provider.hobbies
        .where((hobby) => hobby.isFavorite)
        .toList();

    final books = provider.books
        .where((book) => book.isFavorite)
        .toList();

    final total = cities.length +
        hobbies.length +
        books.length;

    Widget favoriteTile({
      required String title,
      required String subtitle,
      required Widget leading,
      required VoidCallback onRemove,
    }) {
      return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: leading,
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: IconButton(
            tooltip: 'Remove favorite',
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: onRemove,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Favorites',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 8),

              Text('$total saved items'),

              const SizedBox(height: 20),

              Expanded(
                child: total == 0
                    ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                      ),
                      SizedBox(height: 12),
                      Text('No favorites yet'),
                      Text(
                        'Browse categories to add some!',
                      ),
                    ],
                  ),
                )
                    : ListView(
                  children: [
                    for (final city in cities)
                      favoriteTile(
                        title: city.cityName,
                        subtitle: 'City',
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/${city.cityImage}.jpeg',
                          ),
                        ),
                        onRemove: () {
                          provider.toggleCityFavorite(
                            city.id,
                          );
                        },
                      ),

                    for (final hobby in hobbies)
                      favoriteTile(
                        title: hobby.hobbyName,
                        subtitle: 'Hobby',
                        leading: CircleAvatar(
                          child: Text(
                            hobby.hobbyIcon,
                          ),
                        ),
                        onRemove: () {
                          provider.toggleHobbyFavorite(
                            hobby.id,
                          );
                        },
                      ),

                    for (final book in books)
                      favoriteTile(
                        title: book.bookTitle,
                        subtitle: book.bookAuthor,
                        leading: const CircleAvatar(
                          child: Icon(Icons.book),
                        ),
                        onRemove: () {
                          provider.toggleBookFavorite(
                            book.id,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
