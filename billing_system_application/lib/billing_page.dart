import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/products.dart';
import 'package:billing_system_application/showbills.dart';
import 'package:billing_system_application/stockpage.dart';
import 'package:flutter/material.dart';

List<Bills> billList = [];

List<Products> newProducts =
    jsonData.map((productMap) => Products.fromJson(productMap)).toList();

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  @override
  void initState() {
    super.initState();
    Bills.readJson();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double totalPrice = 0;
  String prodName = "";
  double prodPrice = 0;
  String prodId = "";
  int prodStock = 0;
  String billDate = "";

  List<CartList> cartList = [];

  final _prodIdController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StockPage()),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.white,
              ),
            ),
            Text(
              "Billing Page",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.30,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _prodIdController,
                      decoration: InputDecoration(
                        hintText: 'Enter product Id',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        prodId = value;
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        hintText: 'Enter Quantity',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          heroTag: "butn2",
                          onPressed: () {
                            DateTime now = DateTime.now();
                            int year = now.year;
                            int month = now.month;
                            int day = now.day;
                            billDate = "$day/$month/$year";
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              int index = jsonData.indexWhere(
                                  (product) => product['productId'] == prodId);
                              if (index != -1) {
                                int quantity =
                                    int.parse(_quantityController.text);
                                prodName = jsonData[index]['productName'];
                                prodPrice =
                                    jsonData[index]['productPrice'] * quantity;
                                prodStock = jsonData[index]['stockCount'];

                                //procceed to add to cart only when the entered quantity is avaiable in the stock.
                                if (quantity <= prodStock) {
                                  CartList newprod = CartList(
                                      productId: prodId,
                                      productName: prodName,
                                      stockCount: quantity,
                                      productPrice: prodPrice);
                                  setState(() {
                                    cartList.add(newprod);
                                  });
                                  totalPrice += prodPrice;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Stock not available. Available stock is $prodStock'),
                                    ),
                                  );
                                }
                              } else {
                                // Show error message if product not found
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Product with ID $prodId not found.'),
                                  ),
                                );
                              }
                            }
                            _prodIdController.clear();
                            _quantityController.clear();
                          },
                          child: Text("Add to Cart"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //a container will have a list tile
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final item = cartList[index];
                return ListTile(
                  title: Text('Product ID: ${item.productId}'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity: ${item.stockCount}'),
                      Text('Product Name: ${item.productName}'),
                      Text('Price: ${item.productPrice}'),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        cartList.removeAt(index);
                        //also have to reduce from the total price.
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  child: FloatingActionButton(
                heroTag: "butn1",
                onPressed: () async {
                  Bills newbill = Bills(
                      totalPrice: totalPrice,
                      cartProducts: cartList,
                      billedDate: billDate);
                  //check wheather the set state is required here?
                  allbillsList.add(newbill);
                  await Bills.writeBillsJson(allbillsList);
                  setState(() {
                    updateProductStock(cartList);
                    showBill(context);
                    jsonData =
                        newProducts.map((product) => product.toJson()).toList();
                  });
                },
                child: Text("Bill"),
              )),
              SizedBox(
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowBillsPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("View Bills"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //update the products.json - call the writeto json.
  updateProductStock(List<CartList> cartlist) {
    for (var product in cartlist) {
      for (var productStock in newProducts) {
        print(
            "before subtraction ${productStock.productId}- ${productStock.stockCount}");
        if (product.productId == productStock.productId) {
          productStock.stockCount -= product.stockCount;
          print(
              "after subtraction ${productStock.productId}- ${productStock.stockCount}");
        }
      }
    }

    Products.writeJson(newProducts);
  }

  showBill(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Text("Bill"),
                Text(billDate),
              ],
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: cartList.map((product) {
                    // Display each product in the cartProducts list
                    return Column(
                      children: [
                        Text(
                            '${product.productId} - ${product.productName} - ${product.productPrice}'),
                        Divider(),
                      ],
                    );
                  }).toList(),
                ),
                Text('Total Price: $totalPrice'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //reseting the values and the display.
                  setState(() {
                    cartList.clear();
                    totalPrice = 0;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }
}
