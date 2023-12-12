// ignore_for_file: use_build_context_synchronously
import 'dart:ui' as ui;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Remake extends StatefulWidget {
  @override
  _RemakeState createState() => _RemakeState();
}

class _RemakeState extends State<Remake> {
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;

  Image _image = Image.network(
    "http://www.shadowsphotography.co/wp-content/uploads/2017/12/photography-01-800x400.jpg",
  );
  Image? _image2;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Container(
      width: size,
      padding: EdgeInsets.only(top: 40.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RepaintBoundary(
              key: previewContainer,
              child: Stack(
                children: <Widget>[_image, Text("data")],
              ),
            ),
            ElevatedButton(
              child: Text('Download'),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                takeScreenShot();
              },
            ),
            _image2 ?? Container(),
          ],
        ),
      ),
    );
  }

  takeScreenShot() async {
    final RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    double pixelRatio = originalSize / MediaQuery.of(context).size.width;
    ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    setState(() {
      _image2 = Image.memory(pngBytes.buffer.asUint8List());
    });
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    final snackBar = SnackBar(
      content: Text('Saved to ${directory}'),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code
        },
      ),
    );

    // Scaffold.of(context).;
  }
}
