import 'package:ecomerce/Models/order.dart';
import 'package:ecomerce/providers/order_provider.dart';
import 'package:ecomerce/providers/user_provider.dart';
import 'package:ecomerce/screens/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.fetchOrdersByUserId(userProvider.user?.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Color(0xFFF6F7FB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text('My Orders'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Active'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
              ),
            ),
            body: provider.isLoading
                ? const OrdersShimmer()
                : provider.hasError
                    ? Center(child: Text('Failed to load orders'))
                    : TabBarView(
                        children: [
                          OrdersList(
                              orders: provider.orders
                                  .where((order) => order.status == 'Pending')
                                  .toList(),
                              isActive: true),
                          OrdersList(
                              orders: provider.orders
                                  .where((order) => order.status == 'Completed')
                                  .toList(),
                              isActive: false),
                          OrdersList(
                              orders: provider.orders
                                  .where((order) => order.status == 'Cancelled')
                                  .toList(),
                              isActive: false),
                        ],
                      ),
          ),
        );
      },
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<Order> orders;
  final bool isActive;

  OrdersList({required this.orders, required this.isActive});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(child: Text('No data found'));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/order.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(order.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                      Text('Status: ${order.status}'),
                    ],
                  ),
                ),
                if (isActive)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TrackOrderScreen(order: order),
                          ),
                        );
                      },
                      child: Text(
                        'Track Order',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        textStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrdersShimmer extends StatelessWidget {
  const OrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                    ),
                    title: Container(
                      width: double.infinity,
                      height: 10,
                      color: Colors.white,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 80,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
