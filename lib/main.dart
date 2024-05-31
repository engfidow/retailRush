import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:ecomerce/providers/user_provider.dart';
import 'package:ecomerce/screens/Sigin_screen.dart';
import 'package:ecomerce/dashboard.dart';
import 'package:ecomerce/providers/Cart.dart';
import 'package:ecomerce/providers/CategoryProvider.dart';
import 'package:ecomerce/providers/HomeProvider.dart';
import 'package:ecomerce/providers/PaymentMethodProvider.dart';
import 'package:ecomerce/providers/ProductProvider.dart';
import 'package:ecomerce/providers/PromotionProvider.dart';
import 'package:ecomerce/providers/WishlistProvider.dart';
import 'package:ecomerce/providers/address_provider.dart';
import 'package:ecomerce/providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => PromotionProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false)
        .loadUserFromStorage());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return userProvider.user != null ? const Dashboard() : const SigIn();
      }),
    );
  }
}
