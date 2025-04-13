class Article {
  final String title;
  final String sourceName;
  final String publishedAt;
  final String description;
  final String url;
  final String? urlToImage;

  Article({
    required this.title,
    required this.sourceName,
    required this.publishedAt,
    required this.description,
    required this.url,
    this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      sourceName: json['source']['name'] ?? 'Unknown Source',
      publishedAt: json['publishedAt'] ?? '',
      description: json['description'] ?? 'No Description',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
    );
  }
}