import 'package:ecomerce/Models/order.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconly/iconly.dart';

class TrackOrderScreen extends StatelessWidget {
  final Order order;

  const TrackOrderScreen({required this.order, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: order.orderItems.length,
                itemBuilder: (context, index) {
                  final orderItem = order.orderItems[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    // color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: (orderItem.productImages.isNotEmpty)
                              ? 'https://retailrushserver-production.up.railway.app/${orderItem.productImages[0]}'
                              : 'assets/order.png',
                          width: 150,
                          height: 100,
                          // fit: BoxFit.none,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          orderItem.productName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          'Qty: ${orderItem.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Price: \$${orderItem.productPrice}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expected Delivery Date'),
                Text('03 Sep 2023'), // Example date
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildOrderStatus(
              status: 'Order Placed',
              date: order.createdAt.toLocal().toString(),
              isCompleted: true,
              icon: Icons.receipt,
            ),
            _buildOrderStatus(
              status: 'In Progress',
              date: order.createdAt.toLocal().toString(),
              isCompleted: true,
              icon: Icons.local_shipping,
            ),
            // if (order.status != 'Pending')
            _buildOrderStatus(
              status: 'Delivered',
              date: '..........',
              isCompleted: order.status == 'Delivered',
              icon: IconlyLight.tick_square,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus({
    required String status,
    required String date,
    required bool isCompleted,
    required IconData icon,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.red : Colors.grey,
            ),
            Container(
              height: 40,
              width: 1,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: TextStyle(
                color: isCompleted ? Colors.red : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(date),
          ],
        ),
        const Spacer(),
        Icon(
          icon,
          color: isCompleted ? Colors.red : Colors.grey,
        ),
      ],
    );
  }
}
