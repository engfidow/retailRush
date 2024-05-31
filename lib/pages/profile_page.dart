import 'package:ecomerce/providers/Cart.dart';
import 'package:ecomerce/providers/PaymentMethodProvider.dart';
import 'package:ecomerce/providers/WishlistProvider.dart';
import 'package:ecomerce/providers/address_provider.dart';
import 'package:ecomerce/providers/user_provider.dart';
import 'package:ecomerce/screens/Sigin_screen.dart';
import 'package:ecomerce/screens/address_management_screen.dart';
import 'package:ecomerce/screens/help_screen.dart';
import 'package:ecomerce/screens/paymentMethod_screen.dart';
import 'package:ecomerce/screens/settings_screen.dart';
import 'package:ecomerce/screens/update_profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _onProfileTap() {
    // Handle profile tap
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UpdateProfile()));
  }

  void _onManageAddressTap() {
    // Handle manage address tap
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddressManagementScreen()));
  }

  void _onPaymentMethodsTap() {
    // Handle payment methods tap
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaymentMethod()));
  }

  void _onSettingsTap() {
    // Handle settings tap
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsScreen()));
  }

  void _onHelpCenterTap() {
    // Handle help center tap
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HelpScreen()));
  }

  void _onLogOutTap() {
    Provider.of<UserProvider>(context, listen: false).logout();
    Provider.of<CartProvider>(context, listen: false).clearCart();
    Provider.of<WishlistProvider>(context, listen: false).clearWishList();
    Provider.of<PaymentMethodProvider>(context, listen: false).clearPhone();
    Provider.of<AddressProvider>(context, listen: false).clearAdddress();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (e) => const SigIn(),
      ),
    );
  }

  bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  void _showProfilePhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                  'https://retailrushserver-production.up.railway.app/$imageUrl'),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                var kEndpoint =
                    "https://retailrushserver-production.up.railway.app/";
                String imageUrl =
                    userProvider.user?.image ?? 'default_image_url';

                return GestureDetector(
                  onTap: () => _showProfilePhoto(context, imageUrl),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                        'https://retailrushserver-production.up.railway.app/$imageUrl'),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Text(
                  userProvider.user?.name ?? 'Guest',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildListTile(IconlyLight.user, 'Your profile', _onProfileTap),
            _buildListTile(
                IconlyLight.location, 'Manage Address', _onManageAddressTap),
            _buildListTile(Icons.payment_outlined, 'Payment Methods',
                _onPaymentMethodsTap),
            _buildListTile(IconlyLight.setting, 'Settings', _onSettingsTap),
            _buildListTile(Icons.help_outline, 'Help Center', _onHelpCenterTap),
            _buildListTile(IconlyLight.logout, 'LogOut', _onLogOutTap),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.red,
        ),
        title: Text(title),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.red,
        ),
        onTap: onTap,
      ),
    );
  }
}
