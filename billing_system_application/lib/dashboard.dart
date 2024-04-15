import 'package:billing_system_application/bills.dart';
import 'package:billing_system_application/custom_drawer.dart';
import 'package:billing_system_application/products.dart';
import 'package:billing_system_application/stock_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Income> data = [];
  Map<String, double> incomeMap = {};
  List<Income> incomeList = [];
  int availableProducts = 0;
  double income = 0;
  @override
  void initState() {
    super.initState();
    Bills.readJson();
    incomeForDates();
    Products.readJson().then((data) {
      setState(() {
        jsonData = List<Map<String, dynamic>>.from(data);
        availableProducts = jsonData.length;
        calculateIncome();
        incomeList = incomeMap.entries
            .map((entry) => Income(entry.key, entry.value))
            .toList();
      });
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Income, String>> series = [
      charts.Series(
        id: 'Income',
        data: data,
        domainFn: (Income income, _) => income.billedDate,
        measureFn: (Income income, _) => income.totalPrice,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Income income, _) => '${income.totalPrice}',
      ),
    ];
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Available stocks"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StockPage()),
                    );
                  },
                  child: Text(
                    "$availableProducts",
                    style: TextStyle(fontSize: 30),
                  ))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Track Income"),
              TextButton(
                  onPressed: () {
                    print(series);
                    showIncomes(incomeList);
                  },
                  child: Text(
                    '$income',
                    style: TextStyle(fontSize: 20),
                  )),
              SizedBox(
                height: 300.0,
                child: charts.BarChart(
                  series,
                  animate: true,
                  domainAxis: charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void calculateIncome() {
    double income1 = 0;
    for (var bill in allbillsList) {
      income1 += bill.totalPrice;
    }
    setState(() {
      income = income1;
    });
  }

  void incomeForDates() {
    for (var bill in allbillsList) {
      if (incomeMap.containsKey(bill.billedDate)) {
        incomeMap[bill.billedDate] =
            incomeMap[bill.billedDate]! + bill.totalPrice;
      } else {
        incomeMap[bill.billedDate] = bill.totalPrice;
      }
    }
  }

  Future showIncomes(List<Income> income) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Incomes"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: incomeList.map((income) {
                return ListTile(
                  title: Text('Billed Date: ${income.billedDate}'),
                  subtitle: Text('Total Price: ${income.totalPrice}'),
                );
              }).toList(),
            ),
          );
        });
  }
}

class Income {
  final String billedDate;
  final double totalPrice;

  Income(this.billedDate, this.totalPrice);
}
