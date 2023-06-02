import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/customwidgets/distributor_product_item.dart';
import 'package:ecommerce_own_user_app/customwidgets/product_item.dart';
import 'package:ecommerce_own_user_app/pages/distributor_cart_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_search_page.dart';
import 'package:ecommerce_own_user_app/pages/product_search_page.dart';
import 'package:ecommerce_own_user_app/pages/user_profile_page.dart';
import 'package:ecommerce_own_user_app/providers/cart_provider.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../customwidgets/main_drawer.dart';
import '../providers/product_provider.dart';
import 'cart_page.dart';

class DistributorProductListPage extends StatefulWidget {
  static const String routeName = '/distributor_product_list';

  @override
  _DistributorProductListPageState createState() =>
      _DistributorProductListPageState();
}

class _DistributorProductListPageState
    extends State<DistributorProductListPage> {
  CarouselController buttonCarouselController = CarouselController();
  String? image;
  late ProductProvider _productProvider;
  late CartProvider _cartProvider;
  late UserProvider _userProvider;
  int? cartListLength;
  @override
  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _cartProvider = Provider.of<CartProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _userProvider.getCurrentUser(AuthService.currentUser!.uid);
    _productProvider.getAllDistributorProducts();
    _cartProvider.getAllCartItems();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    cartListLength = _cartProvider.cartList.length;
    _userProvider = Provider.of<UserProvider>(context);
    _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
      if (user != null) {
        image = user.picture;
        setState(() {});
      }
    });
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              )),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "images/primecafelogo.png",
              width: 50,
              height: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Prime Cafe',
              style:
                  TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Badge(
              badgeStyle: BadgeStyle(
                shape: BadgeShape.circle,
              ),
              onTap: () {
                Navigator.pushNamed(context, CartPage.routeName);
              },
              position: BadgePosition.topEnd(top: -10, end: -12),
              badgeAnimation: BadgeAnimation.scale(
                animationDuration: Duration(seconds: 1),
              ),
              badgeContent: Text(
                cartListLength == null ? "" : "$cartListLength",
                style: TextStyle(color: Colors.white),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, DistributorCartPage.routeName);
                },
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                UserProfilePage.routeName,
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 20.r,
              backgroundImage: NetworkImage(image == null ? "" : image!),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, DistributorSearchPage.routeName,
                    arguments: [_productProvider.productList]);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
                elevation: 20,
                child: Container(
                  height: 50.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text("Search"),
                      ],
                    ),
                  )),
                ),
              ),
            ),
            Expanded(
              // flex: 7,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 0.70,
                children: _productProvider.distributorProductList
                    .map((e) => DistributorProductItem(e))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
