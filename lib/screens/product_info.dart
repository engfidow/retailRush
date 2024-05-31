import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecomerce/Models/product.dart';
import 'package:ecomerce/providers/Cart.dart';
import 'package:ecomerce/providers/ProductProvider.dart';
import 'package:ecomerce/providers/WishlistProvider.dart';
import 'package:ecomerce/screens/Products_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  final String id;
  final List<String> images;
  final String name;
  final double rating;
  final double price;
  final String description;
  final String Categoryname;
  final String Categoryid;
  final int unit;
  bool isFavorite;

  ProductInfo({
    super.key,
    required this.id,
    required this.images,
    required this.name,
    required this.rating,
    required this.price,
    required this.description,
    this.isFavorite = false,
    required this.Categoryname,
    required this.unit,
    required this.Categoryid,
  });

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts(widget.Categoryid);
    });
  }

  void _openGallery(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: widget.images,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final similarProducts = Provider.of<ProductProvider>(context).productList;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Color(0xFFEEEFEE),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50.0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: IconButton(
                                  icon: Icon(IconlyLight.arrow_left),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Text(
                                'Product Details',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    wishlistProvider.isInWishlist(Product(
                                      id: widget.id,
                                      name: widget.name,
                                      price: widget.price,
                                      images: widget.images,
                                      rating: widget.rating,
                                      description: widget.description,
                                      isFavorite: widget.isFavorite,
                                      unit: widget.unit,
                                      category: null,
                                    ))
                                        ? IconlyBold.heart
                                        : IconlyLight.heart,
                                  ),
                                  color: wishlistProvider.isInWishlist(Product(
                                    id: widget.id,
                                    name: widget.name,
                                    price: widget.price,
                                    images: widget.images,
                                    rating: widget.rating,
                                    description: widget.description,
                                    isFavorite: widget.isFavorite,
                                    unit: widget.unit,
                                    category: null,
                                  ))
                                      ? Colors.red
                                      : Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      if (wishlistProvider.isInWishlist(Product(
                                        id: widget.id,
                                        name: widget.name,
                                        price: widget.price,
                                        images: widget.images,
                                        rating: widget.rating,
                                        description: widget.description,
                                        isFavorite: widget.isFavorite,
                                        unit: widget.unit,
                                        category: null,
                                      ))) {
                                        wishlistProvider
                                            .removeFromWishlist(Product(
                                          id: widget.id,
                                          name: widget.name,
                                          price: widget.price,
                                          images: widget.images,
                                          rating: widget.rating,
                                          description: widget.description,
                                          isFavorite: widget.isFavorite,
                                          unit: widget.unit,
                                          category: null,
                                        ));
                                      } else {
                                        wishlistProvider.addToWishlist(Product(
                                          id: widget.id,
                                          name: widget.name,
                                          price: widget.price,
                                          images: widget.images,
                                          rating: widget.rating,
                                          description: widget.description,
                                          isFavorite: widget.isFavorite,
                                          unit: widget.unit,
                                          category: null,
                                        ));
                                      }
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _openGallery(context, _selectedImageIndex);
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.images[_selectedImageIndex],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.images.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImageIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.images[index],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${widget.Categoryname}'),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.amber,
                                ),
                                Text('${widget.rating}'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Product Details",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.description,
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Similar Products",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        similarProducts.isNotEmpty
                            ? ProductsGrid(
                                products: similarProducts,
                              )
                            : Text("No similar products found"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: Offset(0, 6), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${widget.price}',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    var Categoryname = widget.Categoryname;
                    final product = Product(
                      id: widget.id,
                      name: widget.name,
                      price: widget.price,
                      images: widget.images,
                      rating: widget.rating,
                      description: widget.description,
                      isFavorite: widget.isFavorite,
                      unit: widget.unit,
                      category: null,
                    );
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added To Cart'),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.cart, color: Colors.white),
                      SizedBox(width: 20),
                      Text(
                        'Add To Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatelessWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> galleryItems;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: _buildItem,
        itemCount: galleryItems.length,
        loadingBuilder: loadingBuilder,
        backgroundDecoration: backgroundDecoration,
        pageController: pageController,
        scrollDirection: scrollDirection,
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(item),
      minScale: minScale,
      maxScale: maxScale,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
