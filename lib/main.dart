import 'package:flutter/material.dart';
// import 'api1/api.dart';
// import 'api2/api.dart';
import 'weather api/api.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: api(),
    ),
  );
}
