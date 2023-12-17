import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/customwidgets/product_item.dart';
import 'package:ecommerce_own_user_app/pages/product_search_page.dart';
import 'package:ecommerce_own_user_app/pages/user_profile_page.dart';
import 'package:ecommerce_own_user_app/providers/cart_provider.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../customwidgets/main_drawer.dart';
import '../providers/product_provider.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  static const String routeName = '/product_list';

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  CarouselController buttonCarouselController = CarouselController();
  String? image;
  late ProductProvider _productProvider;
  late CartProvider _cartProvider;
  late UserProvider _userProvider;
  int? cartListLength;
  var _dotPosition = 0;
  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _cartProvider = Provider.of<CartProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _userProvider.getCurrentUser(AuthService.currentUser!.uid);
    _productProvider.getAllProducts();
    _productProvider.getCarouselSliderImage();
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
                  Navigator.pushNamed(context, CartPage.routeName);
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
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            expandedHeight: 50.h,
            backgroundColor: Colors.white,
            title: InkWell(
              onTap: () {
                Navigator.pushNamed(context, SearchPage.routeName,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  Container(
                    height: 150.h,
                    width: 400.w,
                    child: CarouselSlider(
                        items: _productProvider.carouselSliderimg
                            .map((item) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  width: 200.w,
                                  height: 200.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: CachedNetworkImage(
                                        imageUrl: item,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            SpinKitFadingCircle(
                                          color: Colors.greenAccent,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (val, carouselPageChangedReason) {
                              setState(() {
                                _dotPosition = val;
                              });
                            })),
                  ),
                  DotsIndicator(
                    dotsCount: _productProvider.carouselSliderimg.length == 0
                        ? 1
                        : _productProvider.carouselSliderimg.length,
                    position: _dotPosition,
                    decorator: DotsDecorator(
                        activeColor: Colors.greenAccent,
                        color: Colors.greenAccent.withOpacity(0.5),
                        spacing: EdgeInsets.all(2),
                        activeSize: Size(8.w, 8.h),
                        size: Size(6.w, 6.h)),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.8,
                    children: _productProvider.productList
                        .map((e) => ProductItem(e))
                        .toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
