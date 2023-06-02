class DistributorCartModel {
  String productId;
  String productName;
  num price;
  int qty;

  DistributorCartModel(
      {required this.productId,
      required this.productName,
      required this.price,
      this.qty = 16});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'productId': productId,
      'productName': productName,
      'price': price,
      'qty': qty,
    };
    return map;
  }

  factory DistributorCartModel.fromMap(Map<String, dynamic> map) =>
      DistributorCartModel(
        productId: map['productId'],
        productName: map['productName'],
        price: map['price'],
        qty: map['qty'],
      );
}
