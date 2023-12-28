import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_own_user_app/pages/product_details_page.dart';
import 'package:ecommerce_own_user_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class ProductItem extends StatefulWidget {
  final ProductModel product;
  ProductItem(this.product);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late CartProvider _cartProvider;
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getAllCartItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = _cartProvider.isInCart(widget.product.id!);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,
          arguments: [
            widget.product.id,
            widget.product.name,
            widget.product,
          ]),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 7,
        child: Column(
          children: [
            widget.product.imageDownloadUrl == null
                ? Expanded(
                    child: Image.asset(
                    'images/wait.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ))
                : Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageDownloadUrl!,
                        width: double.infinity,
                        height: 250.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: Colors.greenAccent,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),

                      // FadeInImage.assetNetwork(
                      //   image: widget.product.imageDownloadUrl!,
                      //   placeholder: 'images/wait.jpg',
                      //   width: double.infinity,
                      //   fadeInDuration: const Duration(seconds: 3),
                      //   fadeInCurve: Curves.bounceInOut,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
            FittedBox(
              fit: BoxFit.contain,
              child: Row(
                children: [
                  Text(
                    widget.product.name!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: themeProvider.themeModeType == ThemeModeType.Dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 7)),
                  Text(
                    '$takaSymbol${widget.product.price}',
                    style: TextStyle(
                        fontSize: 19.sp,
                        color: themeProvider.themeModeType == ThemeModeType.Dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Text(
            //     widget.product.name!,
            //     style: TextStyle(fontSize: 16.sp, color: Colors.black),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Text(
            //     '$takaSymbol${widget.product.price}',
            //     style: TextStyle(fontSize: 20.sp, color: Colors.black),
            //   ),
            // ),
            Text(
              textAlign: TextAlign.center,
              "${widget.product.offer!}",
              style: TextStyle(
                  color: Colors.redAccent.shade100,
                  // backgroundColor: Colors.amberAccent,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold),
            ),
            Consumer<CartProvider>(
              builder: (context, provider, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: cart == true
                          ? () {
                              provider.removeFromCart(widget.product.id!);
                            }
                          : null,
                      icon: Icon(
                        cart ? Icons.remove : null,
                        color: Colors.redAccent,
                      )),
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.brown,
                  ),
                  IconButton(
                      onPressed: cart == false
                          ? () {
                              provider.addToCart(widget.product);
                            }
                          : null,
                      icon: Icon(
                        cart ? null : Icons.add,
                        color: Colors.green,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
