import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_details_page.dart';
import 'package:ecommerce_own_user_app/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class DistributorProductItem extends StatefulWidget {
  final ProductModel product;
  DistributorProductItem(this.product);

  @override
  _DistributorProductItemState createState() => _DistributorProductItemState();
}

class _DistributorProductItemState extends State<DistributorProductItem> {
  late CartProvider _cartProvider;
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getAllDistributorCartItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = _cartProvider.isInCart(widget.product.id!);

    return InkWell(
      onTap: () => Navigator.pushNamed(
          context, DistributorProductDetailsPage.routeName,
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
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.product.imageDownloadUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SpinKitFadingCircle(
                        color: Colors.greenAccent,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Positioned(
                    //   child: Container(
                    //     width: 60,
                    //     height: 80,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //           bottomRight: Radius.circular(40)),
                    //       color: Colors.grey,
                    //     ),
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 6.0, top: 5),
                    //       child: FittedBox(
                    //         child: Text(
                    //           "${widget.product.offer}",
                    //           style: TextStyle(),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.product.name!,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '$takaSymbol${widget.product.price}',
                style: TextStyle(fontSize: 20.sp, color: Colors.black),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              "${widget.product.offer!}",
              style: TextStyle(
                  backgroundColor: Colors.amberAccent,
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
                              provider.addToDistributorCart(widget.product);
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
