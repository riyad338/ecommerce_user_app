import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_own_user_app/pages/product_list_page.dart';
import 'package:ecommerce_own_user_app/pages/sslcommerz_page.dart';
import 'package:ecommerce_own_user_app/providers/theme_provider.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/order_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';
import 'order_successful_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum SdkType { TESTBOX, LIVE }

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final formkey = GlobalKey<FormState>();
  late CartProvider _cartProvider;
  late OrderProvider _orderProvider;
  late UserProvider _userProvider;
  String radioGroupValue = Payment.cod;
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _cartProvider = Provider.of<CartProvider>(context);
      _orderProvider = Provider.of<OrderProvider>(context);
      _userProvider = Provider.of<UserProvider>(context);
      _orderProvider.getOrderConstants();
      _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
        if (user != null) {
          if (user.deliveryAddress != null) {
            setState(() {
              _addressController.text = user.deliveryAddress!;
            });
          }
        }
      });
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Checkout'),
      ),
      body: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    'Your Items',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Divider(
                    height: 1.h,
                    color: Colors.black,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _cartProvider.cartList
                        .map((cartModel) => ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: "${cartModel.imageDownloadUrl}",
                                height: 50,
                                width: 50,
                                placeholder: (context, url) =>
                                    SpinKitFadingCircle(
                                  color: Colors.greenAccent,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              title: Text(cartModel.productName),
                              trailing:
                                  Text('${cartModel.qty}x${cartModel.price}'),
                            ))
                        .toList(),
                  ),
                  Text(
                    'Order Summery',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Divider(
                    height: 1.h,
                    color: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Cart Total'),
                          Text(
                            '$takaSymbol${_cartProvider.cartItemsTotalPrice}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeModeType ==
                                      ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charge'),
                          Text(
                            '$takaSymbol${_orderProvider.orderConstantsModel.deliveryCharge}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeModeType ==
                                      ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Discount(${_orderProvider.orderConstantsModel.discount}%)'),
                          Text(
                            '-$takaSymbol${_orderProvider.getDiscountAmount(_cartProvider.cartItemsTotalPrice)}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeModeType ==
                                      ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'VAT(${_orderProvider.orderConstantsModel.vat}%)'),
                          Text(
                            '$takaSymbol${_orderProvider.getTotalVatAmount(_cartProvider.cartItemsTotalPrice)}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeModeType ==
                                      ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        height: 1.h,
                        color: themeProvider.themeModeType == ThemeModeType.Dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$takaSymbol${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeModeType ==
                                      ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                  Text(
                    'Receiver Name',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Name");
                        }
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Text(
                    'Receiver Phone Number',
                    style: TextStyle(fontSize: 20..sp),
                  ),
                  Divider(
                    height: 1.h,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{11,}$');
                        if (value!.isEmpty) {
                          return ("Please Enter Phone Number");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Number(Minmum 11 Number)");
                        }
                      },
                    ),
                  ),
                  Text(
                    'Set Delivery Address',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Divider(
                    height: 1.h,
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Address can not be Empty");
                        }
                      },
                      controller: _addressController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Divider(
                    height: 1.h,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        groupValue: radioGroupValue,
                        value: Payment.cod,
                        onChanged: (value) {
                          setState(() {
                            radioGroupValue = value!;
                          });
                        },
                      ),
                      Text(Payment.cod)
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        groupValue: radioGroupValue,
                        value: Payment.online,
                        onChanged: (value) {
                          setState(() {
                            radioGroupValue = value!;
                          });
                        },
                      ),
                      const Text(Payment.online)
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  child: const Text('PLACE ORDER'),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      if (radioGroupValue == Payment.online) {
                        Navigator.pushNamed(context, SSLCommerzPage.routeName,
                            arguments: [
                              double.parse(
                                  '${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}'),
                              _nameController.text,
                              _addressController.text,
                              AuthService.currentUser!.uid,
                              _phoneController.text,
                            ]);
                      } else {
                        _showDialog(context);
                      }
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _saveOrder() {
    _userProvider.updateDeliveryAddress(
        AuthService.currentUser!.uid, _addressController.text);
    final orderModel = OrderModel(
      userId: AuthService.currentUser!.uid,
      timestamp: Timestamp.now(),
      orderStatus: OrderStatus.pending,
      paymentMethod: radioGroupValue,
      discount: _orderProvider.orderConstantsModel.discount,
      deliveryCharge: _orderProvider.orderConstantsModel.deliveryCharge,
      vat: _orderProvider.orderConstantsModel.vat,
      deliveryAddress: _addressController.text,
      deliveryName: _nameController.text,
      deliveryPhone: _phoneController.text,
      grandTotal:
          _orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice),
    );
    _orderProvider
        .addNewOrder(orderModel, _cartProvider.cartList)
        .then((value) {
      _cartProvider.clearCart();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccessfulPage()),
          ModalRoute.withName(ProductListPage.routeName));
    });
  }

  void _saveDistributorOrder() {
    _userProvider.updateDeliveryAddress(
        AuthService.currentUser!.uid, _addressController.text);
    final orderModel = OrderModel(
      userId: AuthService.currentUser!.uid,
      timestamp: Timestamp.now(),
      orderStatus: OrderStatus.pending,
      paymentMethod: radioGroupValue,
      discount: _orderProvider.orderConstantsModel.discount,
      deliveryCharge: _orderProvider.orderConstantsModel.deliveryCharge,
      vat: _orderProvider.orderConstantsModel.vat,
      deliveryAddress: _addressController.text,
      deliveryName: _nameController.text,
      deliveryPhone: _phoneController.text,
      grandTotal:
          _orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice),
    );
    _orderProvider
        .addDistributorNewOrder(orderModel, _cartProvider.cartList)
        .then((value) {
      _cartProvider.clearCart();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccessfulPage()),
          ModalRoute.withName(ProductListPage.routeName));
    });
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return AlertDialog(
          backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
              ? Colors.black87
              : Colors.white,
          elevation: 20,
          title: Text("Confirm!"),
          content: Text("Are you Confirm your Order?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              child: Text("Yes"),
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  var userType = await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get();

                  if (userType['role'] == 'User') {
                    _saveOrder();
                  } else if (userType['role'] == 'Distributor') {
                    _saveDistributorOrder();
                  }
                }

                // _saveOrder();
              },
            ),
          ],
        );
      },
    );
  }
}
