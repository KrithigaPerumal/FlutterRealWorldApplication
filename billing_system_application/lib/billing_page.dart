import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/custom_drawer.dart';
import 'package:billing_system_application/products.dart';
import 'package:billing_system_application/stock_page.dart';
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
    addProductsToSuggestions();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double totalPrice = 0;
  String prodName = "";
  double prodPrice = 0;
  String prodId = "";
  int prodStock = 0;
  String billDate = "";

  String displayProdID = "";
  int displayProduQuant = 0;

  List<CartList> cartList = [];

  //instead of these values - product ids and names from the products.json file.
  //forget the product id. searching and billing is based on product name only.
  //since the suggestions are directly fetched from json file and the suggestions.index will be set in the text form field, the typo will be problem.
  //to do: example: p is typed pen and pencil should be displayed.
  //error: at first the first index value is present
  //when backspacing the suggestions disappers even when typed again.
  List<String> _suggestions = [];

  void addProductsToSuggestions() {
    for (var prodName in newProducts) {
      _suggestions.add(prodName.productName);
    }
  }

  final _prodIdController = TextEditingController();
  final _quantityController = TextEditingController();

  //final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void updateSuggestions(String value) {
    setState(() {
      _suggestions = _filterSuggestions(value);
    });
  }

  String _productData = "";

  void displayProductData(String productName) {
    _productData = productName;
    int index = jsonData
        .indexWhere((product) => product['productName'] == _productData);
    displayProduQuant = (index != -1) ? jsonData[index]['stockCount'] : 0;
    displayProdID = (index != -1) ? jsonData[index]['productId'] : "Nil";
  }

  List<String> _filterSuggestions(String query) {
    // Filter suggestions based on the query
    if (query.isEmpty) {
      return [];
    }
    return _suggestions
        .where((suggestion) => suggestion.toLowerCase().startsWith(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ), // Drawer icon
            );
          },
        ),
        title: const Text(
          "Billing Page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: customDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Autocomplete<String>(
                      //fieldHintText: 'Enter product Name', // Adding hint text
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return _suggestions.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selectedOption) {
                        //_prodIdController.text = selectedOption;
                        prodName = selectedOption;
                        displayProductData(selectedOption);
                      },
                    ),
                    SizedBox(height: 10),
                    if (_productData
                        .isNotEmpty) // Show only if there's product data
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('ID: $displayProdID'),
                            Text('Available stock: $displayProduQuant'),
                          ],
                        ),
                        // Display relevant product data here
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

                              int index = jsonData.indexWhere((product) =>
                                  product['productName'] == prodName);
                              if (index != -1) {
                                int quantity =
                                    int.parse(_quantityController.text);
                                //prodName = jsonData[index]['productName'];
                                prodPrice =
                                    jsonData[index]['productPrice'] * quantity;
                                prodStock = jsonData[index]['stockCount'];
                                prodId = jsonData[index]['productId'];

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
                            _productData = "";
                            //updateSuggestions('');
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
                  if (cartList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Empty Cart to generate Bill'),
                      ),
                    );
                  } else {
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
                      jsonData = newProducts
                          .map((product) => product.toJson())
                          .toList();
                    });
                  }
                },
                child: Text("Bill"),
              )),
              SizedBox(
                width: 60,
                child: FloatingActionButton(
                   heroTag: "butn2",
                  onPressed: () {
                    //empty the cart items.
                    setState(() {
                      cartList.clear();
                      totalPrice = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Cancel Bill"),
                  ),
                ),
              )
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
