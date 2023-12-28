import 'package:ecommerce_own_user_app/models/product_model.dart';
import 'package:ecommerce_own_user_app/pages/product_details_page.dart';
import 'package:ecommerce_own_user_app/providers/product_provider.dart';
import 'package:ecommerce_own_user_app/providers/theme_provider.dart';
import 'package:ecommerce_own_user_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
          ? Colors.grey.shade800
          : Colors.white,
      appBar: AppBar(
        leadingWidth: 40.w,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: themeProvider.themeModeType == ThemeModeType.Dark
                    ? Colors.white
                    : Colors.black,
              )),
        ),
        backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.grey.shade800
            : Colors.white,
        elevation: 0,
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            fillColor: themeProvider.themeModeType == ThemeModeType.Dark
                ? Colors.black
                : Colors.white,
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
              color: themeProvider.themeModeType == ThemeModeType.Dark
                  ? Colors.white
                  : Colors.black,
            ),
            hintText: 'Search Products',
          ),
        ),
      ),
      body: Consumer<ProductProvider>(builder: (context, provider, _) {
        return ListView.builder(
          itemCount: _searchQuery.isEmpty ? 0 : provider.productList.length,
          itemBuilder: (context, index) {
            final product = provider.productList[index];
            if (product.name!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase())) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ProductDetailsPage.routeName,
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
                      tileColor: Colors.grey,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "${provider.productList[index].imageDownloadUrl}"),
                      ),
                      title: Text("${provider.productList[index].name}"),
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
