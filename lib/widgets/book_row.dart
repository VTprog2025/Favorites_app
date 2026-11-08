
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../providers/favorites_provider.dart';

class BookRow extends StatelessWidget {
  final BookModel book;

  const BookRow({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: const CircleAvatar(
          child: Icon(Icons.menu_book),
        ),
        title: Text(
          book.bookTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(book.bookAuthor),
        trailing: IconButton(
          tooltip: book.isFavorite
              ? 'Remove favorite'
              : 'Add favorite',
          icon: Icon(
            book.isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: book.isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            context
                .read<FavoritesProvider>()
                .toggleBookFavorite(book.id);
          },
        ),
      ),
    );
  }
}
