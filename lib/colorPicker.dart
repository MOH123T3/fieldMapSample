import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

@immutable
class ImageColors extends StatefulWidget {
  final Uint8List image;

  ImageColors({super.key, required this.image});

  @override
  State<ImageColors> createState() {
    return _ImageColorsState();
  }
}

class _ImageColorsState extends State<ImageColors> {
  Rect? region;
  Rect? dragRegion;
  Offset? startDrag;
  Offset? currentDrag;

  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  var paletteGenerator;
  List paletteGeneratorList = [];

  var itemBackgroundColor;
  Future<PaletteGenerator> _updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      // Image.asset('assets/i.jpg').image,
      // Image.asset('assets/f.png').image,
      Image.memory(widget.image).image,
      // Image.asset('assets/v.jpeg').image,
      // Image.asset('assets/e.png').image,
    );

    paletteGeneratorList.add(paletteGenerator);

    return paletteGenerator;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PaletteGenerator"),
        ),
        body: FutureBuilder<PaletteGenerator>(
          future: _updatePaletteGenerator(), // async work
          builder:
              (BuildContext context, AsyncSnapshot<PaletteGenerator> snapshot) {
            itemBackgroundColor = snapshot.data?.dominantColor!.color;
            final List<Widget> swatches = <Widget>[];
            final PaletteGenerator? paletteGen = paletteGenerator;
            if (paletteGen == null || paletteGen.colors.isEmpty) {
              return Container();
            }
            for (final Color color in paletteGen.colors) {
              swatches.add(PaletteSwatch(label: "ACC", color: color));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400,
                  width: 200,
                  // child: Image.asset('assets/f.png'),
                  child: Image.memory(widget.image),
                ),
                PaletteSwatch(
                    label: 'A', color: paletteGen.dominantColor?.color),
                PaletteSwatch(
                    label: 'Dominant', color: paletteGen.dominantColor?.color),
                PaletteSwatch(
                    label: 'Light Vibrant',
                    color: paletteGen.lightVibrantColor?.color),
                PaletteSwatch(
                    label: 'Vibrant', color: paletteGen.vibrantColor?.color),
                PaletteSwatch(
                    label: 'Dark Vibrant',
                    color: paletteGen.darkVibrantColor?.color),
                PaletteSwatch(
                    label: 'Light Muted',
                    color: paletteGen.lightMutedColor?.color),
                PaletteSwatch(
                    label: 'Muted', color: paletteGen.mutedColor?.color),
                PaletteSwatch(
                    label: 'Dark Muted',
                    color: paletteGen.darkMutedColor?.color),
              ],
            );
          },
        ));
  }
}

@immutable
class PaletteSwatch extends StatelessWidget {
  const PaletteSwatch({
    super.key,
    this.color,
    this.label,
  });

  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    Widget swatch = Padding(
      padding: const EdgeInsets.all(2.0),
      child: color == null
          ? const Placeholder(
              fallbackWidth: 34.0,
              fallbackHeight: 20.0,
              color: Color.fromARGB(255, 42, 3, 236),
            )
          : Container(
              decoration: BoxDecoration(color: color, border: Border.all()),
              width: 34.0,
              height: 20.0,
            ),
    );

    if (label != null) {
      swatch = ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 130.0, minWidth: 130.0),
        child: Row(
          children: <Widget>[
            swatch,
            Container(width: 5.0),
            Text(label!),
          ],
        ),
      );
    }
    return swatch;
  }
}
