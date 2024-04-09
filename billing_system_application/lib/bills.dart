//a class for storing the bills.
//properties:
//product details
//bill id??
//bill date. - current data and time. (although time not required)

class Bills {
  String productId;
  String productName;
  int stockCount;
  double productPrice;

  Bills(
      {required this.productId,
      required this.productName,
      required this.stockCount,
      required this.productPrice});
}
