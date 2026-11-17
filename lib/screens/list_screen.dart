import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';

class ListScreen extends StatefulWidget {
  final String menu;
  final String title;
  const ListScreen({super.key, required this.menu, required this.title});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ApiService _api = ApiService();
  List<Article> _all = [];
  List<Article> _filtered = [];
  List<String> _authors = [];
  String? _selectedAuthor;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _api.fetchArticles(widget.menu);
      final authors = <String>{};
      for (final a in data) {
        if (a.author.isNotEmpty && a.author != '-') authors.add(a.author);
      }
      setState(() {
        _all = data;
        _filtered = data;
        _authors = authors.toList();
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _applyFilter(String? author) {
    setState(() {
      _selectedAuthor = author;
      if (author == null) {
        _filtered = _all;
      } else {
        _filtered = _all.where((a) => a.author == author).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoriteScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Filter "Semua" (Sederhana, tanpa icon manual)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Semua'),
                    selected: _selectedAuthor == null,
                    selectedColor: const Color(0xFFE8DDFF),
                    onSelected: (_) => _applyFilter(null),
                  ),
                ),
                // Filter Author (Sederhana, tanpa icon manual)
                ..._authors.map((author) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(author),
                    selected: _selectedAuthor == author,
                    selectedColor: const Color(0xFFE8DDFF),
                    onSelected: (_) => _applyFilter(author),
                  ),
                )),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }
    if (_filtered.isEmpty) return const Center(child: Text('Tidak ada data'));
    
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: _filtered.length,
        itemBuilder: (_, i) {
          final a = _filtered[i];
          return ArticleCard(
            article: a,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(article: a))).then((_) => setState(() {}));
            },
          );
        },
      ),
    );
  }
}