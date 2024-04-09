//here is where the billing in done.
//create a button to add a new bill
//form widget to create the bill
//validate the bill on submit and add the bill to the list
// the newly added bill will be shown here.

import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/stockpage.dart';
import 'package:flutter/material.dart';

List<Bills> cartList = [];

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  void initState() {
    super.initState();
    print('values are is $jsonData');
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int qunatity = 0;
  String prodName = "";
  double prodPrice = 0;
  String prodId = "";
  int prodStock = 0;

  final _prodIdController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Billing Page",
          style: TextStyle(color: const Color.fromARGB(255, 161, 31, 31)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                      decoration: InputDecoration(
                        hintText: 'Enter Quantity',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        qunatity = int.parse(value);
                        return null;
                      },
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(prodId);
                          print(qunatity);
                          int index = jsonData.indexWhere(
                              (product) => product['productId'] == prodId);
                          if (index != -1) {
                            prodName = jsonData[index]['productName'];
                            prodPrice = jsonData[index]['productPrice'];
                            prodStock = jsonData[index]['stockCount'];
                          } else {
                            // Show error message if product not found
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Product with ID $prodId not found.'),
                              ),
                            );
                          }
                          //procceed to add to cart only when the entered quantity is avaiable in the stock.
                          if (qunatity <= prodStock) {
                            //add the prod in the cart list.
                            /* cartList.add({
                              'productId': prodId,
                              'productName': prodName,
                              'stockCount': qunatity,
                              'productPrice': qunatity * prodPrice,
                            }); */
                            //setState(() {
                            cartList.add(Bills(
                                productId: prodId,
                                productName: prodName,
                                stockCount: qunatity,
                                productPrice: prodPrice * qunatity));
                            //});
                          }
                        }
                        _prodIdController.clear();
                        _quantityController.clear();
                      },
                      child: Text("Add to Cart"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //a container will have a list tile
          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final item = cartList[index];
                return ExpansionTile(
                  title: Text(item.productName),
                  subtitle: Text('Quantity:$qunatity'),
                  children: [
                    ListTile(
                      title: Text('Product ID: ${item.productId}'),
                      subtitle: Text('Price: ${item.productPrice}'),
                    ),
                    // Add more ListTile widgets or other child widgets as needed
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
