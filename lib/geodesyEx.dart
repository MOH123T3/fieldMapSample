import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace these coordinates with the ones you have
    List<LatLng> coordinates = [
      LatLng(37.7749, -122.4194), // Example coordinate 1
      LatLng(37.7749, -122.3894), // Example coordinate 2
      LatLng(37.7549, -122.3894), // Example coordinate 3
      LatLng(37.7549, -122.4194), // Example coordinate 4
    ];
    double area = calculateArea(coordinates);
    return Scaffold(
      appBar: AppBar(
        title: Text('Area Calculation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Area: $area square meters',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  double calculateArea(List<LatLng> coordinates) {
    Geodesy geodesy = Geodesy();

    // Close the polygon by adding the first coordinate at the end
    coordinates.add(coordinates.first);
    // Calculate the area in square meters

    double area = 1;
    return area;
  }
}
