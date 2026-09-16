import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder({
    super.key,
    required this.buildingPolygons,
    required this.boundsFromPolygon,
    required this.opacity,
    required this.floorNumber,
  });

  final Map<String, List<LatLng>> buildingPolygons;
  final flutter_map.LatLngBounds Function(List<LatLng>) boundsFromPolygon;
  final double opacity;
  final int floorNumber;

  @override
  State<OverlayBuilder> createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  late Future<List<flutter_map.OverlayImage>> _overlayImages;

  @override
  void initState() {
    super.initState();
    _overlayImages = _loadOverlayImages();
  }

  @override
  void didUpdateWidget(covariant OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floorNumber != widget.floorNumber ||
        oldWidget.opacity != widget.opacity ||
        oldWidget.buildingPolygons != widget.buildingPolygons) {
      _overlayImages = _loadOverlayImages();
    }
  }

  Future<List<flutter_map.OverlayImage>> _loadOverlayImages() async {
    final images = <flutter_map.OverlayImage>[];

    for (final entry in widget.buildingPolygons.entries) {
      final assetPath =
          'assets/images/${entry.key}/${widget.floorNumber}.png';

      try {
        await rootBundle.load(assetPath);
      } on FlutterError {
        continue;
      }

      images.add(
        flutter_map.OverlayImage(
          bounds: widget.boundsFromPolygon(entry.value),
          opacity: widget.opacity,
          imageProvider: AssetImage(assetPath),
        ),
      );
    }

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<flutter_map.OverlayImage>>(
      future: _overlayImages,
      builder: (context, snapshot) {
        final images = snapshot.data;
        if (images == null || images.isEmpty) {
          return const SizedBox.shrink();
        }

        return flutter_map.OverlayImageLayer(overlayImages: images);
      },
    );
  }
}