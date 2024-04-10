//here is where the billing in done.
//create a button to add a new bill
//form widget to create the bill
//validate the bill on submit and add the bill to the list
// the newly added bill will be shown here.
import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/stockpage.dart';
import 'package:flutter/material.dart';


List<Bills> billList = [];

//const IconData trash = IconData(0xf4c4, fontFamily: iconFont, fontPackage: iconFontPackage);
class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  void initState() {
    super.initState();
    //print('values are is $jsonData');
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double totalPrice = 0;
  String prodName = "";
  double prodPrice = 0;
  String prodId = "";
  int prodStock = 0;

  List<CartList> cartList = [];

  final _prodIdController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Billing Page",
          style: TextStyle(color: Colors.white),
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
              height: MediaQuery.of(context).size.height * 0.25,
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
                        //int quantity = int.tryParse(value) ?? 0;
                        return null;
                      },
                    ),
                    SizedBox(
                      //height: MediaQuery.of(context).size.height*0.20,
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          heroTag: "butn2",
                          onPressed: () {
                            int len = cartList.length;
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              print(prodId);
                              //print(qunatity);
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
                                  CartList newbill = CartList(
                                      productId: prodId,
                                      productName: prodName,
                                      stockCount: quantity,
                                      productPrice: prodPrice);
                                  setState(() {
                                    cartList.add(newbill);
                                  });
                                  totalPrice += prodPrice;
                                  print('after adding $len');
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
          
          SizedBox(
              child: FloatingActionButton(
                heroTag: "butn1",
            onPressed: () async{
              //creates a new bill
              //to do:
              //have to remove the list tiles when pressed and display the created bill. 
              //have to update the products.json file
              //have to write in the bills.json file. 
              Bills newbill = Bills(totalPrice: totalPrice, cartProducts: cartList );
              await Bills.writeBillsJson(billList);
              setState(() {
                billList.add(newbill);
              });
              print(billList);
             // print(newbill.billId);
              print(newbill.cartProducts.length);
              print(newbill.totalPrice);
            },
            child: Text("Bill"),
          ))
        ],
      ),
    );
  }
}
