// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

temperatureChart(temperature, date) {
  print('temperature- - ${date}');

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
          plotAreaBorderWidth: 0,
          borderWidth: 0,
          legend: Legend(isVisible: false),
          zoomPanBehavior: ZoomPanBehavior(
            enableMouseWheelZooming: false,
            zoomMode: ZoomMode.xy,
            enableDoubleTapZooming: true,
            enablePinching: true,
            enableSelectionZooming: true,
          ),
          plotAreaBackgroundColor: Colors.green,
          primaryXAxis: CategoryAxis(borderColor: Colors.green, borderWidth: 0),
          series: <LineSeries<WeatherData, String>>[
            LineSeries<WeatherData, String>(
                markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.black,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red),
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: <WeatherData>[
                  WeatherData(date[0], double.parse(temperature[0])),
                  WeatherData(date[1], double.parse(temperature[1])),
                  WeatherData(date[2], double.parse(temperature[2])),
                ],
                xValueMapper: (WeatherData sales, _) => sales.date,
                yValueMapper: (WeatherData sales, _) => sales.temp)
          ]));
}

class WeatherData {
  WeatherData(this.date, this.temp);
  final String date;
  final double temp;
}
