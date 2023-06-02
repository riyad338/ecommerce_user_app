import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_own_user_app/models/product_model.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_details_page.dart';
import 'package:ecommerce_own_user_app/pages/product_details_page.dart';
import 'package:ecommerce_own_user_app/providers/product_provider.dart';
import 'package:ecommerce_own_user_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class DistributorSearchPage extends StatefulWidget {
  static const String routeName = '/distributor_search_page';

  @override
  _DistributorSearchPageState createState() => _DistributorSearchPageState();
}

class _DistributorSearchPageState extends State<DistributorSearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 40.w,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.greenAccent)),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(color: Colors.greenAccent)),
            suffixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: 'Search Products',
          ),
        ),
      ),
      body: Consumer<ProductProvider>(builder: (context, provider, _) {
        return ListView.builder(
          itemCount:
              _searchQuery.isEmpty ? 0 : provider.distributorProductList.length,
          itemBuilder: (context, index) {
            final product = provider.distributorProductList[index];
            if (product.name!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase())) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                      context, DistributorProductDetailsPage.routeName,
                      arguments: [
                        product.id,
                        product.name,
                        product,
                      ]);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: product.imageDownloadUrl!,
                          placeholder: (context, url) => Center(
                            child: SpinKitFadingCircle(
                              color: Colors.greenAccent,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        // backgroundImage:
                        //     NetworkImage("${product.imageDownloadUrl}"),
                      ),
                      title: Text("${product.name}"),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }
}
