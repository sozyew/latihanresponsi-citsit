class Article {
  final int id;
  final String title;
  final String? imageUrl;
  final String author;
  final String publishedAt;
  final String summary;
  final String url;
  final String category;

  Article({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.summary,
    required this.url,
    required this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json, String category) {
    // Logika pengambilan author: Jika authors kosong, pakai news_site
    String authorName = json['news_site'] ?? '-';
    if (json['authors'] != null && (json['authors'] as List).isNotEmpty) {
      authorName = json['authors'][0]['name'] ?? authorName;
    }

    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '-',
      imageUrl: json['image_url'],
      author: authorName,
      publishedAt: json['published_at'] ?? '-',
      summary: json['summary'] ?? '-',
      url: json['url'] ?? '',
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image_url': imageUrl,
        'news_site': author,
        'published_at': publishedAt,
        'summary': summary,
        'url': url,
        'category': category,
      };

  String get formattedDate {
    try {
      final dt = DateTime.parse(publishedAt);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}Z';
    } catch (_) {
      return publishedAt;
    }
  }
}