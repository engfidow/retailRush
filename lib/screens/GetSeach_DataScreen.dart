import 'package:flutter/material.dart';
import 'package:ecomerce/Models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:iconly/iconly.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ecomerce/providers/Cart.dart';
import 'package:ecomerce/screens/product_info.dart';
import 'package:shimmer/shimmer.dart';

class GetSearchData extends StatelessWidget {
  final List<Product> products;

  GetSearchData({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(child: Text('No results found'));
    }

    int rowCount = (products.length + 1) ~/ 2;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: List.generate(rowCount, (index) {
          int productIndex = index * 2;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ProductTile(product: products[productIndex]),
              if (productIndex + 1 < products.length)
                ProductTile(product: products[productIndex + 1]),
            ],
          );
        }),
      ),
    );
  }
}

class ProductTile extends StatefulWidget {
  final Product product;

  ProductTile({required this.product});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    final productName = widget.product.name!;
    final maxLength = 10;
    String shortenedName = productName.length > maxLength
        ? productName.substring(0, maxLength) + '...'
        : productName;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductInfo(
                id: widget.product.id!,
                images: widget.product.images!,
                name: widget.product.name!,
                rating: widget.product.rating,
                price: widget.product.price!,
                description: widget.product.description!,
                isFavorite: widget.product.isFavorite,
                Categoryname: widget.product.category!.name!,
                unit: widget.product.unit!,
                Categoryid: widget.product.category!.id!,
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
                        widget.product.isFavorite
                            ? IconlyBold.heart
                            : IconlyLight.heart,
                        color: widget.product.isFavorite
                            ? Colors.red
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.product.isFavorite =
                              !widget.product.isFavorite;
                          if (widget.product.isFavorite) {
                            cartProvider.addToCart(widget.product);
                          } else {
                            cartProvider.removeFromCart(widget.product);
                          }
                          _saveFavoriteStatus(
                              widget.product.id!, widget.product.isFavorite);
                        });
                      },
                    ),
                  ),
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.product.images![0],
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
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
                    Text('${widget.product.rating}'),
                  ],
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Text(
                '\$${widget.product.price}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Text(
                widget.product.category?.name ?? 'Unknown Category',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _saveFavoriteStatus(String productId, bool isFavorite) {
    final GetStorage storage = GetStorage();
    List<dynamic> favoriteStatusList = storage.read('favorites') ?? [];
    final index =
        favoriteStatusList.indexWhere((item) => item['productId'] == productId);
    if (index != -1) {
      favoriteStatusList[index]['isFavorite'] = isFavorite;
    } else {
      favoriteStatusList
          .add({'productId': productId, 'isFavorite': isFavorite});
    }
    storage.write('favorites', favoriteStatusList);
  }
}
