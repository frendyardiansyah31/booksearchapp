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
    final id = json['biblio_id']?.toString() ?? json['id']?.toString() ?? '';

    final title = json['title'] ?? 'Untitled';
    final authors = json['sor'] ?? 'Unknown Author';
    final description = json['notes'] ?? 'No description available.';

    final thumbBase =
        'https://catalogue.uiii.ac.id/lib/minigalnano/createthumb.php?filename=images/docs/{fileImage}&width=120';

    final imgRaw = json['image']?.toString() ?? '';

    String imageUrl;

    if (imgRaw.isEmpty) {
      imageUrl = 'https://via.placeholder.com/120x160?text=No+Image';
    } else if (imgRaw.startsWith('http')) {
      imageUrl = imgRaw;
    } else if (imgRaw.startsWith('./')) {
      imageUrl =
          'https://catalogue.uiii.ac.id/${imgRaw.replaceFirst('./', '')}';
    } else {
      imageUrl = thumbBase.replaceAll('{fileImage}', imgRaw);
    }

    return Book(
      id: id,
      title: title,
      author: authors,
      description: description,
      imageUrl: imageUrl,
    );
  }

  factory Book.fromStoredJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'imageUrl': imageUrl,
      };
}
