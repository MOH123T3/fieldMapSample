import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_map_demo/polymarkerDemoTwo/animate_camera.dart';
import 'package:google_map_demo/polymarkerDemoTwo/lite_mode.dart';
import 'package:google_map_demo/polymarkerDemoTwo/mapDemo.dart';
import 'package:google_map_demo/polymarkerDemoTwo/map_click.dart';
import 'package:google_map_demo/polymarkerDemoTwo/map_coordinates.dart';
import 'package:google_map_demo/polymarkerDemoTwo/map_ui.dart';
import 'package:google_map_demo/polymarkerDemoTwo/marker_icons.dart';
import 'package:google_map_demo/polymarkerDemoTwo/move_camera.dart';
import 'package:google_map_demo/polymarkerDemoTwo/padding.dart';
import 'package:google_map_demo/polymarkerDemoTwo/page.dart';
import 'package:google_map_demo/polymarkerDemoTwo/place_circle.dart';
import 'package:google_map_demo/polymarkerDemoTwo/place_marker.dart';
import 'package:google_map_demo/polymarkerDemoTwo/place_polygon.dart';
import 'package:google_map_demo/polymarkerDemoTwo/place_polyline.dart';
import 'package:google_map_demo/polymarkerDemoTwo/scrolling_map.dart';
import 'package:google_map_demo/polymarkerDemoTwo/snapshot.dart';
import 'package:google_map_demo/polymarkerDemoTwo/tile_overlay.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

final List<GoogleMapExampleAppPage> _allPages = <GoogleMapExampleAppPage>[
  const MapUiPage(),
  const MapCoordinatesPage(),
  const MapClickPage(),
  const AnimateCameraPage(),
  const MoveCameraPage(),
  const PlaceMarkerPage(),
  const MarkerIconsPage(),
  const ScrollingMapPage(),
  const PlacePolylinePage(),
  const PlacePolygonPage(),
  const PlaceCirclePage(),
  const PaddingPage(),
  const SnapshotPage(),
  const LiteModePage(),
  const TileOverlayPage(),
];

/// MapsDemo is the Main Application.
class MapsDemo extends StatelessWidget {
  /// Default Constructor
  const MapsDemo({Key? key}) : super(key: key);

  void _pushPage(BuildContext context, GoogleMapExampleAppPage page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}
