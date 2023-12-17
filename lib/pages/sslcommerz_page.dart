// ignore_for_file: deprecated_member_use

import 'package:ecommerce_own_user_app/utils/constants.dart';
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

class SSLCommerzPage extends StatefulWidget {
  static const String routeName = '/ssl';

  @override
  _SSLCommerzPageState createState() => _SSLCommerzPageState();
}

class _SSLCommerzPageState extends State<SSLCommerzPage> {
  double? amount;
  @override
  String? name;
  String? address;
  String? uid;
  String? phone;

  void didChangeDependencies() {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    amount = argList[0];
    name = argList[1];
    address = argList[2];
    uid = argList[3];
    phone = argList[4];

    super.didChangeDependencies();
  }

  var _key = GlobalKey<FormState>();
  dynamic formData = {};
  SdkType _radioSelected = SdkType.TESTBOX;
  bool isload = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Online Payment'),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isload == false
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            initialValue: "demotest",
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              hintText: "Store ID",
                            ),
                            validator: (value) {
                              if (value != null)
                                return "Please input store id";
                              else
                                return null;
                            },
                            onSaved: (value) {
                              formData['store_id'] = value;
                            },
                          ),
                        )
                      : SizedBox(),
                  isload == false
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            initialValue: "qwerty",
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              hintText: "Store password",
                            ),
                            validator: (value) {
                              if (value != null)
                                return "Please input store password";
                              else
                                return null;
                            },
                            onSaved: (value) {
                              formData['store_password'] = value;
                            },
                          ),
                        )
                      : SizedBox(),
                  isload == false
                      ? Row(
                          children: [
                            Radio(
                              value: SdkType.TESTBOX,
                              groupValue: _radioSelected,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = value as SdkType;
                                });
                              },
                            ),
                            Text("TEXTBOX"),
                            Radio(
                              value: SdkType.LIVE,
                              groupValue: _radioSelected,
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = value as SdkType;
                                });
                              },
                            ),
                            Text('LIVE'),
                          ],
                        )
                      : SizedBox(),
                  isload == false
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              hintText: "Phone number",
                            ),
                            onSaved: (value) {
                              formData['phone'] = value;
                            },
                          ),
                        )
                      : SizedBox(),
                  isload == false
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            initialValue: "10",
                            // keyboardType: TextInputType.number,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              hintText: "Payment amount",
                            ),
                            validator: (value) {
                              if (value != null)
                                return "Please input amount";
                              else
                                return null;
                            },
                            onSaved: (value) {
                              formData['amount'] = double.parse(value!);
                            },
                          ),
                        )
                      : SizedBox(),
                  isload == false
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              hintText: "Enter multi card",
                            ),
                            onSaved: (value) {
                              formData['multicard'] = value;
                            },
                          ),
                        )
                      : SizedBox(),
                  Text(
                    "Name: ${name!}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Address: ${address!}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Phone: ${phone!}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Amount: ${amount!} $takaSymbol",
                    style: TextStyle(fontSize: 25),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        backgroundColor: Colors.greenAccent),
                    child: Text(
                      "Pay now",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    onPressed: () {
                      if (_key.currentState != null) {
                        _key.currentState?.save();
                        print(_radioSelected);
                        sslCommerzGeneralCall();
                        //sslCommerzCustomizedCall();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.LIVE,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: amount!,
        tran_id: "1231123131212",
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

  Future<void> sslCommerzCustomizedCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: name!,
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: SSLCSdkType.LIVE,
        store_id: address!,
        store_passwd: uid!,
        total_amount: amount!,
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
                    shipAddress1: "Ship address 1",
                    shipCity: "Faridpur",
                    shipCountry: "Bangladesh",
                    shipName: "Ship name 1",
                    shipPostCode: "7860")))
        .addCustomerInfoInitializer(
          customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Chattogram",
            customerName: "Abu Sayed Chowdhury",
            customerEmail: "sayem227@gmail.com",
            customerAddress1: "Anderkilla",
            customerCity: "Chattogram",
            customerPostCode: "200",
            customerCountry: "Bangladesh",
            customerPhone: formData['phone'],
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
        )
            // ***** ssl product initializer for general product ENDS*****

            // ***** ssl product initializer for non physical goods STARTS *****
            // SSLCProductInitializer.WithNonPhysicalGoodsProfile(
            //     productName:
            //   "productName",
            //   productCategory:
            //   "productCategory",
            //   nonPhysicalGoods:
            //   NonPhysicalGoods(
            //      productProfile:
            //       "Product profile",
            //     nonPhysicalGoods:
            //     "non physical good"
            //       ))
            // ***** ssl product initializer for non physical goods ENDS *****

            // ***** ssl product initialization for travel vertices STARTS *****
            //       SSLCProductInitializer.WithTravelVerticalProfile(
            //          productName:
            //         "productName",
            //         productCategory:
            //         "productCategory",
            //         travelVertical:
            //         TravelVertical(
            //               productProfile: "productProfile",
            //               hotelName: "hotelName",
            //               lengthOfStay: "lengthOfStay",
            //               checkInTime: "checkInTime",
            //               hotelCity: "hotelCity"
            //             )
            //       )
            // ***** ssl product initialization for travel vertices ENDS *****

            // ***** ssl product initialization for physical goods STARTS *****

            // SSLCProductInitializer.WithPhysicalGoodsProfile(
            //     productName: "productName",
            //     productCategory: "productCategory",
            //     physicalGoods: PhysicalGoods(
            //         productProfile: "Product profile",
            //         physicalGoods: "non physical good"))

            // ***** ssl product initialization for physical goods ENDS *****

            // ***** ssl product initialization for telecom vertice STARTS *****
            // SSLCProductInitializer.WithTelecomVerticalProfile(
            //     productName: "productName",
            //     productCategory: "productCategory",
            //     telecomVertical: TelecomVertical(
            //         productProfile: "productProfile",
            //         productType: "productType",
            //         topUpNumber: "topUpNumber",
            //         countryTopUp: "countryTopUp"))
            // ***** ssl product initialization for telecom vertice ENDS *****
            )
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
}
