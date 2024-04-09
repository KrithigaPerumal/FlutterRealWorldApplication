import 'package:billing_system_application/stockpage.dart';
import 'package:flutter/material.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: formkey,
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
                key: formkey,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter your password'),
                validator: (value) {
                  if (value!.length < 4 || !value.contains("@")) {
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
              SizedBox(
                height: 50,
              ),
              Container(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //validate:
                    if (formkey.currentState!.validate()) {
                      formkey.currentState!.save();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StockPage()),
                      );
                    }
                    //if valid : route to next page
                  },
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        ));
  }
}
