import 'package:billing_system_application/billingpage.dart';
import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/products.dart';
import 'package:billing_system_application/stockpage.dart';
import 'package:flutter/material.dart';

class ShowBillsPage extends StatefulWidget {
  const ShowBillsPage({super.key});

  @override
  State<ShowBillsPage> createState() => _ShowBillsPageState();
}

class _ShowBillsPageState extends State<ShowBillsPage> {
  double income = 0;
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    Bills.readJson();
    calculateIncome();
    print(income);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BillingPage()),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.white,
              ),
            ),
            Text(
              "All Bills",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
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
                  ? allbillsList.length
                  : allbillsList
                      .where((bill) => bill.billedDate == selectedDate)
                      .length,
              itemBuilder: (context, index) {
                Bills bill = selectedDate == null
                    ? allbillsList[index]
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

  showIncome(BuildContext context) {
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
  updateCancelledBill(List<CartList> cartlist) {
    //getting traversed twice - how n why?
    for (var product in cartlist) {
      for (var productStock in newProducts) {
        print(
            "before subtraction ${productStock.productId}- ${productStock.stockCount}");
        if (product.productId == productStock.productId) {
          productStock.stockCount += product.stockCount;
          print(
              "after subtraction ${productStock.productId}- ${productStock.stockCount}");
        }
      }
    }
    Products.writeJson(newProducts);
  }

  calculateIncome() {
    for (var bill in allbillsList) {
      income += bill.totalPrice;
    }
  }
}
