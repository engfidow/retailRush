import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:ecomerce/pages/home_page.dart';
import 'package:ecomerce/pages/wishlist_page.dart';
import 'package:ecomerce/pages/cart_page.dart';
import 'package:ecomerce/pages/order_page.dart';
import 'package:ecomerce/pages/profile_page.dart';
import 'connectivity_service.dart';
import 'dart:async';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool _isExitWarning = false;
  Timer? _exitTimer;

  final _iconList = <IconData>[
    IconlyLight.home,
    IconlyLight.heart,
    CupertinoIcons.cart,
    IconlyLight.bag,
    IconlyLight.profile,
  ];
  final _labelList = ['Home', 'Wishlist', 'Cart', 'Orders', 'Profile'];
  final List<Widget> _screens = [
    Home(),
    const Wishlist(),
    const Cart(),
    const MyOrdersPage(),
    const Profile()
  ];

  @override
  void initState() {
    super.initState();
    ConnectivityService(context).checkConnectivity();
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      if (_isExitWarning) {
        return true;
      } else {
        setState(() {
          _isExitWarning = true;
        });
        _exitTimer?.cancel();
        _exitTimer = Timer(Duration(seconds: 2), () {
          setState(() {
            _isExitWarning = false;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Press back again to exit the app'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.075;
    double indicatorSize = MediaQuery.of(context).size.width * 0.04;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: _iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color =
                isActive ? Color.fromARGB(177, 220, 20, 60) : Colors.grey;
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.red : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Icon(_iconList[index], color: color, size: 20),
                  Text(
                    _labelList[index],
                    style: TextStyle(color: color, fontSize: 14),
                  ),
                ],
              ),
            );
          },
          height: 70 + MediaQuery.of(context).size.height * 0.02,
          backgroundColor: Colors.white,
          activeIndex: _selectedIndex,
          splashColor: Colors.red,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.none,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
