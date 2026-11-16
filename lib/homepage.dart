import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'search_result_page.dart';
import 'models/book.dart';
import 'book_detail_page.dart';
import 'category_section.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const HomePage({super.key, this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String query = '';
  late Future<List<Book>> _popularFuture;
  late Future<List<Book>> _latestFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _popularFuture = fetchPopularBooks();
    _latestFuture = fetchLatestBooks();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToSearchResult() {
    if (query.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(query: query.trim()),
      ),
    );
  }

  void _goToBookDetail(Book book, String heroTag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(book: book, heroTag: heroTag),
      ),
    );
  }

  Future<List<Book>> fetchPopularBooks() async {
    final uri = Uri.parse('https://catalogue.uiii.ac.id/?p=api/biblio/popular');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to load popular books');
    final List<dynamic> jsonData = json.decode(resp.body);
    return jsonData.map((item) => Book.fromJson(item)).toList();
  }

  Future<List<Book>> fetchLatestBooks() async {
    final uri = Uri.parse('https://catalogue.uiii.ac.id/?p=api/biblio/latest');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Failed to load latest books');
    final List<dynamic> jsonData = json.decode(resp.body);
    return jsonData.map((item) => Book.fromJson(item)).toList();
  }

  Widget _buildPopularSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return FutureBuilder<List<Book>>(
      future: _popularFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Text('Failed to load popular books');
        }
        final books = snapshot.data ?? [];
        if (isMobile) {
          return SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final b = books[index];
                return GestureDetector(
                  onTap: () => _goToBookDetail(b, 'popular-${b.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'popular-${b.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            b.imageUrl,
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, st) => Container(
                              width: 120,
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 120,
                        child: Text(
                          b.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: books.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final b = books[index];
              return _buildBookCard(b);
            },
          );
        }
      },
    );
  }

  Widget _buildBookCard(Book b) {
    return GestureDetector(
      onTap: () => _goToBookDetail(b, 'popular-${b.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'popular-${b.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                b.imageUrl,
                width: 120,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (c, e, st) => Container(
                  width: 120,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 120,
            child: Text(
              b.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestSection() {
    return FutureBuilder<List<Book>>(
      future: _latestFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text('Failed to load latest books');
        }
        final books = snapshot.data ?? [];
        return SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final b = books[index];
              return GestureDetector(
                onTap: () => _goToBookDetail(b, 'latest-${b.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'latest-${b.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          b.imageUrl,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: Text(
                        b.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth > 1000 ? 120.0 : 24.0;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Library Catalog Search'),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ListView(
              children: [
                const SizedBox(height: 24),

                Container(
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
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            hintText: 'Cari buku...',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => query = value,
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

                const SizedBox(height: 32),

                Text(
                  'Popular Books',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPopularSection(),

                const SizedBox(height: 32),

                // 📚 Tabs
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Reference'),
                    Tab(text: 'Fiction'),
                    Tab(text: 'Jusuf Kalla'),
                    Tab(text: 'Rare & Special'),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      CategorySection(
                        title: 'Reference Collection',
                        future: ApiService.fetchBooksByCategory(
                          'Reference Collection',
                        ),
                      ),
                      CategorySection(
                        title: 'Fiction Collection',
                        future: ApiService.fetchBooksByCategory(
                          'Fiction Collection',
                        ),
                      ),
                      CategorySection(
                        title: 'Jusuf Kalla Collection',
                        future: ApiService.fetchBooksByCategory(
                          'Jusuf Kalla Collection',
                        ),
                      ),
                      CategorySection(
                        title: 'Rare Books and Special Collections',
                        future: ApiService.fetchBooksByCategory(
                          'Rare Books and Special Collections',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Text(
                  'Latest Books',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildLatestSection(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
