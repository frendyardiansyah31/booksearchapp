import 'package:flutter/material.dart';
import 'models/book.dart';
import 'book_detail_page.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final Future<List<Book>> future;

  const CategorySection({super.key, required this.title, required this.future});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    final double spacing = isWide ? 24 : 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<Book>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load $title',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            } else {
              final books = snapshot.data ?? [];
              if (books.isEmpty) {
                return const Center(child: Text('No books found'));
              }

              return SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16),
                  itemCount: books.length,
                  separatorBuilder: (_, __) => SizedBox(width: spacing),
                  itemBuilder: (context, index) {
                    final b = books[index];
                    final width = isWide ? 160.0 : 120.0;
                    return _BookCard(title: title, book: b, width: width);
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  final Book book;
  final double? width;

  const _BookCard({required this.title, required this.book, this.width});

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 120;
    final cardHeight = cardWidth * 4 / 3;

    final heroTag = '$title-${book.id}';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book, heroTag: heroTag),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, st) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: cardWidth,
            child: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
