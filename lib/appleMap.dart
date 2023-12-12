// import 'package:flutter/material.dart';
// import 'package:apple_maps_flutter/apple_maps_flutter.dart';

// class AppleMapsExample extends StatelessWidget {
//   late AppleMapController mapController;

//   void _onMapCreated(AppleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Expanded(
//           child: Container(
//             child: AppleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(0.0, 0.0),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.newCameraPosition(
//                         const CameraPosition(
//                           heading: 270.0,
//                           target: LatLng(51.5160895, -0.1294527),
//                           pitch: 30.0,
//                           zoom: 17,
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text('newCameraPosition'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.newLatLngZoom(
//                         const LatLng(37.4231613, -122.087159),
//                         11.0,
//                       ),
//                     );
//                   },
//                   child: const Text('newLatLngZoom'),
//                 ),
//               ],
//             ),
//             Column(
//               children: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.zoomIn(),
//                     );
//                   },
//                   child: const Text('zoomIn'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.zoomOut(),
//                     );
//                   },
//                   child: const Text('zoomOut'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.zoomTo(16.0),
//                     );
//                   },
//                   child: const Text('zoomTo'),
//                 ),
//               ],
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlatformMap(
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: const LatLng(23.057910588806617, 72.50166803598404),
          zoom: 16.0,
        ),
        markers: Set<Marker>.of(
          [
            Marker(
              markerId: MarkerId('marker_1'),
              position: LatLng(47.6, 8.8796),
              consumeTapEvents: true,
              infoWindow: InfoWindow(
                title: 'PlatformMarker',
                snippet: "Hi I'm a Platform Marker",
              ),
              onTap: () {
                print("Marker tapped");
              },
            ),
          ],
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (location) => print('onTap: $location'),
        onCameraMove: (cameraUpdate) => print('onCameraMove: $cameraUpdate'),
        compassEnabled: true,
        onMapCreated: (controller) {
          Future.delayed(Duration(seconds: 2)).then(
            (_) {
              controller.animateCamera(
                
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    bearing: 270.0,
                    target: LatLng(23.057910588806617, 72.50166803598404),
                    tilt: 30.0,
                    zoom: 18,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
