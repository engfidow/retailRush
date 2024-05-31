import 'package:ecomerce/providers/Cart.dart';
import 'package:ecomerce/providers/PaymentMethodProvider.dart';
import 'package:ecomerce/providers/address_provider.dart';
import 'package:ecomerce/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomerce/providers/order_provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterOrder extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final double totalPrice;

  const RegisterOrder({
    Key? key,
    required this.orderItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<RegisterOrder> createState() => _RegisterOrderState();
}

class _RegisterOrderState extends State<RegisterOrder> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _paymentPhoneController = TextEditingController();
  String _selectedPaymentMethod = "EVC";
  String _userId = "";

  String? _selectedAddress;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final paymentProvider = context.read<PaymentMethodProvider>();
      final addressProvider = context.read<AddressProvider>();

      _userId = userProvider.user?.id ?? "";
      _phoneController.text = paymentProvider.phoneNumber ?? "";
      _paymentPhoneController.text = paymentProvider.phoneNumber ?? "";
      if (addressProvider.addresses.isNotEmpty) {
        _selectedAddress = addressProvider.addresses.first['details'];
        _addressController.text = _selectedAddress ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final double deliveryPrice = 5.00;
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text("Register Order"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Phone Call", _phoneController),
                  SizedBox(height: 10),
                  _buildTextField("Phone Payment", _paymentPhoneController),
                  SizedBox(height: 16),
                  _buildAddressDropdown(addressProvider),
                  SizedBox(height: 16),
                  _buildTextField("Description", _descriptionController),
                  SizedBox(height: 16),
                  _buildPaymentMethodSelector(),
                  SizedBox(height: 16),
                  Text(
                    "Order Items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.orderItems.length,
                    itemBuilder: (context, index) {
                      final orderItem = widget.orderItems[index];
                      final product = orderItem['product'];
                      final productName = product.name ?? 'Unknown Product';
                      final productImages = product.images ?? [''];

                      final maxLength = 20; // Set the desired maximum length
                      String shortenedName = productName.length > maxLength
                          ? productName.substring(0, maxLength) + '...'
                          : productName;

                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl:
                              productImages.isNotEmpty ? productImages[0] : '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(shortenedName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity: ${orderItem['quantity']}'),
                            Text('Price: \$${product.price}'),
                            Text(
                                'Total: \$${(product.price * orderItem['quantity']).toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee'),
                    Text('\$5.00'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${(widget.totalPrice + 5.00).toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (_selectedPaymentMethod == "EVC" &&
                              _phoneController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Phone number is required for EVC payment')),
                            );
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          final orderData = {
                            "user": _userId,
                            "phone": int.parse(_phoneController.text),
                            "address":
                                _selectedAddress ?? _addressController.text,
                            "orderItems": widget.orderItems.map((item) {
                              return {
                                "product": item['product'].id,
                                "quantity": item['quantity']
                              };
                            }).toList(),
                            "Description": _descriptionController.text,
                            "paymentPhone":
                                int.parse(_paymentPhoneController.text),
                            "totalprice": widget.totalPrice,
                            "paymentName": _selectedPaymentMethod,
                            "deliverprice": deliveryPrice
                          };

                          try {
                            await orderProvider.registerOrder(orderData);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Order registered successfully')),
                            );
                            Provider.of<CartProvider>(context, listen: false)
                                .clearCart();
                            Navigator.pop(context);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to register order: $error. Please try again.')),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          'Register Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return FormBuilderTextField(
      name: label,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildAddressDropdown(AddressProvider addressProvider) {
    return FormBuilderDropdown<String>(
      name: "Address",
      decoration: InputDecoration(
        labelText: "Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      initialValue: _selectedAddress,
      items: addressProvider.addresses
          .map((address) => DropdownMenuItem(
                value: address['details'],
                child: Text(address['details'] ?? 'Unknown Address'),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedAddress = value as String?;
        });
      },
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        FormBuilderRadioGroup<String>(
          name: 'payment_method',
          initialValue: _selectedPaymentMethod,
          options: ['EVC', 'CASH']
              .map((method) => FormBuilderFieldOption(
                    value: method,
                    child: Text(method),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value ?? _selectedPaymentMethod;
            });
          },
        ),
      ],
    );
  }
}
