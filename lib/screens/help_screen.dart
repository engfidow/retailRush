import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text('Help Center', style: TextStyle(color: Colors.black)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(text: 'FAQ'),
            Tab(text: 'Contact Us'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildFaqList(),
          buildContactUs(),
        ],
      ),
    );
  }

  Widget buildFaqList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        buildFaqItem('Can I track my order\'s delivery status?',
            'Yes, you can track your order\'s delivery status by logging into your account and visiting the "My Orders" section.'),
        buildFaqItem('Is there a return policy?',
            'Yes, we have a 30-day return policy. For more details, visit our return policy page.'),
        buildFaqItem('Can I save my favorite items for later?',
            'Yes, you can save your favorite items by adding them to your wishlist.'),
        buildFaqItem('Can I share products with my friends?',
            'Yes, you can share product links with your friends using the share button on the product page.'),
        buildFaqItem('How do I contact customer support?',
            'You can contact our customer support via the "Contact Us" page or by calling our support number.'),
        buildFaqItem('What payment methods are accepted?',
            'We accept various payment methods including credit cards, debit cards, and PayPal.'),
        buildFaqItem('How to add a review?',
            'You can add a review by visiting the product page and clicking on the "Write a review" button.'),
      ],
    );
  }

  Widget buildFaqItem(String question, String answer) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  Widget buildContactUs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(
              'If you have any questions or need further assistance, please reach out to us through the following channels:'),
          SizedBox(height: 16),
          buildSocialMediaButton(CupertinoIcons.phone, 'Phone Support', () {
            // Add your phone support action here
          }),
          buildSocialMediaButton(CupertinoIcons.mail, 'Email Support', () {
            // Add your email support action here
          }),
          buildSocialMediaButton(CupertinoIcons.chat_bubble_text, 'WhatsApp',
              () {
            // Add your WhatsApp action here
          }),
          buildSocialMediaButton(CupertinoIcons.person_2, 'Facebook', () {
            // Add your Facebook action here
          }),
        ],
      ),
    );
  }

  Widget buildSocialMediaButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: Size(double.infinity, 50),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
