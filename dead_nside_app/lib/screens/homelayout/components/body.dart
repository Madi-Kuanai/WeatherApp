import 'dart:convert';
import 'dart:ui';
import 'package:dead_inside_app/Consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../datalayout/DataScreen.dart';
import 'myScrollView.dart' show MyCards;

class MainScreenBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Body();
}

class Body extends State<MainScreenBody> {
  var _city;
  var _country;
  var _temp;
  var _speed_wind;
  var _percend;
  var _idIcon;
  bool inet_exists = false;
  var lon;
  var lat;
  bool flag = false;
  late ConnectivityResult connectivityResult;
  final geolocator = Geolocator()..forceAndroidLocationManager = true;
  late Position _currentPosition;

  void _setInformation() async {
    var status = await Permission.locationAlways.request();
    if (status.isGranted) {
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() async {
          _currentPosition = position;
          print("Current: $_currentPosition");
          print(lat);
          print(lon);
          var _answer;
          var queryParameters = {
            "lat": _currentPosition.latitude.toString(),
            "lon": _currentPosition.longitude.toString(),
            "units": "metric",
            'appid': api
          };
          var req = Uri.https(
              "api.openweathermap.org", "/data/2.5/weather", queryParameters);
          //var req = Uri.parse(
          //    "api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${api}");
          print(req);

          http.Response response = await http.get(req);
          _answer = jsonDecode(response.body);
          print(req);
          print(_answer);
          setState(() {
            _city = _answer["name"];
            _country = _answer["sys"]["country"];
            _temp = _answer["main"]["temp"].round();
            _speed_wind = _answer["wind"]["speed"];
            _percend = _answer["main"]["humidity"];
            _idIcon = _answer["weather"][0]["icon"];
          });
        });
      }).catchError((e) {
        print("MyError: $e");
      });
    } else {}
  }

  @override
  void initState() {
    _checkInet();
    //if (inet_exists) {
    _setInformation();
    //updateDate("New York");
    //}
//    MyCards.initCards();

    super.initState();
  }

  Future<void> _checkInet() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      inet_exists = true;
    } else if (result == ConnectivityResult.mobile) {
      inet_exists = true;
    }
    inet_exists = false;
  }

  void updateDate(String city) async {}

  void getLocalCity() {}

  void onSearch(TextEditingController controller) async {
    if (controller.text != null) {
      var _answer;
      var queryParameters = {
        "q": controller.text,
        "units": "metric",
        'appid': api
      };
      var req = Uri.https(
          "api.openweathermap.org", "/data/2.5/weather", queryParameters);
      print(req);
      http.Response response = await http.get(req);
      _answer = jsonDecode(response.body);
      if (_answer["cod"] == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DataScreen(_answer["name"])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var textFlield = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [whitePurple, Color(0xff8212FC)])),
        child: Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: defPadding - 5, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 10),
                              blurRadius: 50,
                              color: uPrimaryColor.withOpacity(0.5))
                        ]),
                    child: TextField(
                      controller: textFlield,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                          hintText: (_city ?? "Loading...") +
                              " " +
                              (_country ?? "Loading..."),
                          hintStyle: const TextStyle(
                              color: utextColor,
                              fontFamily: "RobotoCondensed-Bold"),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: const Icon(Icons.place_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              onSearch(textFlield);
                            },
                          )),
                    ),
                  )),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.01),
                child: Text(
                  _temp == null ? "Loading... " : _temp.toString() + "℃",
                  style: const TextStyle(
                    fontSize: 50,
                    fontFamily: "Graduate",
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: size.height * 0.01,
                    left: size.height * 0.01,
                    right: size.height * 0.01),
                //color: uBackColor,
                height: size.height * 0.25,
                width: size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _idIcon == null
                        ? Image.asset("assets/images/loading.png")
                        : Image.network(
                            "http://openweathermap.org/img/wn/$_idIcon@2x.png",
                            height: size.height * 0.7,
                            width: size.width * 0.6,
                            fit: BoxFit.contain,
                          ),
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Wind",
                                  style: TextStyle(
                                      color: bTextColor,
                                      fontFamily: "Craduate-Regular",
                                      fontSize: 16),
                                ),
                                Text(
                                  _speed_wind == null
                                      ? "Loading... "
                                      : _speed_wind.toString() + " m/s",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Craduate-Regular",
                                      fontSize: 24),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Humidit",
                                  style: TextStyle(
                                      color: bTextColor,
                                      fontFamily: "Craduate-Regular",
                                      fontSize: 16),
                                ),
                                Text(
                                  _percend == null
                                      ? "Loading... %"
                                      : _percend.toString() + "%",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Craduate-Regular",
                                      fontSize: 25),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              MyScrollView(size),

              //GNavi(size)
            ],
          ),
        ));
  }

  Container GNavi(Size size) {
    return Container(
        height: size.height * 0.08,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Flexible(
            child: GNav(
          rippleColor: Colors.purple.shade300,
          hoverColor: Colors.purple,
          haptic: true,
          tabBorderRadius: 15,
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 300),
          gap: 8,
          color: utextColor,
          iconSize: 24,
          tabBackgroundColor: Color(0xff636DEF),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          tabs: [
            GButton(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.home_filled,
              text: "Home",
            ),
            GButton(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.cloud_queue_outlined,
              text: "Clouds",
            ),
            GButton(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
              icon: Icons.animation_sharp,
              text: "Pages",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7.5),
            ),
          ],
        )));
  }

  Container MyScrollView(Size size) {
    return Container(
      height: size.height * 0.25,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: size.width * 0.05),
            child: const Text(
              "Other City",
              style: TextStyle(
                  fontFamily: "Graduate-Regular",
                  color: utextColor,
                  fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: size.height * 0.20,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return buildCards(index);
                }),
          )
        ],
      ),
    );
  }

  Container buildCards(int index) {
    return Container(
      child: MyCards(index),
    );
  }
}

class CardItem {
  final String name;
  CardItem({required this.name});
}
