import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/book.dart';
import '../book_card.dart';
import '../book_detail_page.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final ApiService apiService = ApiService();
  List<Book> books = [];
  bool isLoading = true;

  late String query;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    query = widget.query;
    _controller.text = query;
    _searchBooks();
  }

  Future<void> _searchBooks() async {
    setState(() => isLoading = true);
    try {
      final result = await apiService.searchBooks(query);
      setState(() {
        books = result;
      });
    } catch (e) {
      debugPrint('Error search: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToSearchResult() {
    FocusScope.of(context).unfocus();
    _searchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth > 1000 ? 100.0 : 16.0;
    final maxContentWidth = 900.0;

    return Scaffold(
      appBar: AppBar(title: Text('Hasil: "${widget.query}"')),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              hintText: 'Cari buku...',
                              hintStyle: TextStyle(color: theme.hintColor),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              query = value;
                            },
                            onSubmitted: (_) => _goToSearchResult(),
                          ),
                        ),
                        InkWell(
                          onTap: _goToSearchResult,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                            ),
                            child: Icon(
                              Icons.search,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : books.isEmpty
                          ? const Center(
                              child: Text(
                                'Tidak ada hasil ditemukan.',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 700;
                                return isWide
                                    ? GridView.builder(
                                        padding: const EdgeInsets.only(top: 8),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 20,
                                          childAspectRatio: 0.6,
                                        ),
                                        itemCount: books.length,
                                        itemBuilder: (context, index) {
                                          final book = books[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookDetailPage(
                                                          book: book),
                                                ),
                                              );
                                            },
                                            child: BookCard(book: book),
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        itemCount: books.length,
                                        itemBuilder: (context, index) {
                                          final book = books[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookDetailPage(
                                                          book: book),
                                                ),
                                              );
                                            },
                                            child: BookCard(book: book),
                                          );
                                        },
                                      );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
