import 'dart:convert';
import 'dart:io';

import 'package:billing_system_application/user_login.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main()  {
   runApp(const MyApp());
  //await createUsersJsonFile();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserLoginPage(),
    );
  }
}

Future<void> createUsersJsonFile() async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory);
  final file = File('${directory.path}/users.json');
  print(file);

  // Sample user data
  List<Map<String, dynamic>> users = [
    {"email": "user1@example.com", "password": "password1"},
    {"email": "user2@example.com", "password": "password2"},
    {"email": "user3@example.com", "password": "password3"}
  ];

  // Convert users list to JSON
  String jsonString = jsonEncode(users);

  // Write JSON data to file
  await file.writeAsString(jsonString);

  print('users.json file created: ${file.path}');
}
