import 'package:billing_system_application/billing_page.dart';
import 'package:billing_system_application/dashboard.dart';
import 'package:billing_system_application/show_bills.dart';
import 'package:billing_system_application/stock_page.dart';
import 'package:billing_system_application/user_login.dart';
import 'package:flutter/material.dart';

customDrawer(BuildContext context) {
  return FractionallySizedBox(
    widthFactor: 0.6,
    child: Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: Text(
              email,
              style: TextStyle(color: Colors.grey.shade800),
            ),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.man),
              //backgroundImage: AssetImage("assets/profile_picture.jpg"),
            ),
          ),
          ListTile(
            title: Text("Log Out"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserLoginPage()),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.shopping_basket),
                SizedBox(
                  width: 10,
                ),
                Text("Billing"),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BillingPage()),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.inventory),
                SizedBox(
                  width: 10,
                ),
                Text("Stocks"),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StockPage()),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.money),
                SizedBox(
                  width: 10,
                ),
                Text("View Bills"),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShowBillsPage()),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.dashboard),
                SizedBox(
                  width: 10,
                ),
                Text("Dashboard"),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashBoard()),
              );
            },
          ),
        ],
      ),
    ),
  );
}
