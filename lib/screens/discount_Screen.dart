import 'package:ecomerce/Models/product.dart';
import 'package:ecomerce/Models/promotion_model.dart';
import 'package:ecomerce/providers/ProductProvider.dart';
import 'package:ecomerce/providers/WishlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:ecomerce/screens/product_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class DiscountScreen extends StatefulWidget {
  final Promotion promotion;

  const DiscountScreen({required this.promotion, Key? key}) : super(key: key);

  @override
  _DiscountScreenState createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  Future<List<Product>>? _discountedProductsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      setState(() {
        _discountedProductsFuture = _fetchDiscountedProducts(productProvider);
      });
    });
  }

  Future<List<Product>> _fetchDiscountedProducts(
      ProductProvider productProvider) async {
    await productProvider.fetchAllProducts();
    return productProvider.productList.where((product) {
      return product.discountPercentage == widget.promotion.discountPercentage;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.promotion.name),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: _discountedProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No discounted products found'));
          } else {
            return ProductsGrid(products: snapshot.data!);
          }
        },
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

class ProductsGrid extends StatelessWidget {
  final List<Product> products;

  ProductsGrid({required this.products});

  @override
  Widget build(BuildContext context) {
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
    final maxLength = 10; // Set the desired maximum length
    String shortenedName = productName.length > maxLength
        ? productName.substring(0, maxLength) + '...'
        : productName;

    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);

    double discount =
        (widget.product.discountPercentage / 100) * (widget.product.price ?? 0);
    double discountedPrice = (widget.product.price ?? 0) - discount;

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
                price: discountedPrice,
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
                            wishlistProvider.addToWishlist(widget.product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added To Wishlist'),
                              ),
                            );
                          } else {
                            wishlistProvider.removeFromWishlist(widget.product);
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
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: Text(
                '\$${widget.product.price}',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
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
