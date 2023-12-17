import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> distributorProductList = [];
  List<String> categoryList = [];
  List<String> carouselSliderimg = [];
  void getAllProducts() {
    DBHelper.fetchAllProducts().listen((event) {
      productList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getAllDistributorProducts() {
    DBHelper.fetchAllDistributorProducts().listen((event) {
      distributorProductList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void getAllProductsByCategory(String category) {
    DBHelper.fetchAllProductsByCategory(category).listen((event) {
      productList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductByProductId(
      String productId) {
    return DBHelper.fetchProductByProductId(productId);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>
      getDistributorProductByProductId(String productId) {
    return DBHelper.fetchDistributorProductByProductId(productId);
  }

  void getAllCategories() {
    DBHelper.fetchAllCategories().listen((event) {
      categoryList = List.generate(
          event.docs.length, (index) => event.docs[index].data()['name']);
      notifyListeners();
    });
  }

  void getCarouselSliderImage() {
    DBHelper.fetchAllProducts().listen((snapshot) {
      carouselSliderimg = List.generate(snapshot.docs.length,
          (index) => snapshot.docs[index].data()['imageDownloadUrl']);
      notifyListeners();
    });
  }
}
