import 'package:flutter/material.dart';
import 'package:google_map_demo/main.dart';
import 'package:google_map_demo/polymaker/core/models/trackingmode.dart';
import 'package:google_map_demo/polymarkerDemoTwo/mapDemo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_demo/polymaker/polymaker.dart' as polymaker;

class HomeScreenPolyMore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PolyMaker Demo"),
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<LatLng>? locationList;
  void getLocation() async {
    var result = await polymaker.getLocation(context,
        trackingMode: TrackingMode.LINEAR, enableDragMarker: true);
    if (result != null) {
      setState(() {
        locationList = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    locationList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Location Result: \n" +
                (locationList != null
                    ? locationList!
                        .map((val) => "[${val.latitude}, ${val.longitude}]\n")
                        .toString()
                    : ""),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Container(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => getLocation(),
              child: Text(
                "Get Polygon Location",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return HomePage();
              })),
              child: Text(
                "2",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MapsDemo();
              })),
              child: Text(
                "User Interface",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
