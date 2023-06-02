import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_own_user_app/providers/cart_provider.dart';
import 'package:ecommerce_own_user_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class DistributorProductDetailsPage extends StatefulWidget {
  static const String routeName = '/distributor_product_details';
  @override
  _DistributorProductDetailsPageState createState() =>
      _DistributorProductDetailsPageState();
}

class _DistributorProductDetailsPageState
    extends State<DistributorProductDetailsPage> {
  late CartProvider _cartProvider;
  late ProductProvider _productProvider;
  String? _productId;
  String? _productName;
  ProductModel? _productmo;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _productProvider.distributorProductList;
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    _productId = argList[0];
    _productName = argList[1];
    _productmo = argList[2];
    _cartProvider = Provider.of<CartProvider>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = _cartProvider.isInDistributorCart(_productId!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade200,
        title: Text(_productName!),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _productProvider
                    .getDistributorProductByProductId(_productId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final product =
                        ProductModel.fromMap(snapshot.data!.data()!);
                    return ListView(
                      children: [
                        product.imageDownloadUrl == null
                            ? Image.asset(
                                'images/imagenotavailable.png',
                                width: double.infinity,
                                height: 250.h,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: product.imageDownloadUrl!,
                                width: double.infinity,
                                height: 250.h,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    SpinKitFadingCircle(
                                  color: Colors.greenAccent,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),

                        // FadeInImage.assetNetwork(
                        //         image: product.imageDownloadUrl!,
                        //         placeholder: 'images/wait.png',
                        //         width: double.infinity,
                        //         fadeInDuration: const Duration(seconds: 3),
                        //         fadeInCurve: Curves.bounceInOut,
                        //         height: 250.h,
                        //         fit: BoxFit.cover,
                        //       ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border:
                                  Border.all(color: Colors.grey, width: 2.w)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Price'),
                              Text(
                                '$takaSymbol ${product.price}',
                                style: TextStyle(fontSize: 20.sp),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          ' ${product.description}',
                        )
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text('Failed to fetch data');
                  }
                  return SpinKitThreeBounce(
                    color: Colors.greenAccent,
                  );
                },
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.withOpacity(0.6)),
            label: Text(cart == false ? "Add" : "Remove"),
            onPressed: () {
              if (cart == false) {
                _cartProvider.addToDistributorCart(_productmo!);
              } else {
                _cartProvider.removeFromCart(_productId!);
              }
            },
            icon: Icon(cart == false
                ? Icons.add_shopping_cart
                : Icons.remove_shopping_cart),
          ),
        ],
      ),
    );
  }
}
