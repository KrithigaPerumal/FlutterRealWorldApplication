//a class for storing the product details
//contains properties of products.
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Products {
  String productId;
  String productName;
  int stockCount;
  double productPrice;

  Products(
      {required this.productId,
      required this.productName,
      required this.stockCount,
      required this.productPrice});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      stockCount: json['stockCount'] as int,
       productPrice: (json['productPrice'] as num).toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'stockCount': stockCount,
        'productPrice': productPrice,
      };

  static Future<void> writeJson(List<Products> productsList) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.json');

    final jsonProducts =
        jsonEncode(productsList.map((product) => product.toJson()).toList());
    await file.writeAsString(jsonProducts);
    
  }
   static Future<List<dynamic>> readJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/products.json');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    }
    return [];
  }
}
