// screens/cart_screen.dart
import 'package:ecomerce/providers/Cart.dart';
import 'package:ecomerce/screens/register_order_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cached_network_image/cached_network_image.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('My Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.items[index];
                final product = cartItem.product;
                final productName = product.name ?? 'Unknown Product';
                final productId = product.id ?? 'Unknown ID';
                final productImages = product.images ?? [''];

                final maxLength = 10; // Set the desired maximum length
                String shortenedName = productName.length > maxLength
                    ? productName.substring(0, maxLength) + '...'
                    : productName;

                return Dismissible(
                  key: Key(productId),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cartProvider.removeFromCart(product);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(15),
                    elevation: 0,
                    color: Colors.white,
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            productImages.isNotEmpty ? productImages[0] : '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(shortenedName),
                      subtitle:
                          Text('\$${product.price} x ${cartItem.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                cartProvider.updateQuantity(
                                    product, cartItem.quantity - 1);
                              }
                            },
                          ),
                          Text(cartItem.quantity.toString()),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            color: Colors.black,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red,
                              // padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (cartItem.quantity < (product.unit ?? 0)) {
                                cartProvider.updateQuantity(
                                    product, cartItem.quantity + 1);
                              } else {
                                // Show error if exceeding the available stock
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Cannot add more than available stock'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 2,
                  // offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sub-Total'),
                    Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee'),
                    Text('\$5.00'),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('Discount'),
                //     Text('-\$35.00'),
                //   ],
                // ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Cost',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${(cartProvider.totalAmount + 5.00).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterOrder(
                          orderItems: cartProvider.items.map((item) {
                            return {
                              "product": item.product,
                              "quantity": item.quantity,
                            };
                          }).toList(),
                          totalPrice: cartProvider.totalAmount + 5.00,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
