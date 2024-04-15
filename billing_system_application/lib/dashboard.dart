import 'package:billing_system_application/custom_drawer.dart';
import 'package:billing_system_application/stock_page.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int availableProducts = jsonData.length;

  @override
  void initState() {
    super.initState();
    print("stock page called");
    StockPage();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StockPage()),
                );
              },
              icon: Text(
                "$availableProducts",
                style: TextStyle(fontSize: 30),
              ))
        ],
      ),
    );
  }
}
