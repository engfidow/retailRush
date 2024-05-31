import 'package:ecomerce/providers/PaymentMethodProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final TextEditingController _evcPhoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPhoneNumber();
    });
  }

  Future<void> _loadPhoneNumber() async {
    await context.read<PaymentMethodProvider>().loadPhoneNumber();
    if (context.read<PaymentMethodProvider>().phoneNumber != null) {
      _evcPhoneController.text =
          context.read<PaymentMethodProvider>().phoneNumber!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethodProvider = Provider.of<PaymentMethodProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text("Payment Methods"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentMethodCard(
                context,
                'EVC',
                'assets/EVC-PLUS.png', // Add your EVC logo image asset
                _buildEvcPaymentContent(paymentMethodProvider),
              ),
              SizedBox(height: 20),
              _buildPaymentMethodCard(
                context,
                'Cash',
                'assets/cash_logo.png', // Add your Cash logo image asset
                Container(), // No additional content for Cash
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
      BuildContext context, String title, String imagePath, Widget content) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildEvcPaymentContent(PaymentMethodProvider paymentMethodProvider) {
    if (paymentMethodProvider.phoneNumber != null && !_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                paymentMethodProvider.phoneNumber!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
                _evcPhoneController.text = paymentMethodProvider.phoneNumber!;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Background color
              padding:
                  EdgeInsets.symmetric(horizontal: 60, vertical: 10), // Padding
            ),
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _evcPhoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixText: '+252 ',
              hintText: 'Enter your phone number',
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (_evcPhoneController.text.isNotEmpty) {
                await paymentMethodProvider
                    .savePhoneNumber(_evcPhoneController.text);
                setState(() {
                  _isEditing = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Background color
              padding:
                  EdgeInsets.symmetric(horizontal: 60, vertical: 10), // Padding
            ),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }
  }
}
