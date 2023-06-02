import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_own_user_app/pages/product_list_page.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    color: Colors.black,
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
                                color: Colors.black),
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
                                color: Colors.black),
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
                                color: Colors.black),
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
                                color: Colors.black),
                          )
                        ],
                      ),
                      Divider(
                        height: 1.h,
                        color: Colors.black,
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
                                color: Colors.black),
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
                      _showDialog(context);
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
        return AlertDialog(
          backgroundColor: Colors.white,
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

  Future<void> sslCommerzCustomizedCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        //   ipn_url: "www.ipnurl.com",
        multi_card_name: _nameController.text,
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.LIVE,
        store_id: _userProvider.userModel!.userId,
        store_passwd: _userProvider.userModel!.userId,
        total_amount: double.parse(
            "${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}"),
        tran_id: "1231321321321312",
      ),
    );

    sslcommerz
        .addEMITransactionInitializer(
            sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
                emi_options: 1, emi_max_list_options: 9, emi_selected_inst: 0))
        .addShipmentInfoInitializer(
            sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
                shipmentMethod: "yes",
                numOfItems: 5,
                shipmentDetails: ShipmentDetails(
                    shipAddress1: _addressController.text,
                    shipCity: _addressController.text,
                    shipCountry: "Bangladesh",
                    shipName: _nameController.text,
                    shipPostCode: "7860")))
        .addCustomerInfoInitializer(
          customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Chattogram",
            customerName: _nameController.text,
            customerEmail: _userProvider.userModel!.email,
            customerAddress1: "Anderkilla",
            customerCity: _addressController.text,
            customerPostCode: "200",
            customerCountry: "Bangladesh",
            customerPhone: _phoneController.text,
          ),
        )
        .addProductInitializer(
            sslcProductInitializer:
                // ***** ssl product initializer for general product STARTS*****
                SSLCProductInitializer(
          productName: "Water Filter",
          productCategory: "Widgets",
          general: General(
            general: "General Purpose",
            productProfile: "Product Profile",
          ),
        ))
        .addAdditionalInitializer(
          sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a ",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d",
          ),
        );

    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
            msg: "Transaction is Failed....",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
          msg: "Transaction is ${result.status} and Amount is ${result.amount}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        //  ipn_url: "www.ipnurl.com",
        multi_card_name: 'multicard',
        currency: SSLCurrencyType.BDT,
        product_category: "Food",

        //type
        sdkType: radioGroupValue == Payment.online
            ? SSLCSdkType.LIVE
            : SSLCSdkType.TESTBOX,
        store_id: 'store_id',
        store_passwd: 'store_password',
        total_amount: double.parse(
            "${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}"),
        tran_id: "01863791209",
      ),
    );
    try {
      SSLCTransactionInfoModel result = await sslcommerz.payNow();

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction is Failed....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "SDK Closed by User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "Transaction is ${result.status} and Amount is ${result.amount}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
