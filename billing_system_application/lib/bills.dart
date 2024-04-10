//a class for storing the bills.
//properties:
//product details
//bill id??
//bill date. - current data and time. (although time not required)

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
List<Bills> allbillsList =[];

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
  //writing bills.
  static Future<void> writeBillsJson(List<Bills> billsList) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/bills.json');
    print("write is called");
    final jsonBills =
        jsonEncode(billsList.map((bill) => bill.toJson()).toList());
    await file.writeAsString(jsonBills);
    print(jsonBills);
    print(jsonBills.length);
    print("run successfully");
  }

  //reading bills.
  static Future<List<Bills>> readJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/bills.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as List<dynamic>;
        allbillsList =
            jsonData.map((item) => Bills.fromJson(item)).toList();
            print("bills list length in reading ${allbillsList.length}");
            print(allbillsList);
        return allbillsList;
      } else {
        return []; // Return an empty list if the file does not exist
      }
    } catch (e) {
      print('Error reading bills.json file: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  factory Bills.fromJson(Map<String, dynamic> json) {
    List<dynamic> cartProductsJson = json['cartProducts'];
    List<CartList> cartProducts = cartProductsJson
        .map((productJson) => CartList.fromJson(productJson))
        .toList();
    return Bills(
      //billId: json['billId'],
      totalPrice: json['totalPrice'],
      billedDate: json['billedDate'],
      cartProducts: cartProducts,
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
