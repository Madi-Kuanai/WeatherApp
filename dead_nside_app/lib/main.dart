import 'package:flutter/material.dart';
import 'screens/homelayout/HomeScreen.dart';

import 'Consts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: uPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: utextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen());
  }
}
