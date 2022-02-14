import 'dart:ui';
import 'package:dead_inside_app/screens/datalayout/components/body.dart';
import 'package:flutter/material.dart';
import 'package:dead_inside_app/Consts.dart';

class DataScreen extends StatelessWidget {
  late String city_name;
  DataScreen(name) {
    city_name = name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SearchedPage(city_name),
    );
  }

  AppBar appBar() {
    return AppBar(
      //title: Text(
      //  city_name,
      //  style: const TextStyle(
      //      color: utextColor,
      //      fontSize: 22,
      //      fontFamily: "Graduate-Regular"),
      //),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [whitePurple, blackPurple]))),
      elevation: 0,
    );
  }
}
