//a class for storing the bills.
//properties:
//product details
//bill id??
//bill date. - current data and time. (although time not required)

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Bills {
  // static int _lastBillId = 1000;
  //String billId;
  double totalPrice;
  //DateTime billedDate;
  List<CartList> cartProducts;

  Bills({
    required this.totalPrice,
    required this.cartProducts,
    //required this.billedDate,
  });
  //: billId = 'BILL${_lastBillId++}';

  Map<String, dynamic> toJson() => {
        //'billId': billId,
        'totalPrice': totalPrice,
        //'billedDate': billedDate,
        'cartProducts':
            cartProducts.map((cartList) => cartList.toJson()).toList(),
      };

  static Future<void> writeBillsJson(List<Bills> billsList) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bills.json');
    print("write is called");
    final jsonBills =jsonEncode(billsList.map((bill) => bill.toJson()).toList());
    await file.writeAsString(jsonBills);
    print("run successfully");
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
