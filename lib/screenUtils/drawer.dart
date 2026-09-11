import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:campus_map/data/building_polygons.dart';

class MapDrawer extends StatelessWidget {
  final MapController mapController;
  final bool mapReady;
  LatLngBounds boundsFromPolygon(List<LatLng> polygon) {
    final minLat = polygon
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    final maxLat = polygon
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    final minLng = polygon
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    final maxLng = polygon
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);
    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  const MapDrawer({
    super.key,
    required this.mapController,
    required this.mapReady,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: const DrawerHeader(
                child: Text(
                  'Building Select',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Back to map"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Engineering Building"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.rotate(0.0);
                  mapController.move(
                    boundsFromPolygon(engineeringBuildingPolygon).center,
                    18,
                  );
                }
              },
            ),
            ListTile(
              title: const Text("Peck Hall"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.rotate(0.0);
                  mapController.move(
                    boundsFromPolygon(peckHallPolygon).center,
                    18,
                  );
                }
              },
            ),
            ListTile(
              title: const Text("Library"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.rotate(0.0);
                  mapController.move(
                    boundsFromPolygon(libraryPolygon).center,
                    18,
                  );
                }
              },
            ),
            ListTile(
              title: const Text("Science East"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.rotate(0.0);
                  mapController.move(
                    boundsFromPolygon(scienceEastPolygon).center,
                    18,
                  );
                }
              },
            ),
            ListTile(
              title: const Text("Science West"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(scienceWestPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Dunham Hall"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(dunhamHallPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Art & Design West"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(artDesignWestPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Art & Design East"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(artDesignEastPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("MUC"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(boundsFromPolygon(mucPolygon).center, 18);
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Student Success Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(boundsFromPolygon(sscPolygon).center, 18);
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Rendleman Hall"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(rendlemanHallPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Founders Hall"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(foundersHallPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Alumni Hall"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(alumniHallPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Fitness Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(fitnessPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Vadalabene Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(vadalabenePolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Religious Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(religiousPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Early Childhood Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(boundsFromPolygon(eccPolygon).center, 18);
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Metcalf School"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(metcalfPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Environmental Resources Training Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(boundsFromPolygon(ertcPolygon).center, 18);
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Technology Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(technologyPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("University Park Admin"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(uniParkAdminPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("University Park 195"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(uniPark195Polygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("University Park 200"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(uniPark200Polygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("University Park 220"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(uniPark220Polygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Biotechnology Center"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(biotechnologyPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              title: const Text("Ethanol Plant"),
              onTap: () {
                Navigator.pop(context);
                if (mapReady) {
                  mapController.move(
                    boundsFromPolygon(ethanolPlantPolygon).center,
                    18,
                  );
                  mapController.rotate(0.0);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Close"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
    );
  }
}