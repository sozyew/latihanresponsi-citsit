import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback? onFavToggle;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    this.isFavorite = false,
    this.onFavToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFFDF7FF),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.purple.shade100),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 60,
                  child: _buildImage(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.author,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              if (isFavorite)
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: onFavToggle,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Jika data gambar dari API benar-benar kosong (null)
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return _placeholder();
    }
    
    // Bypass CORS gambar via weserv proxy
    final proxyImage = 'https://images.weserv.nl/?url=${Uri.encodeComponent(article.imageUrl!)}';

    return Image.network(
      proxyImage,
      fit: BoxFit.cover,
      // Jika gambar gagal dimuat (error), baru munculkan abu-abu
      errorBuilder: (context, error, stackTrace) {
        return _placeholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(color: Colors.grey.shade200); // Placeholder saat loading
      },
    );
  }

  // Kotak abu-abu dengan ikon sebagai Exception Handling
  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.image, color: Colors.white, size: 30),
    );
  }
}