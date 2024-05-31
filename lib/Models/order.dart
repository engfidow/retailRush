// models/order.dart
class Order {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final int phone;
  final String address;
  final List<OrderItem> orderItems;
  final String description;
  final int paymentPhone;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.phone,
    required this.address,
    required this.orderItems,
    required this.description,
    required this.paymentPhone,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['user']['_id'],
      userName: json['user']['name'],
      userEmail: json['user']['email'],
      phone: json['phone'],
      address: json['address'],
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      description: json['Description'],
      paymentPhone: json['paymentPhone'],
      totalPrice: json['totalprice'].toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double productPrice;
  final List<String> productImages;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImages,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product']['_id'],
      productName: json['product']['name'],
      productPrice: json['product']['price'].toDouble(),
      productImages: List<String>.from(json['product']['images']),
      quantity: json['quantity'],
    );
  }
}
