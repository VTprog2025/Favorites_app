
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/city_card.dart';
import '../widgets/hobby_row.dart';
import '../widgets/book_row.dart';

enum ContentCategory {
  cities,
  hobbies,
  books,
}

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  ContentCategory selectedCategory = ContentCategory.cities;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
    context.watch<FavoritesProvider>();

    final search = searchText.trim().toLowerCase();

    final filteredCities = favoritesProvider.cities
        .where((city) =>
        city.cityName.toLowerCase().contains(search))
        .toList();

    final filteredHobbies = favoritesProvider.hobbies
        .where((hobby) =>
        hobby.hobbyName.toLowerCase().contains(search))
        .toList();

    final filteredBooks = favoritesProvider.books
        .where((book) =>
    book.bookTitle.toLowerCase().contains(search) ||
        book.bookAuthor.toLowerCase().contains(search))
        .toList();

    Widget categoryContent;

    switch (selectedCategory) {
      case ContentCategory.cities:
        categoryContent = ListView.builder(
          itemCount: filteredCities.length,
          itemBuilder: (context, index) {
            return CityCard(city: filteredCities[index]);
          },
        );
        break;

      case ContentCategory.hobbies:
        categoryContent = ListView.builder(
          itemCount: filteredHobbies.length,
          itemBuilder: (context, index) {
            return HobbyRow(hobby: filteredHobbies[index]);
          },
        );
        break;

      case ContentCategory.books:
        categoryContent = ListView.builder(
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            return BookRow(book: filteredBooks[index]);
          },
        );
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Favorites',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ContentCategory>(
                  segments: const [
                    ButtonSegment(
                      value: ContentCategory.cities,
                      label: Text('Cities'),
                    ),
                    ButtonSegment(
                      value: ContentCategory.hobbies,
                      label: Text('Hobbies'),
                    ),
                    ButtonSegment(
                      value: ContentCategory.books,
                      label: Text('Books'),
                    ),
                  ],
                  selected: {selectedCategory},
                  onSelectionChanged: (selection) {
                    setState(() {
                      selectedCategory = selection.first;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText:
                  'Search ${selectedCategory.name}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: categoryContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
