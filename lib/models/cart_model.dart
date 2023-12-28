class CartModel {
  String productId;
  String productName;
  String? imageDownloadUrl;
  num price;
  int qty;

  CartModel(
      {required this.productId,
      required this.productName,
      required this.price,
      this.imageDownloadUrl,
      this.qty = 1});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'imageDownloadUrl': imageDownloadUrl,
      'price': price,
      'qty': qty,
    };
    return map;
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        productId: map['productId'],
        productName: map['productName'],
        imageDownloadUrl: map['imageDownloadUrl'],
        price: map['price'],
        qty: map['qty'],
      );
}
