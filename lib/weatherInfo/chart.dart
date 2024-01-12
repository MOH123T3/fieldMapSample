// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

temperatureChart() {
  return Container(
      padding: EdgeInsets.only(bottom: 1.w, top: 4.w, left: 2.w, right: 2.w),
      margin: EdgeInsets.only(left: 2.w, right: 2.w),
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(blurRadius: 0.1, blurStyle: BlurStyle.solid)
        ],
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green,
            Colors.white,
          ],
        ),
      ),
      child: SfCartesianChart(
          plotAreaBackgroundColor: Colors.green,
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<WeatherData, String>>[
            LineSeries<WeatherData, String>(
                // Bind data source
                dataSource: <WeatherData>[
                  WeatherData('Jan', 35),
                  WeatherData('Feb', 28),
                  WeatherData('Mar', 34),
                  WeatherData('Apr', 32),
                  WeatherData('May', 40)
                ],
                xValueMapper: (WeatherData sales, _) => sales.year,
                yValueMapper: (WeatherData sales, _) => sales.sales)
          ]));
}

class WeatherData {
  WeatherData(this.year, this.sales);
  final String year;
  final double sales;
}
