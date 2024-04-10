//contains the list of bills here.
//sorted date wise.
//should include the search option to get the date? and show the bills accordingly?
import 'package:billing_system_application/bills.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//List<dynamic> allBillsList = [];

class ShowBillsPage extends StatefulWidget {
  const ShowBillsPage({super.key});

  @override
  State<ShowBillsPage> createState() => _ShowBillsPageState();
}

class _ShowBillsPageState extends State<ShowBillsPage> {
  @override
  void initState() {
    super.initState();
    Bills.readJson();
    print('bills called from shows $allbillsList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Bills"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allbillsList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text('Billing Date: ${allbillsList[index].billedDate}'),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: allbillsList[index].cartProducts.map((product) {
                        // Display each product in the cartProducts list
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('${product.productId}'),
                            Text('${product.productName}'),
                            Text('${product.stockCount}'),
                            Text('${product.productPrice}',)
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          FloatingActionButton(onPressed: (){}, child: Text("Income"),)
        ],
      ),
    );
  }
}
