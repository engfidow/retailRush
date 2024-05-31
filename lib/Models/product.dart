import 'package:ecomerce/Models/Category_model.dart';

class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  double? selprice;
  DateTime? selpriceDate;
  Category? category;
  bool? isTrending;
  int? unit;
  double rating;
  List<String>? images;
  bool isFavorite;
  double discountPercentage;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.selprice,
    this.selpriceDate,
    this.category,
    this.isTrending = false,
    this.unit,
    this.images,
    this.rating = 0.0,
    this.isFavorite = false,
    this.discountPercentage = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    const String baseUrl =
        'https://retailrushserver-production.up.railway.app/';
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
      selprice:
          json['selprice'] != null ? (json['selprice'] as num).toDouble() : 0.0,
      selpriceDate: json['selpriceDate'] != null
          ? DateTime.parse(json['selpriceDate'])
          : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      isTrending: json['isTrending'] ?? false,
      unit: json['unit'] ?? 0,
      rating: (json['rating'] as num).toDouble(),
      images: json['images'] != null
          ? List<String>.from(json['images'].map((image) {
              return image.startsWith('http') ? image : baseUrl + image;
            }))
          : [],
      discountPercentage: json['discountPercentage'] != null
          ? (json['discountPercentage'] as num).toDouble()
          : 0.0,
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
        'discountPercentage': discountPercentage,
      };

  void clear() {
    id = null;
    name = null;
    description = null;
    price = null;
    selprice = null;
    selpriceDate = null;
    category = null;
    isTrending = false;
    unit = 0;
    rating = 0.0;
    images?.clear();
    isFavorite = false;
    discountPercentage = 0.0;
  }
}
