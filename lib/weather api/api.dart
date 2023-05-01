import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class api extends StatefulWidget {
  const api({super.key});

  @override
  State<api> createState() => _apiState();
}

class _apiState extends State<api> {
  @override
  // Map<String, dynamic> weatherData = {};
  // List<dynamic> weatherData = [];
  String city = "";
  String temp = "";
  String precepProb = "";

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Stream.fromFuture(fetchWeather()),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // dynamic json2 = () async => jsonDecode((await http.get(Uri.parse(snapshot.data["properties"]["forecastHourly"]))).body);
          if (snapshot.hasData) {
            Future<void> idk() async {
              dynamic uri2 =
                  Uri.parse(snapshot.data["properties"]["forecastHourly"]);
              dynamic response2 = await http.get(uri2);
              dynamic json2 = jsonDecode(response2.body);
              return json2;
            }

            // return Text((Stream.fromFuture(idk())).toString());
            return StreamBuilder(
                stream: Stream.fromFuture(idk()),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                  if (snapshot2.hasData) {
                    return Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 61,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 13),
                          child: Text(
                            snapshot.data["properties"]["relativeLocation"]
                                ["properties"]["city"],
                            style: TextStyle(fontSize: 55),
                          ),
                        ),
                        Container(
                          child: Text(snapshot2.data["properties"]["periods"][0]["temperature"].toString()),
                        )
                      ],
                    );
                  } else if (snapshot2.hasError) {
                    return Center(
                      child: Text("ERROR"),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "ERROR",
                style: TextStyle(fontSize: 50),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> fetchWeather() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("location serivce not enabled")));
      return;
    }

    // Check if we have permission to access location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Permission has not been granted, request permission
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission has not been granted
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Permission not granted")));
        return;
      }
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String lat = position.latitude.toString();
    String long = position.longitude.toString();
    // dynamic uri = Uri.parse("https://api.weather.gov/points/29.7388,-95.758");
    dynamic uri =
        Uri.parse("https://api.weather.gov/points/" + lat + "," + long);
    dynamic response = await http.get(uri);
    dynamic json = jsonDecode(response.body);
    return json;
  }
}
