import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class YourWeather extends StatefulWidget {
  @override
  _YourWeatherState createState() => _YourWeatherState();
}

class _YourWeatherState extends State<YourWeather> {
  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Weather"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: showStuff,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          //weather background
          Center(
            child: Image.asset(
              'images/rain.jpg',
              height: 1200.0,
              width: 490.0,
              fit: BoxFit.fill,
            ),
          ),

          //city name
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
            child: Text("Chaplinka", style: _cityStyle()),
          ),

          //weather icon
          Container(
              alignment: Alignment.center,
              //margin: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
              child: Image.asset(
                "images/rain_ic.png",
                width: 150.0,
                height: 150.0,
              )),

          //Container for weather data
          Container(
              margin: const EdgeInsets.only(top: 350.0, left: 50.0),
              child: updateTempWidget("Chaplinka")),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String cityName) async {
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$appId&units=metric';
    http.Response response = await http.get(url);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.appId, city),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                        content['main']['temp'].toString(),
                        style: _tempStyle(),
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }
}

//styles
TextStyle _cityStyle() {
  return TextStyle(
      color: Colors.black, fontSize: 30.0, fontStyle: FontStyle.italic);
}

TextStyle _tempStyle() {
  return TextStyle(
      color: Colors.white, fontSize: 40.0, fontStyle: FontStyle.italic);
}
