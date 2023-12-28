import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_own_user_app/providers/theme_provider.dart';
import 'package:ecommerce_own_user_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class OrderDetailsPage extends StatefulWidget {
  static const String routeName = '/order_details';

  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String? orderId;
  late OrderProvider _orderProvider;
  @override
  void didChangeDependencies() {
    orderId = ModalRoute.of(context)!.settings.arguments as String;
    _orderProvider = Provider.of<OrderProvider>(context);
    _orderProvider.getOrderDetails(orderId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Details'),
      ),
      body: ListView.builder(
        itemCount: _orderProvider.orderDetailsList.length,
        itemBuilder: (context, index) {
          final details = _orderProvider.orderDetailsList[index];
          return Card(
              child: Container(
            margin: EdgeInsets.only(bottom: 5.h, right: 5.w, left: 5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: themeProvider.themeModeType == ThemeModeType.Dark
                  ? Colors.white38
                  : Colors.black12,
            ),
            height: 90.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: CachedNetworkImage(
                    imageUrl: "${details.imageDownloadUrl}",
                    height: 90.h,
                    width: 80.w,
                    placeholder: (context, url) => SpinKitFadingCircle(
                      color: Colors.greenAccent,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.productName,
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    Text(
                      '$takaSymbol${details.price}',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${details.qty}x${details.price}'),
                  ],
                ),
              ],
            ),
          )

              // ListTile(
              //
              //   title: Text(details.productName),
              //   trailing: Text('${details.qty}x${details.price}'),
              // ),
              );
        },
      ),
    );
  }
}
