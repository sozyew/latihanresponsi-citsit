import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/favorite_service.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteService _favService = FavoriteService();
  List<Article> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final favs = await _favService.getFavorites();
    if (mounted) {
      setState(() {
        _favorites = favs;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(
                  child: Text('Belum ada data favorite'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: _favorites.length,
                  itemBuilder: (_, i) {
                    final a = _favorites[i];
                    return ArticleCard(
                      article: a,
                      isFavorite: true, // Memunculkan icon love merah
                      onFavToggle: () async {
                        // Jika diklik dari list favorite, hapus datanya
                        await _favService.toggleFavorite(a);
                        _load(); // Refresh list
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailScreen(article: a)),
                        ).then((_) => _load()); // Refresh saat kembali
                      },
                    );
                  },
                ),
    );
  }
}