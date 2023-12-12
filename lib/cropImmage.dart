// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';
import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:flutter/cupertino.dart';
// import 'package:bitmap/bitmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map_demo/colorPicker.dart';
import 'package:google_map_demo/demo/colorFilterGenerator.dart';

// ignore: must_be_immutable
class CropScreen extends StatefulWidget {
  Image image;
  CropScreen({super.key, required this.image});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  CropType cropType = CropType.none;

  Uint8List? image;
  final cropController = CropController();
  final urlController = TextEditingController();

  final initialUrl = 'https://miro.medium.com/v2/1*bzC0ul7jBVhOJiastVGKlw.png';
  // Bitmap? bitmap;
  // Not async

  @override
  void initState() {
    loadImage(widget.image);
    super.initState();
  }

  Uint8List? headedBitmap;
  void loadImage(
    Image images, {
    void Function(Uint8List)? callback,
    ImageByteFormat imageFormat = ImageByteFormat.png,
  }) {
    print('images -- $images');
    // Network image to Uint8List
    var img;

    if (images == null) {
      img = Image.network(initialUrl);
    } else {
      img = images;
    }

    print('img -- $img');

    img.image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) async {
        try {
          final byteData = await info.image.toByteData(format: imageFormat);
          setState(() {
            image = byteData!.buffer.asUint8List();
            if (image != null) {
              callback?.call(image!);
            }
          });
        } catch (e) {
          debugPrint('try another image byte format: $e');
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (image == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: ImageFilters(
                      hue: 0.1,
                      brightness: 0.7,
                      saturation: 0.7,
                      child: DynamicImageCrop(
                        controller: cropController,
                        image: image!,
                        onResult: (image, width, height) {
                          sendResultImage(image, context);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: buildButtons(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: cropController.cropImage,
          icon: const Icon(Icons.save, color: Colors.yellow),
        ),
        // const SizedBox(width: 8),
        IconButton(
          onPressed: () => changeShape(CropType.drawing),
          icon: const Icon(CupertinoIcons.pencil_outline, color: Colors.yellow),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: cropController.clearCropArea,
          icon: const Icon(
            CupertinoIcons.clear_circled_solid,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  void changeShape(CropType type) {
    cropController.changeType(type);
  }

  void sendResultImage(
    Uint8List? bytes,
    BuildContext context,
  ) {
    if (bytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => ImageColors(
            image: bytes,
          ),
        ),
      );
    }
  }
}
