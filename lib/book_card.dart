import 'package:flutter/material.dart';
import 'models/book.dart';
import 'services/favorites_service.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({required this.book, super.key, this.onTap});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder<Map<String, Book>>(
          valueListenable: FavoritesService.instance.favorites,
          builder: (context, favorites, _) {
            final isFavorite = favorites.containsKey(widget.book.id);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'book-${widget.book.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      widget.book.imageUrl,
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.book.author,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: widget.onTap,
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () async {
                    await FavoritesService.instance.toggleFavorite(widget.book);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite
                            ? 'Removed from favorites'
                            : 'Added to favorites'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
