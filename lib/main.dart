// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:google_map_demo/colorPicker.dart';
import 'package:google_map_demo/cropImmage.dart';
import 'package:google_map_demo/demo/areaCalculation.dart';
import 'package:google_map_demo/demo/colorFilterGenerator.dart';
import 'package:google_map_demo/demo/mapCalculation.dart';
import 'package:google_map_demo/demo/pickColor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenPolyMore(),
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

  double area = 0.0;
// list of locations to display polylines
  List<LatLng> latLen = [
    // LatLng(23.042539, 72.517414),
    // LatLng(23.042290, 72.517296),
    // LatLng(23.042045, 72.517167),
    // LatLng(23.042193, 72.516792),
    // LatLng(23.042499, 72.516926),
  ];

  List<Point<double>> coordinates = [
    // Point(23.7749, -122.4194), // Example coordinate 1
    // Point(37.7749, -122.3894), // Example coordinate 2
    // Point(37.7549, -122.3894), // Example coordinate 3
    // Point(37.7549, -122.4194),
  ];

  LatLng _initialPosition = LatLng(21.899124, 70.201792);

  _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    _initialPosition = LatLng(21.899124, 70.201792);
    setState(() {});
  }

  GlobalKey previewContainer = new GlobalKey();
  List<List<List<double>>> polygonCoordinates = [];

  List<List<double>> polygonMarker = [];
  Image? _image2;

  final cropController = CropController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //Remove the last point setted at the polygon

          setState(() {
            polygonMarker.removeLast();
            polygonCoordinates.removeLast();
            latLen.removeLast();
          });
          print('polygonCoordinates - ${polygonCoordinates.length}');
          print('latLen - ${latLen.length}');
        },
        icon: Icon(Icons.undo),
        label: Text('Undo point'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: previewContainer,
            child: SizedBox(
              height: 500,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: GoogleMap(
                    onTap: (argument) {
                      coordinates
                          .add(Point(argument.latitude, argument.longitude));
                      polygonMarker
                          .add([argument.latitude, argument.longitude]);
                      polygonCoordinates.add(polygonMarker);

                      print('polygonCoordinates --- $polygonCoordinates');
                      final polygon = GeoJSONPolygon(polygonCoordinates);

                      print('coordinates --- $coordinates');
                      latLen.add(argument);

                      markerAdd();

                      print(
                          'polygonCoordinates - ${polygonCoordinates.length}');
                      print('latLen - ${latLen.length}');
                      setState(() {});
                    },

                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 19,
                    ),
                    mapType: MapType.satellite,
                    markers: _markers,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    // polylines: _polyline,

                    polygons: latLen.isEmpty
                        ? {}
                        : {
                            Polygon(
                                polygonId: PolygonId('1'),
                                points: latLen,
                                strokeWidth: 2,
                                fillColor: Color.fromARGB(255, 65, 160, 244)
                                    .withOpacity(0.2))
                          },

                    // onMapCreated: (GoogleMapController controller) {
                    //   controller.complete(controller);
                    // },
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: Text('Calculate'),
                onPressed: () {},
              ),
              ElevatedButton(
                child: Text('Download'),
                onPressed: () {
                  // double distanceInMeters = Geolocator.;

                  // print('distanceInMeters   -- ${distanceInMeters}  Meters ');

                  // FocusScope.of(context).requestFocus(FocusNode());
                  // takeScreenShot();
                },
              ),
              ElevatedButton(
                child: Text('Clear Marks'),
                onPressed: () {
                  setState(() {
                    coordinates.clear();
                    latLen.clear();
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            child: Text('Crop'),
            onPressed: () {
              area = calculateArea(coordinates);

              setState(() {});
              print('_____________________Area: $area square meters');
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => MapSample()
              //         // CropScreen(image: _image2!)
              // ));
            },
          ),
          Text("Area --- ${area} meter"),
          ImageFilters(
              hue: 0.1, brightness: 0.7, saturation: 0.7, child: _image2),
        ],
      ),
    );
  }

  double calculateArea(List<Point<double>> coordinates) {
    if (coordinates.length < 3) {
      throw ArgumentError('Polygon must have at least 3 vertices');
    }

    double totalArea = 0;

    for (int i = 0; i < coordinates.length; i++) {
      final current = coordinates[i];
      final next = coordinates[(i + 1) % coordinates.length];

      totalArea += radians(next.x - current.x) *
          (2 + sin(radians(current.y)) + sin(radians(next.y)));
    }
    // Earth's radius in meters
    final earthRadius = 6371000.0;

    // Calculate the absolute value and divide by 2 to get the area in square meters
    return (totalArea.abs() * earthRadius * earthRadius) / 2;
  }

  double radians(double degrees) {
    return degrees * pi / 180.0;
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

      // print('latLen - ${latLen[i]} ,,  ${polygonCoordinates}');
    }
  }

  takeScreenShot() async {
    final RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    double pixelRatio = 200 / MediaQuery.of(context).size.width;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    setState(() {
      _image2 = Image.memory(pngBytes.buffer.asUint8List());
    });
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);

    print('Saved to ${directory}');

    // _dialogBuilder(context, cropController, pngBytes);
  }

  Future<void> _dialogBuilder(BuildContext context, cropController, _image2) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: SizedBox(
            height: 200,
            child: DynamicImageCrop(
              imageByteFormat: ui.ImageByteFormat.png,
              controller: cropController,
              image: _image2, // Uint8List
              onResult: (image, width, height) {
                // cropped Image (Uint8List), width and height
              },
              cropLineColor: Colors.red, // (Optional)
              cropLineWidth: 1.0, // (Optional)
            ),
          ),
          actions: <Widget>[
            ImageFilters(
                hue: 0.1,
                brightness: 0.6,
                saturation: 0.5,
                child: Container(
                    height: 320,
                    width: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: AssetImage("assets/e.png")),
                    ))),
            // SizedBox(
            //   height: 200,
            //   child: DynamicImageCrop(
            //     controller: cropController,
            //     image: _image2, // Uint8List
            //     onResult: (image, width, height) {
            //       // cropped Image (Uint8List), width and height
            //     },
            //     cropLineColor: Colors.red, // (Optional)
            //     cropLineWidth: 1.0, // (Optional)
            //   ),
            // ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
