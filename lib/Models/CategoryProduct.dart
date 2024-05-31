import 'package:ecomerce/Models/Category_model.dart';

class ProductCategory {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final double? selprice;
  final DateTime? selpriceDate;
  final Category? category;
  final bool? isTrending;
  final int? unit;
  double rating;
  final List<String>? images;
  bool isFavorite;

  ProductCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.selprice,
    required this.selpriceDate,
    this.category,
    required this.isTrending,
    required this.unit,
    required this.images,
    required this.rating,
    this.isFavorite = false,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    const String baseUrl =
        'https://retailrushserver-production.up.railway.app/';
    return ProductCategory(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      selprice: (json['selprice'] as num).toDouble(),
      selpriceDate: DateTime.parse(json['selpriceDate']),
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      isTrending: json['isTrending'],
      unit: json['unit'],
      rating: (json['rating'] as num).toDouble(),
      images: List<String>.from(json['images'].map((image) {
        // Ensure the base URL is not already included
        return image.startsWith('http') ? image : baseUrl + image;
      })),
    );
  }
  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'price': price,
        'selprice': selprice,
        'selpriceDate': selpriceDate?.toIso8601String(),
        'category': category?.toJson(),
        'isTrending': isTrending,
        'unit': unit,
        'rating': rating,
        'images': images,
        'isFavorite': isFavorite,
      };
}
