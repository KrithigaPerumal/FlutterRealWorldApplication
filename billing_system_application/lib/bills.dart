import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

List<Bills> allbillsList = [];

class Bills {
  // static int _lastBillId = 1000;
  //String billId;
  double totalPrice;
  String billedDate;
  List<CartList> cartProducts;

  Bills({
    required this.totalPrice,
    required this.cartProducts,
    required this.billedDate,
  });
  //: billId = 'BILL${_lastBillId++}';

  Map<String, dynamic> toJson() => {
        //'billId': billId,
        'totalPrice': totalPrice,
        'billedDate': billedDate,
        'cartProducts':
         cartProducts.map((cartList) => cartList.toJson()).toList(),
      };

  static Future<void> writeBillsJson(List<Bills> billsList) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bills.json');
    final jsonBills =
        jsonEncode(billsList.map((bill) => bill.toJson()).toList());
    await file.writeAsString(jsonBills);
  }

  //reading bills.
  static Future<List<Bills>> readJson() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/bills.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as List<dynamic>;
        allbillsList = jsonData.map((item) => Bills.fromJson(item)).toList();
        return allbillsList;
      } else {
        return []; 
      }
  }

  factory Bills.fromJson(Map<String, dynamic> json) {
    List<dynamic> cartProductsJson = json['cartProducts'];
    List<CartList> cartProducts = cartProductsJson
        .map((productJson) => CartList.fromJson(productJson))
        .toList();
    return Bills(
      totalPrice: json['totalPrice'],
      billedDate: json['billedDate'],
      cartProducts: cartProducts,
      //cartProducts: List<CartList>.from(cartProducts), // Ensure new instances
    );
  }
}

class CartList {
  String productId;
  String productName;
  int stockCount;
  double productPrice;

  CartList(
      {required this.productId,
      required this.productName,
      required this.stockCount,
      required this.productPrice});

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'stockCount': stockCount,
        'productPrice': productPrice,
      };

  factory CartList.fromJson(Map<String, dynamic> json) {
    return CartList(
      productId: json['productId'],
      productName: json['productName'],
      stockCount: json['stockCount'],
      productPrice: json['productPrice'],
    );
  }
}
