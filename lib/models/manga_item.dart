class MangaItem {
  final int id;
  final String imagePath;
  final String title;
  final String description;
  final String price;
  final List<String> additionalImages;
  final String format;
  final String publisher;
  final String shortDescription;
  final String chapters;

  MangaItem({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.price,
    required this.additionalImages,
    required this.format,
    required this.publisher,
    required this.shortDescription,
    required this.chapters,
  });

  factory MangaItem.fromJson(Map<String, dynamic> json) {
    return MangaItem(
      id: json['id'],
      imagePath: _ensureImageFormat(json['imagePath'] ?? ''),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      additionalImages: List<String>.from(json['additionalImages']?.map((image) => _ensureImageFormat(image)) ?? []),
      format: json['format'] ?? '',
      publisher: json['publisher'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      chapters: json['chapters'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'price': price,
      'additionalImages': additionalImages,
      'format': format,
      'publisher': publisher,
      'shortDescription': shortDescription,
      'chapters': chapters,
    };
  }

  static String _ensureImageFormat(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (!imagePath.endsWith('.jpg') && !imagePath.endsWith('.png')) {
      return '$imagePath.jpg'; // Добавляем формат изображения по умолчанию
    }
    return imagePath;
  }
}