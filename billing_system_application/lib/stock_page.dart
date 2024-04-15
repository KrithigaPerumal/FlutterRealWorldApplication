import 'dart:convert';
import 'dart:io';
import 'package:billing_system_application/custom_drawer.dart';
import 'package:billing_system_application/products.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

//keep this json data to read the old values and write new values.
//keep this list gloable.
List<dynamic> jsonData = [];

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  //a form key to validate the product details.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //variables for the form widget:
  String productID = "";
  String productName = "";
  double productPrice = 0;
  int productQuant = 0;

  Future<List<dynamic>> readJson() async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory);
    final file = File('${directory.path}/products.json');
    print(file);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    }
    return [];
  }

  Iterable <dynamic> filteredProducts = [];
  //the objects should be written to the json file only when the application is closed. -- whenver the user taps a button - this function has to be called.
  @override
  void initState() {
    super.initState();
    print("stock init state is called");
    readJson().then((data) {
      setState(() {
        jsonData = List<Map<String, dynamic>>.from(data);
      });
    }).catchError((error) {});
    filteredProducts = List.from(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Products Stocks",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
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
        ),
        drawer: customDrawer(context),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Filter products',
                  ),
                  onChanged: (value) {
                    // Filter products based on the input value
                    setState(() {
                      filteredProducts = jsonData.where((product) =>
                          product['productName']
                              .toLowerCase()
                              .startsWith(value.toLowerCase()));
                    });
                  },
                ),
                Table(
                  // border: TableBorder.all(width: 1.0, color: Colors.black),
                  children: [
                    // Heading row
                    const TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Product ID',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Product Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Stock Count',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Product Price',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    // Data rows
                    ...filteredProducts.map<TableRow>((product) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product['productId'].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product['productName'].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product['stockCount'].toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product['productPrice'].toString()),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        //what happens if i dont pass the context here?
                        formForProduct(context);
                      },
                      child: const Text("Add"),
                    ),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        editProduct(context);
                      },
                      child: const Text("Edit"),
                    ),
                    /*  FloatingActionButton(
                      heroTag: "btn3",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BillingPage()),
                        );
                      },
                      child: const Text("Billing"),
                    ), */
                  ],
                ),
              ],
            )));
  }

  //here the details for adding a new product will be received from the user.
//on submit -- do validation, add the new product to the list.
  Future formForProduct(BuildContext context) {
    productID = ''; // Reset the variables
    productName = '';
    productPrice = 0;
    productQuant = 0;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Product Form'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter product ID',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    productID = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter product Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    productName = value;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    double parsedValue = double.parse(value);
                    productPrice = parsedValue;
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter product stock',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    try {
                      int.parse(value);
                    } catch (e) {
                      return 'Please enter an integer value';
                    }
                    productQuant = int.parse(value);
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                //on pressed: - return the form widget.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  jsonData.add({
                    'productId': productID,
                    'productName': productName,
                    'stockCount': productQuant,
                    'productPrice': productPrice,
                  });
                  List<Products> newProducts = jsonData
                      .map((productMap) => Products.fromJson(productMap))
                      .toList();

                  await Products.writeJson(newProducts);
                  setState(() {
                    //previously jsonData
                    filteredProducts =
                        newProducts.map((product) => product.toJson()).toList();
                  });
                  print(productID);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added successfully.'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future editProduct(BuildContext context) {
    String? enteredID;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Product ID to Edit'),
          content: TextField(
            onChanged: (value) {
              enteredID = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter Product ID',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Find the product with the entered ID
                Map<String, dynamic>? productToEdit;
                for (var product in jsonData) {
                  if (product['productId'] == enteredID) {
                    productToEdit = product;
                    break;
                  }
                }

                if (productToEdit != null) {
                  // Show form to edit the product
                  Navigator.of(context).pop();
                  showEditForm(context, productToEdit);
                } else {
                  // Show error message if product not found
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product with ID $enteredID not found.'),
                    ),
                  );
                }
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Future showEditForm(BuildContext context, Map<String, dynamic> product) {
    productID = product['productId'];
    productName = product['productName'];
    productPrice = product['productPrice'];
    productQuant = product['stockCount'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  // Displaying the initial value without allowing user input
                  initialValue: productID,
                  readOnly: true, // Set readOnly to true to disable editing
                ),
                TextFormField(
                  initialValue: productName,
                  decoration: const InputDecoration(
                    hintText: 'Enter product Name',
                  ),
                  onChanged: (value) {
                    productName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null; // Return null if the value is valid
                  },
                ),
                TextFormField(
                  initialValue: productPrice.toString(),
                  decoration: const InputDecoration(
                    hintText: 'Enter price',
                  ),
                  onChanged: (value) {
                    double parsedValue = double.tryParse(value) ?? 0;
                    productPrice = parsedValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product price';
                    }
                    return null; // Return null if the value is valid
                  },
                ),
                TextFormField(
                  initialValue: productQuant.toString(),
                  decoration: const InputDecoration(
                    hintText: 'Enter product stock',
                  ),
                  onChanged: (value) {
                    int parsedValue = int.tryParse(value) ?? 0;
                    productQuant = parsedValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product stock';
                    }
                    try {
                      int.parse(value);
                    } catch (e) {
                      return 'Please enter an integer value';
                    }
                    return null; // Return null if the value is valid
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Perform the update operation
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  int index = jsonData.indexWhere(
                      (product) => product['productId'] == productID);
                  if (index != -1) {
                    // Product found
                    // Update the product's values
                    jsonData[index]['productName'] = productName;
                    jsonData[index]['productPrice'] = productPrice;
                    jsonData[index]['stockCount'] = productQuant;
                    List<Products> newProducts = jsonData
                        .map((productMap) => Products.fromJson(productMap))
                        .toList();
                    await Products.writeJson(newProducts);
                    //this set state - when it is not given, it requires a hot reload, but when given it will change it's state automatically
                    setState(() {
                      //previoulsy jsonData
                      filteredProducts = newProducts
                          .map((product) => product.toJson())
                          .toList();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product updated successfully.'),
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
