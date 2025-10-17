import 'package:flutter/material.dart';
import 'search_result_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = '';

  void _goToSearchResult() {
    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(query: query.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Catalog Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Cari buku...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  query = value;
                },
                onSubmitted: (value) => _goToSearchResult(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _goToSearchResult,
              child: const Text('Cari'),
            ),
          ],
        ),
      ),
    );
  }
}
