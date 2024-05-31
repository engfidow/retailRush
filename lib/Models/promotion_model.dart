// models/promotion.dart
class Promotion {
  final String? id;
  final String name;
  final String description;
  final bool isTrending;
  final String image;
  double discountPercentage;

  Promotion({
    this.id,
    required this.name,
    required this.description,
    required this.isTrending,
    required this.discountPercentage,
    required this.image,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    const String baseUrl =
        'https://retailrushserver-production.up.railway.app/';
    return Promotion(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      isTrending: json['isTrending'],
      image: baseUrl + json['image'],
      discountPercentage: json['discountPercentage'] != null
          ? (json['discountPercentage'] as num).toDouble()
          : 0.0,
    );
  }
}
