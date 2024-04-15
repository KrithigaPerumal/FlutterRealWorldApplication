import 'package:billing_system_application/billing_page.dart';
import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/custom_drawer.dart';
import 'package:billing_system_application/products.dart';
import 'package:billing_system_application/stock_page.dart';
import 'package:flutter/material.dart';

class ShowBillsPage extends StatefulWidget {
  const ShowBillsPage({super.key});

  @override
  State<ShowBillsPage> createState() => _ShowBillsPageState();
}

class _ShowBillsPageState extends State<ShowBillsPage> {
  double income = 0;
  String? selectedDate;
  String nowDate = "";
  @override
  void initState() {
    super.initState();
    Bills.readJson();
    calculateIncome();
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    nowDate = "$day/$month/$year";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        automaticallyImplyLeading: false,
        title: const Text(
          "All Bills",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: customDrawer(context),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              String? date = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController dateController =
                      TextEditingController();
                  return AlertDialog(
                    title: Text("Enter Date"),
                    content: TextField(
                      controller: dateController,
                      decoration: InputDecoration(hintText: "DD/MM/YYYY"),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, dateController.text);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
              setState(() {
                selectedDate = date;
              });
            },
            child: Text('Filter by Date'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedDate == null
                  //here provide today's bills.
                  ? allbillsList
                      .where((bill) => bill.billedDate == nowDate)
                      .length
                  : allbillsList
                      .where((bill) => bill.billedDate == selectedDate)
                      .length,
              itemBuilder: (context, index) {
                Bills bill = selectedDate == null
                    ? allbillsList
                        .where((bill) => bill.billedDate == nowDate)
                        .toList()[index]
                    : allbillsList
                        .where((bill) => bill.billedDate == selectedDate)
                        .toList()[index];
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${index + 1}      '),
                      Text('Billing Date: ${bill.billedDate}'),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      //get back the products to the stock
                      updateCancelledBill(allbillsList[index].cartProducts);
                      //update the income.
                      income -= allbillsList[index].totalPrice;
                      //on tap remove the item from the list
                      setState(() {
                        jsonData = newProducts
                            .map((product) => product.toJson())
                            .toList();
                        allbillsList.removeAt(index);
                      });
                      await Bills.writeBillsJson(allbillsList);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Your bill has been reverted.'),
                        ),
                      );
                    },
                    child: Icon(Icons.delete),
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: bill.cartProducts.map((product) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('${product.productId}'),
                                Text('${product.productName}'),
                                Text('${product.stockCount}'),
                                Text('${product.productPrice}'),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: FloatingActionButton(
              onPressed: () {
                showIncome(context);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Track Income"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future showIncome(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Income"),
            content: Text('$income'),
          );
        });
  }

  //update the products.json - call the writeto json.
  void updateCancelledBill(List<CartList> cartlist) {
    //getting traversed twice - how n why?
    for (var product in cartlist) {
      for (var productStock in newProducts) {
        if (product.productId == productStock.productId) {
          productStock.stockCount += product.stockCount;
        }
      }
    }
    Products.writeJson(newProducts);
  }

  void calculateIncome() {
    for (var bill in allbillsList) {
      income += bill.totalPrice;
    }
  }
}
