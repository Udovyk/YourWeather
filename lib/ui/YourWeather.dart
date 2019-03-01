import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class YourWeather extends StatefulWidget {
  @override
  _YourWeatherState createState() => _YourWeatherState();
}

class _YourWeatherState extends State<YourWeather> {
  String _cityEntered;

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  Future _goToNext(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) {
      return CityName();
    }));

    if (results != null && results.isNotEmpty && results.containsKey('enter')) {
      _cityEntered = results['enter'].toString();
      print(results['enter'].toString());
    } else {
      print('results null or empty');
    }
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
            onPressed: () {
              _goToNext(context);
            },
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
            child: Text(
                "${_cityEntered == null ? util.defaultCity : _cityEntered}",
                style: _cityStyle()),
          ),

          //weather icon
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
              alignment: Alignment.topCenter,
              //margin: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
              child: Image.asset(
                "images/rain_ic.png",
                width: 150.0,
                height: 150.0,
              )),

          //Container for weather data
          updateTempWidget(_cityEntered)
          /*Container(

              margin: const EdgeInsets.only(top: 350.0, left: 50.0),
              child: updateTempWidget(_cityEntered)),*/
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
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            margin: const EdgeInsets.only(top: 150.0, left: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    content['main']['temp'].toString() + " C",
                    style: _tempStyle(),
                  ),
                  subtitle: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    title: Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()+ " C"}\n"
                          "Max: ${content['main']['temp_max'].toString()+ " C"}",
                      style: _extraStyle(),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class CityName extends StatelessWidget {
  var _cityFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text(
            "Change City",
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.white70,
            ),
            //background
            /*Image.asset(
              'images/rain.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            )),*/
            //edittext field
            ListView(
              children: <Widget>[
                ListTile(
                  title: TextField(
                    decoration: InputDecoration(hintText: 'enter city'),
                    controller: _cityFieldController,
                    keyboardType: TextInputType.text,
                  ),
                ),
                ListTile(
                  title: FlatButton(
                      onPressed: () {
                        Navigator.pop(
                            context, {'enter': _cityFieldController.text});
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white70,
                      child: Text('Get weather')),
                )
              ],
            )
          ],
        ));
  }
}

//styles
TextStyle _cityStyle() {
  return TextStyle(
      color: Colors.black, fontSize: 30.0, fontStyle: FontStyle.italic);
}

TextStyle _extraStyle() {
  return TextStyle(
      color: Colors.white70, fontSize: 17.0);
}

TextStyle _tempStyle() {
  return TextStyle(
      color: Colors.white, fontSize: 40.0, fontStyle: FontStyle.italic);
}
