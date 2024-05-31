import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:ecomerce/providers/address_provider.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  _AddressManagementScreenState createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Shipping Address", style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: addressProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = addressProvider.addresses[index];
                    return Column(
                      children: [
                        Dismissible(
                          key: Key(address['title'] ?? ''),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            addressProvider.deleteAddress(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('${address['title']} deleted')),
                            );
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.location_on, color: Colors.red),
                            title: Text(address['title'] ?? ''),
                            subtitle: Text(address['details'] ?? ''),
                            trailing: IconButton(
                              color: Colors.black,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red,
                                // padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                              icon: Icon(
                                IconlyLight.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showAddressDialog(
                                    context, addressProvider, index);
                              },
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey.shade300),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    _showAddressDialog(context, addressProvider);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Text(
                      "+ Add New Shipping Address",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddressDialog(BuildContext context, AddressProvider addressProvider,
      [int? index]) {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();

    if (index != null) {
      final address = addressProvider.addresses[index];
      titleController.text = address['title'] ?? '';
      detailsController.text = address['details'] ?? '';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Add Address' : 'Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: detailsController,
                decoration: InputDecoration(labelText: 'Details'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final address = {
                  'title': titleController.text,
                  'details': detailsController.text,
                };
                if (index == null) {
                  addressProvider.addAddress(address);
                } else {
                  addressProvider.editAddress(index, address);
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
