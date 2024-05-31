import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecomerce/providers/WishlistProvider.dart';
import 'package:ecomerce/Models/product.dart';
import 'package:ecomerce/screens/product_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconly/iconly.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlist = wishlistProvider.wishlist;

    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        centerTitle: true,
      ),
      body: wishlist.isEmpty
          ? Center(child: Text('No items in wishlist'))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: wishlist.length,
                      itemBuilder: (context, index) {
                        final product = wishlist[index];
                        return ProductTile(product: product);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final productName = product.name!;
    final maxLength = 10; // Set the desired maximum length
    String shortenedName = productName.length > maxLength
        ? productName.substring(0, maxLength) + '...'
        : productName;

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfo(
              id: product.id!,
              images: product.images!,
              name: product.name!,
              rating: product.rating,
              price: product.price!,
              description: product.description!,
              isFavorite: product.isFavorite,
              Categoryname: product.category!.name!,
              unit: product.unit!,
              Categoryid: product.category!.id!,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(
                      wishlistProvider.isInWishlist(product)
                          ? IconlyBold.heart
                          : IconlyLight.heart,
                      color: wishlistProvider.isInWishlist(product)
                          ? Colors.red
                          : Colors.black,
                    ),
                    onPressed: () {
                      if (wishlistProvider.isInWishlist(product)) {
                        wishlistProvider.removeFromWishlist(product);
                      } else {
                        wishlistProvider.addToWishlist(product);
                      }
                    },
                  ),
                ),
                Center(
                  child: CachedNetworkImage(
                    imageUrl: product.images![0],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                shortenedName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Color(0xFFEEA722)),
                  SizedBox(width: 4),
                  Text('${product.rating}'),
                ],
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: Text(
              '\$${product.price}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: Text(
              product.category?.name ?? 'Unknown Category',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
