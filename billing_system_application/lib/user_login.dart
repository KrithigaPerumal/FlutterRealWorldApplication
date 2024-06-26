import 'dart:convert';
import 'dart:io';
import 'package:billing_system_application/dashboard.dart';
import 'package:billing_system_application/stock_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
  String email = "";

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String password = "";
  bool login = false;

  List<dynamic> usersData = [];

  Future<List<dynamic>> readUsersJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/users.json');
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } else {
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    readUsersJson().then((data) {
      setState(() {
        usersData = List<Map<String, dynamic>>.from(data);
      });
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            "Billing Application",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Form(
          key: formkey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  //key: formkey,
                  decoration: InputDecoration(hintText: 'Enter your email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return 'Please enter valid email id!';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      email = value!;
                    });
                  },
                ),
                TextFormField(
                  //key: formkey,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: 'Enter your password'),
                  validator: (value) {
                    if (value!.length < 4) {
                      return 'Please enter password minimum of 4 characters';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value!;
                    });
                  },
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      //validate:
                      if (formkey.currentState!.validate()) {
                        formkey.currentState!.save();
                        bool emailExists =
                            usersData.any((user) => user['email'] == email);
                        if (emailExists) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashBoard()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Email not found. Please enter a valid email.'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Submit'),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
