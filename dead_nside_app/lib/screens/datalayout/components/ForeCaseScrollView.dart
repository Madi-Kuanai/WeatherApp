import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dead_inside_app/Consts.dart';
import 'package:flutter/material.dart';

class ForeCaseItem extends StatefulWidget {
  late int _index;
  late var cityname;
  ForeCaseItem(int index, cityname) {
    this._index = index;
    this.cityname = cityname;
  }

  @override
  State<ForeCaseItem> createState() =>
      _ForeCaseItemState(index: _index.toInt(), cityname: cityname);
}

class _ForeCaseItemState extends State<ForeCaseItem> {
  var num_of_card;
  var _time = "...";
  var _day = "...";
  var _month = "...";
  var _temp;
  var _icon;
  var _humidit;
  var cityname;
  var _desc;
  _ForeCaseItemState({index, cityname}) {
    this.num_of_card = index;
    this.cityname = cityname;
  }

  @override
  void initState() {
    super.initState();
    getData(cityname);
  }

  void getData(name) async {
    var queryParameters = {"q": name, "units": "metric", "appid": api};
    var req = Uri.https(
        "api.openweathermap.org", "/data/2.5/forecast", queryParameters);
    http.Response response = await http.get(req);

    var _answer = jsonDecode(response.body);
  
    if (mounted) {
      setState(() {
        this._temp = _answer["list"][num_of_card]["main"]["temp"].round();
        this._humidit = _answer["list"][num_of_card]["main"]["humidity"];
        this._icon = _answer["list"][num_of_card]["weather"][0]["icon"];
        this._time = _answer["list"][num_of_card]["dt_txt"]
            .toString()
            .split(" ")[1]
            .substring(0, 5);
        this._day = _answer["list"][num_of_card]["dt_txt"]
            .toString()
            .split(" ")[0]
            .toString()
            .split("-")[2]
            .toString();
        this._month = months[int.parse(_answer["list"][num_of_card]["dt_txt"]
            .toString()
            .split(" ")[0]
            .toString()
            .split("-")[1])];
        _desc = _answer["list"][num_of_card]["weather"][0]["description"];
      });
    }
  
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      width: size.width * 0.4,
      height: size.height * 0.65,
      margin:
          EdgeInsets.only(top: size.width * 0.05, right: size.width * 0.025),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: const Color(0xff383749)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: (_icon != null
                  ? Image.network(
                      "http://openweathermap.org/img/wn/$_icon@2x.png",
                      width: size.width * 0.2,
                    )
                  : Image.asset(
                      "assets/images/empty1.png",
                      width: size.width * 0.2,
                    ))),
                    Text(_desc ?? "...", style: const TextStyle(fontFamily: "Graduate-Regular", fontSize: 13, color: Colors.white),),
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: const Divider(
                color: Color(0xff807EA3),
              )),
          Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              alignment: Alignment.centerLeft,
              child: Text(
                _temp != null ? _temp.toString() + celsuim : "...",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: "Graduate-Regular"),
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            alignment: Alignment.center,
            child: Row(
              children: [
                Row(children: [
                  Container(
                margin: EdgeInsets.only(right: size.width * 0.01),
                child: Text(
                  _day.toString(),
                  style: const TextStyle(
                      fontFamily: "Graduate-Regular", fontSize: 14),
                ),
                  ),
                  Text(
                _month.toString(),
                style: const TextStyle(
                    fontFamily: "Graduate-Regular", fontSize: 14),
                  )
                ]),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                    child: const Text(
                      "|",
                      style: TextStyle(fontSize: 20),
                    )),
                Text(
                  _time,
                  style: const TextStyle(
                      fontFamily: "Graduate-Regular", fontSize: 14),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
