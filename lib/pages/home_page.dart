import 'package:ecomerce/providers/HomeProvider.dart';
import 'package:ecomerce/screens/promotionScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecomerce/screens/Products_Screen.dart';
import 'package:ecomerce/screens/Search_screen.dart';
import 'package:ecomerce/screens/category_screen.dart';
import 'package:ecomerce/components/RadioChips.dart';
import 'package:ecomerce/pages/profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF6F7FB),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF4646),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade100,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _showLocationDialog(context, provider);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(IconlyBold.location,
                                          color: Colors.white),
                                      const SizedBox(width: 1),
                                      Text(
                                        provider.currentLocation,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(IconlyLight.arrow_down_2,
                                          color: Colors.white),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.notifications,
                                          color: Colors.white),
                                      onPressed: () {
                                        // Code for notifications button
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.red),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Image.asset('assets/ajusment.png'),
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.15,
                              onPressed: () {
                                // Code for notifications button
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "#SpecialForYou",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PromotionScreen()));
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                // Display promotions
                CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      provider.setCurrentIndex(index);
                    },
                  ),
                  items: provider.promotionList
                      .map((promotion) => ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: promotion.image!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black54
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      promotion.description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                AnimatedSmoothIndicator(
                  activeIndex: provider.currentIndex,
                  count: provider.promotionList.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.red,
                    dotColor: Colors.grey,
                  ),
                ),
                // Category Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoryScreen()));
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: provider.isCategoryLoading
                      ? Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1 / 1.2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1 / 1.2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: provider.categoryList.length > 4
                              ? 4
                              : provider.categoryList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      categoryId:
                                          provider.categoryList[index].id!,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    radius: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://retailrushserver-production.up.railway.app/${provider.categoryList[index].icon}',
                                        placeholder: (context, url) => Center(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    provider.categoryList[index].name!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Flash Sale Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 26.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Flash Sale',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      CountdownTimer(
                        endTime: provider.endTime,
                        widgetBuilder: (_, CurrentRemainingTime? time) {
                          if (time == null) {
                            return const Text('Sale ended!');
                          }
                          return Text(
                            '${time.hours ?? 0} : ${time.min ?? 0} : ${time.sec ?? 0}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioChips(
                    onSelected: (index) {
                      String filter;
                      switch (index) {
                        case 1:
                          filter = 'trendings';
                          break;
                        case 2:
                          filter = 'newests';
                          break;
                        case 3:
                          filter = 'populars';
                          break;
                        default:
                          filter = '';
                      }
                      provider.fetchProducts(filter);
                    },
                    values: provider.menuItems,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: provider.isProductLoading
                      ? Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ProductsGrid(products: provider.productList),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLocationDialog(BuildContext context, HomeProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Location'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Muqdisho');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Muqdisho'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Xudur');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Xudur'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Boosaso');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Boosaso'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Beledweyne');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Beledweyne'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, hargeysa');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, hargeysa'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Jowhar');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Jowhar'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Baydhabo');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Baydhabo'),
            ),
            SimpleDialogOption(
              onPressed: () {
                provider.updateLocation('Somalia, Dhuusamareeb');
                Navigator.of(context).pop();
              },
              child: const Text('Somalia, Dhuusamareeb'),
            ),
          ],
        );
      },
    );
  }
}
