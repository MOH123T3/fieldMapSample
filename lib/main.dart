// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_map_demo/colorPicker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // on below line we are specifying title of our app
      title: 'GFG',
      // on below line we are hiding debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // on below line we are specifying theme
        primarySwatch: Colors.green,
      ),
      // First screen of our app
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// created controller to display Google Maps
  Completer<GoogleMapController> controller = Completer();
//on below line we have set the camera position

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

// list of locations to display polylines
  List<LatLng> latLen = [
    // LatLng(23.042539, 72.517414),
    // LatLng(23.042290, 72.517296),
    // LatLng(23.042045, 72.517167),
    // LatLng(23.042193, 72.516792),
    // LatLng(23.042499, 72.516926),
  ];

  LatLng? _initialPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    print(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   object  - ${position}');
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ImageColors()));
      }),
      body: SafeArea(
        child: GoogleMap(
          onTap: (argument) {
            latLen.add(argument);

            markerAdd();
            setState(() {});
            print("argument--- $argument");
          },
          onLongPress: (argument) {
            if (latLen.contains(argument)) {
              latLen.remove(argument);
            }
            print("latLen -- $latLen");

            setState(() {});
          },
          initialCameraPosition: CameraPosition(
            target: _initialPosition!,
            zoom: 19,
          ),
          mapType: MapType.satellite,
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          polylines: _polyline,
          // polygons: {
          //   Polygon(
          //       polygonId: PolygonId('1'),
          //       points: latLen,
          //       strokeWidth: 2,
          //       fillColor: Color.fromARGB(255, 65, 160, 244).withOpacity(0.2))
          // },
          // onMapCreated: (GoogleMapController controller) {
          //   controller.complete(controller);
          // },
        ),
      ),
    );
  }

  markerAdd() {
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: InfoWindow(
          title: 'HOTEL',
          snippet: '5 Star Hotel',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
      ));

      print('latLen - ${latLen[i]}');
    }
  }
}
