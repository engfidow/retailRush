import 'package:ecomerce/screens/GetSeach_DataScreen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecomerce/Models/product.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> searchResults = [];
  bool isLoading = false;

  Future<void> searchProducts(String query) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://retailrushserver-production.up.railway.app/api/products/search?search=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        searchResults = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onSubmitted: searchProducts,
        ),
      ),
      body: isLoading
          ? _buildShimmerEffect()
          : SingleChildScrollView(
              child: Column(
                children: [
                  GetSearchData(products: searchResults),
                ],
              ),
            ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: List.generate(4, (index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildShimmerTile(),
                _buildShimmerTile(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            height: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            height: 20,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            height: 20,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
