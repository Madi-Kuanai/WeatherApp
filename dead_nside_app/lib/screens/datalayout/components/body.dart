import 'dart:convert';
import 'package:dead_inside_app/Consts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ForeCaseScrollView.dart';

class SearchedPage extends StatefulWidget {
  late String _city;
  SearchedPage(name) {
    _city = name;
  }
  @override
  State<StatefulWidget> createState() => SearchedState(_city);
}

class SearchedState extends State<SearchedPage> {
  var _cityName;
  var _country;
  var _temp;
  var _wind;
  var _idIcon;
  var _percent;
  var _description;
  var _len;
  SearchedState(name) {
    _cityName = name;
  }

  @override
  void initState() {
    super.initState();
    getData();
    getLength();
  }

  Future<void> getData() async {
    try {
      var _answer;
      var queryParameters = {"q": _cityName, "units": "metric", 'appid': api};
      var req = Uri.https(
          "api.openweathermap.org", "/data/2.5/weather", queryParameters);
      print(req);
      http.Response response = await http.get(req);
      _answer = jsonDecode(response.body);
      setState(() {
        _country = _answer["sys"]["country"];
        _temp = _answer["main"]["temp"].round();
        _wind = _answer["wind"]["speed"];
        _percent = _answer["main"]["humidity"];
        _idIcon = _answer["weather"][0]["icon"];
        _description = _answer["weather"][0]["description"];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getLength() async {
    var queryParameters = {"q": _cityName, "units": "metric", "appid": api};
    var req = Uri.https(
        "api.openweathermap.org", "/data/2.5/forecast", queryParameters);
    http.Response response = await http.get(req);

    var _answer = jsonDecode(response.body);
    setState(() {
      _len = _answer["list"].length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              height: size.height * 0.25,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [whitePurple, blackPurple])),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                        margin: EdgeInsets.only(
                            left: size.width * 0.1, top: size.width * 0.075),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _cityName,
                              style: const TextStyle(
                                  fontFamily: "Graduate-Regular", fontSize: 30),
                            ),
                            Text(_country ?? "...",
                                style: const TextStyle(
                                    fontFamily: "Graduate-Regular",
                                    fontSize: 20)),
                            Container(
                                margin:
                                    EdgeInsets.only(top: size.height * 0.02),
                                child: Text(
                                  _temp == null
                                      ? "0" + celsuim
                                      : _temp.toString() + celsuim,
                                  style: const TextStyle(
                                      fontFamily: "Graduate-Regular",
                                      fontSize: 40,
                                      color: Colors.white),
                                ))
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
//                        margin: EdgeInsets.all(size.width * 0.05),
//                        alignment: Alignment.topRight,
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _idIcon == null
                            ? Image.asset("assets/images/empty.png")
                            : Image.network(
                                "http://openweathermap.org/img/wn/$_idIcon@2x.png",
                                //height: size.height * 0.3,
                                //width: size.width * 0.3,
                                fit: BoxFit.contain,
                              ),
                        Text(_description ?? "...",
                            style: const TextStyle(
                                fontFamily: "Graduate-Regular", fontSize: 16)),
                      ],
                    )),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(
                  top: size.height * 0.05, left: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Forecase",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "RobotoCondensed-bold",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: size.height * 0.25,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _len ?? 3,
                        itemBuilder: (context, index) {
                          return buildCards(index, _cityName);
                        }),
                  ),
                  
                ],
              ),
            )
          ],
        ));
  }

  Container buildCards(int index, cityname) {
    return Container(
      child: ForeCaseItem(index, cityname),
    );
  }
}
