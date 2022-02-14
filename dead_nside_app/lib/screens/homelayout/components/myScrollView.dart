import 'package:dead_inside_app/screens/datalayout/DataScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:dead_inside_app/Consts.dart';
import 'package:http/http.dart' as http;

class MyCards extends StatefulWidget {
  late int _index;
  MyCards(int index) {
    this._index = index;
  }

  @override
  State<MyCards> createState() => _MyCardsState(index: _index.toInt());
}

class _MyCardsState extends State<MyCards> {
  late Size _size;
  late CardItem _item;
  var _Iconid;
  var _cityname;
  var _wind;
  var _temp;
  var _humadit;
  List<CardItem> items = [
    CardItem(name: "Paris"),
    CardItem(name: "Tokio"),
    CardItem(name: "London"),
    CardItem(name: "Dubai"),
    CardItem(name: "New York"),
    CardItem(name: "Astana"),
    CardItem(name: "Istanbul")
  ];

  _MyCardsState({required int index}) {
    this._item = items[index];
  }
  @override
  void initState() {
    initDates(_item.name);
    super.initState();
  }

  Future<void> initDates(@required name) async {
    var queryParameters = {"q": name, "appid": api};
    var req = Uri.https(
        "api.openweathermap.org", "/data/2.5/weather", queryParameters);
    http.Response response = await http.get(req);
    var _answer = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        this._cityname = _answer["name"];
        this._temp = _answer["main"]["temp"].round() - 273;
        this._wind = _answer["wind"]["speed"];
        this._humadit = _answer["main"]["humidity"];
        this._Iconid = _answer["weather"][0]["icon"];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        width: _size.width * 0.55,
        child: GestureDetector(
          onTap: () {
            if(_cityname != null){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DataScreen(_cityname))
            );}
          },
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: cardColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: _Iconid == null
                            ? Image.asset(
                                "assets/images/empty.png",
                                height: _size.height * 0.1,
                                width: _size.width * 0.2,
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                "http://openweathermap.org/img/wn/${_Iconid}@2x.png",
                                height: _size.height * 0.1,
                                width: _size.width * 0.2,
                                fit: BoxFit.contain,
                              ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location",
                            style: TextStyle(
                                color: bTextColor,
                                fontSize: 14,
                                fontFamily: "Graduate-Regular"),
                          ),
                          Text(
                            _cityname ?? "Loading...",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: "Graduate-Regular"),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Wind",
                              style: TextStyle(
                                  color: bTextColor,
                                  fontSize: 14,
                                  fontFamily: "Graduate-Regular")),
                          Text(_wind == null ? "0" : _wind.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Graduate-Regular"))
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Temp",
                              style: TextStyle(
                                  color: bTextColor,
                                  fontSize: 14,
                                  fontFamily: "Graduate-Regular")),
                          Text(
                              _temp == null
                                  ? "0°C"
                                  : _temp.toString() + "°C",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Graduate-Regular"))
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Humidit",
                              style: TextStyle(
                                  color: bTextColor,
                                  fontSize: 14,
                                  fontFamily: "Graduate-Regular")),
                          Text(
                              _humadit == null
                                  ? "... %"
                                  : _humadit.toString() + "%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Graduate-Regular"))
                        ],
                      )
                    ],
                  )
                ],
              )),
        ));
  }
}

class CardItem {
  final String name;
  CardItem({required this.name});
}
