import 'package:ecommerce_own_user_app/pages/cart_page.dart';
import 'package:ecommerce_own_user_app/pages/checkout_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_cart_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_order_details_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_order_list_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_details_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_list.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_search_page.dart';
import 'package:ecommerce_own_user_app/pages/email_verification_page.dart';
import 'package:ecommerce_own_user_app/pages/launcher_page.dart';
import 'package:ecommerce_own_user_app/pages/login_page.dart';
import 'package:ecommerce_own_user_app/pages/order_details_page.dart';
import 'package:ecommerce_own_user_app/pages/order_successful_page.dart';
import 'package:ecommerce_own_user_app/pages/product_details_page.dart';
import 'package:ecommerce_own_user_app/pages/product_list_page.dart';
import 'package:ecommerce_own_user_app/pages/product_search_page.dart';
import 'package:ecommerce_own_user_app/pages/sslcommerz_page.dart';
import 'package:ecommerce_own_user_app/pages/user_order_list_page.dart';
import 'package:ecommerce_own_user_app/pages/user_profile_page.dart';
import 'package:ecommerce_own_user_app/pages/user_profile_update.dart';
import 'package:ecommerce_own_user_app/providers/cart_provider.dart';
import 'package:ecommerce_own_user_app/providers/order_provider.dart';
import 'package:ecommerce_own_user_app/providers/product_provider.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => CartProvider()),
    ChangeNotifierProvider(create: (context) => OrderProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(415, 860),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              textTheme: GoogleFonts.robotoTextTheme(),
              primarySwatch: Colors.blue,
            ),
            home: LauncherPage(),
            routes: {
              LauncherPage.routeName: (context) => LauncherPage(),
              LoginPage.routeName: (context) => LoginPage(),
              ProductListPage.routeName: (context) => ProductListPage(),
              ProductDetailsPage.routeName: (context) => ProductDetailsPage(),
              UserProfilePage.routeName: (context) => UserProfilePage(),
              CartPage.routeName: (context) => CartPage(),
              CheckoutPage.routeName: (context) => CheckoutPage(),
              OrderSuccessfulPage.routeName: (context) => OrderSuccessfulPage(),
              UserOrderListPage.routeName: (context) => UserOrderListPage(),
              OrderDetailsPage.routeName: (context) => OrderDetailsPage(),
              UserProfileUpdatePage.routeName: (context) =>
                  UserProfileUpdatePage(),
              SearchPage.routeName: (context) => SearchPage(),
              EmailVerificationScreen.routeName: (context) =>
                  EmailVerificationScreen(),
              DistributorProductListPage.routeName: (context) =>
                  DistributorProductListPage(),
              DistributorCartPage.routeName: (context) => DistributorCartPage(),
              DistributorOrderDetailsPage.routeName: (context) =>
                  DistributorOrderDetailsPage(),
              DistributorOrderListPage.routeName: (context) =>
                  DistributorOrderListPage(),
              DistributorSearchPage.routeName: (context) =>
                  DistributorSearchPage(),
              DistributorProductDetailsPage.routeName: (context) =>
                  DistributorProductDetailsPage(),
              SSLCommerzPage.routeName: (context) => SSLCommerzPage(),
            },
          );
        });
  }
}
