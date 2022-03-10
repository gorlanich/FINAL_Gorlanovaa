import 'package:final_flutter_app/theme-data.dart';
import 'package:flutter/material.dart';
import 'variables.dart';
import 'package:final_flutter_app/Registration.dart';
import 'package:final_flutter_app/UserScreen.dart';
import 'package:final_flutter_app/TaskScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RegistrationScreen(),
        '/users': (context) => const UserScreen(),
        '/tasks': (context) => const TaskMainScreen(),
      },
      //title: Messages.title,
      //theme: myTheme(),
    );
  }
}



