import 'package:flutter/material.dart';
import 'models/book.dart';
import 'services/favorites_service.dart';
import 'book_card.dart';
import 'book_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ValueListenableBuilder<Map<String, Book>>(
        valueListenable: FavoritesService.instance.favorites,
        builder: (context, favoritesMap, _) {
          final books = favoritesMap.values.toList();
          if (books.isEmpty) {
            return const Center(child: Text('No favorite books yet.'));
          }
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: book),
                    ),
                  );
                },
                child: BookCard(book: book),
              );
            },
          );
        },
      ),
    );
  }
}
