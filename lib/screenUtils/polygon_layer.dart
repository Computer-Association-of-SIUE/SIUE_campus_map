import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';

class PolygonBuilder extends StatelessWidget {
  const PolygonBuilder({
    super.key,
    required this.buildingPolygons,
    required this.boundsFromPolygon,
  });

  final Map<String, List<LatLng>> buildingPolygons;
  final flutter_map.LatLngBounds Function(List<LatLng>) boundsFromPolygon;

  flutter_map.LatLngBounds boundsFor(String buildingName) {
    return boundsFromPolygon(buildingPolygons[buildingName]!);
  }

  @override
  Widget build(BuildContext context) {
    return flutter_map.PolygonLayer(
      polygons: buildingPolygons.values
          .map(
            (points) => flutter_map.Polygon(
              points: points,
              color: Colors.blue.withValues(alpha: 0.3),
              borderColor: Colors.blue,
              borderStrokeWidth: 3,
            ),
          )
          .toList(),
    );
  }
}