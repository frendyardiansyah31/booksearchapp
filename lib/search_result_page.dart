import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/book.dart';
import '../book_card.dart';
import '../book_detail_page.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final ApiService apiService = ApiService();
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchBooks();
  }

  Future<void> _searchBooks() async {
    try {
      final result = await apiService.searchBooks(widget.query);
      setState(() {
        books = result;
      });
    } catch (e) {
      print('Error search: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil: "${widget.query}"'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
          ? const Center(child: Text('Tidak ada hasil ditemukan.'))
          : ListView.builder(
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
      ),
    );
  }
}
