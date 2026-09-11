import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/building_polygons.dart';
import '../screenUtils/drawer.dart';

class OutdoorMapScreen extends StatefulWidget {
  const OutdoorMapScreen({super.key});

  @override
  State<OutdoorMapScreen> createState() => _OutdoorMapScreenState();
}

class _OutdoorMapScreenState extends State<OutdoorMapScreen> {
  double _overlayOpacity = 0.0;
  final MapController mapController = MapController();
  bool _mapReady = false;

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

  @override
  Widget build(BuildContext context) {
    final LatLng siueCenter = const LatLng(38.7964, -89.9970);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIUE Campus Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              if (_mapReady) {
                mapController.rotate(0.0);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Map rotation reset to North.'),
                  ),
                );
              }
            },
          ),
          IconButton(onPressed: () async {
            final TextEditingController searchController = TextEditingController();

            final String? buildingName = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Search for a building'),
                  content: SizedBox(
                    width: 300,
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return buildingPolygons.keys.where((String option) {
                          return option.toLowerCase().contains(
                                textEditingValue.text.toLowerCase(),
                              );
                        });
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        searchController.text = fieldTextEditingController.text;
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter building name',
                          ),
                        );
                      },
                      onSelected: (String selection) {
                        searchController.text = selection;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(searchController.text);
                      },
                      child: const Text('Search'),
                    ),
                  ],
                );
              },
            );

            if (buildingName != null && buildingName.isNotEmpty) {
              final buildingPolygon = buildingPolygons[buildingName.toLowerCase()];
              if (buildingPolygon != null) {
                final bounds = boundsFromPolygon(buildingPolygon);
                mapController.move(bounds.center, 18);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Building "$buildingName" not found.'),
                  ),
                );
              }
            }
          }, icon: Icon(Icons.search))
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 28.0),
      ),
      drawer: MapDrawer(
        mapController: mapController,
        mapReady: _mapReady,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: siueCenter,
          initialZoom: 17,
          maxZoom: 22,
          onMapReady: () {
            _mapReady = true;
          },
          onPositionChanged: (camera, hasGesture) {
            final zoom = camera.zoom;

            double newOpacity = ((zoom - 18) / (19 - 18)).clamp(0.0, 1.0);

            setState(() {
              _overlayOpacity = newOpacity;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.campus_map',
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: engineeringBuildingPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: peckHallPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: libraryPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: scienceEastPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: scienceWestPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: dunhamHallPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: artDesignWestPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: artDesignEastPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: mucPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: sscPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: rendlemanHallPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: foundersHallPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: alumniHallPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: fitnessPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: vadalabenePolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: religiousPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: eccPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: metcalfPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: ertcPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: technologyPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: uniParkAdminPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: uniPark195Polygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: uniPark200Polygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: uniPark220Polygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: biotechnologyPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
              Polygon(
                points: ethanolPlantPolygon,
                color: Colors.blue.withValues(alpha: 0.3),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
            ],
          ),

          OverlayImageLayer(
            overlayImages: [
              OverlayImage(
                bounds: boundsFromPolygon(engineeringBuildingPolygon),
                imageProvider: const AssetImage(
                  'assets/engineering_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(peckHallPolygon),
                imageProvider: const AssetImage('assets/peckhall_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(libraryPolygon),
                imageProvider: const AssetImage('assets/library_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(scienceEastPolygon),
                imageProvider: const AssetImage(
                  'assets/science_east_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(scienceWestPolygon),
                imageProvider: const AssetImage(
                  'assets/science_west_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(dunhamHallPolygon),
                imageProvider: const AssetImage('assets/dunhamhall_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(artDesignWestPolygon),
                imageProvider: const AssetImage(
                  'assets/art_design_west_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(artDesignEastPolygon),
                imageProvider: const AssetImage(
                  'assets/art_design_east_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(mucPolygon),
                imageProvider: const AssetImage('assets/muc_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(sscPolygon),
                imageProvider: const AssetImage('assets/ssc_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(rendlemanHallPolygon),
                imageProvider: const AssetImage(
                  'assets/rendlemanhall_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(foundersHallPolygon),
                imageProvider: const AssetImage(
                  'assets/foundershall_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(alumniHallPolygon),
                imageProvider: const AssetImage('assets/alumnihall_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(fitnessPolygon),
                imageProvider: const AssetImage('assets/fitness_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(vadalabenePolygon),
                imageProvider: const AssetImage('assets/vadalabene_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(religiousPolygon),
                imageProvider: const AssetImage('assets/religious_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(eccPolygon),
                imageProvider: const AssetImage('assets/ecc_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(metcalfPolygon),
                imageProvider: const AssetImage('assets/metcalf_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(ertcPolygon),
                imageProvider: const AssetImage('assets/ertc_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(technologyPolygon),
                imageProvider: const AssetImage('assets/technology_floor1.png'),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(uniParkAdminPolygon),
                imageProvider: const AssetImage(
                  'assets/uni_park_admin_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(uniPark195Polygon),
                imageProvider: const AssetImage(
                  'assets/uni_park_195_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(uniPark200Polygon),
                imageProvider: const AssetImage(
                  'assets/uni_park_200_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(uniPark220Polygon),
                imageProvider: const AssetImage(
                  'assets/uni_park_220_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(biotechnologyPolygon),
                imageProvider: const AssetImage(
                  'assets/biotechnology_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
              OverlayImage(
                bounds: boundsFromPolygon(ethanolPlantPolygon),
                imageProvider: const AssetImage(
                  'assets/ethanol_plant_floor1.png',
                ),
                opacity: _overlayOpacity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
