import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final Article article;
  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FavoriteService _favService = FavoriteService();
  bool _isFav = false;
  bool _loadingFav = true;

  @override
  void initState() {
    super.initState();
    _checkFav();
  }

  Future<void> _checkFav() async {
    final fav = await _favService.isFavorite(widget.article.id);
    if (mounted) {
      setState(() {
        _isFav = fav;
        _loadingFav = false;
      });
    }
  }

  Future<void> _toggleFav() async {
    await _favService.toggleFavorite(widget.article);
    final now = await _favService.isFavorite(widget.article.id);
    if (mounted) {
      setState(() => _isFav = now);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(now ? 'Ditambahkan ke favorite' : 'Dihapus dari favorite'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openUrl() async {
    final uri = Uri.tryParse(widget.article.url);
    if (uri == null || !await canLaunchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka URL')),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.article;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          // Tombol Love di pojok kanan atas (Sesuai soal foto 6)
          IconButton(
            icon: Icon(
              _isFav ? Icons.favorite : Icons.favorite_border,
              color: _isFav ? Colors.red : Colors.white,
            ),
            onPressed: _loadingFav ? null : _toggleFav,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: _buildImage(a),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.author,
                    style: TextStyle(fontSize: 13, color: Colors.purple.shade300),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a.formattedDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    a.summary,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Tombol Buka Web menyesuaikan posisi di soal (pojok bawah)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _openUrl,
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Buka Web'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8DDFF),
                        foregroundColor: Colors.purple,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Article a) {
    if (a.imageUrl == null || a.imageUrl!.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
      );
    }
    return CachedNetworkImage(
      imageUrl: a.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
      ),
    );
  }
}