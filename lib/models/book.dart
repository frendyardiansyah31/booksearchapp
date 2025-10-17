class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authors = json['sor'] ?? 'Unknown Author';
    final imgFile = json['image'] ?? '';
    final thumbBase =
        'https://catalog.uiii.ac.id/lib/minigalnano/createthumb.php?filename=images/docs/{fileImage}&width=120';
    final imageUrl = imgFile.isNotEmpty
        ? thumbBase.replaceAll('{fileImage}', imgFile)
        : 'https://via.placeholder.com/120x160?text=No+Image';

    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      author: authors,
      description: json['notes'] ?? 'No description available.',
      imageUrl: imageUrl,
    );
  }
}
