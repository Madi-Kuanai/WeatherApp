import 'package:flutter/material.dart';
import 'package:dead_inside_app/screens/homelayout/components/body.dart';
import 'package:dead_inside_app/Consts.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: MainScreenBody(),
      resizeToAvoidBottomInset: false 
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Today, ${DateTime.now().day} ${months[DateTime.now().month - 1].toString()}',
        style: const TextStyle(
            color: utextColor,
            fontSize: 18,
            fontFamily: "Graduate-Regular"),
      ),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [whitePurple, Color(0xff6862EA)]))),
      elevation: 0,
    );
  }
}
