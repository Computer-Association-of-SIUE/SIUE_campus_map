import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../data/building_polygons.dart';
import '../screenUtils/drawer.dart';
import "../utils/geo_locator.dart";
import '../screenUtils/polygon_layer.dart';
import '../screenUtils/overlay_layer.dart';

class OutdoorMapScreen extends StatefulWidget {
  const OutdoorMapScreen({super.key});

  @override
  State<OutdoorMapScreen> createState() => _OutdoorMapScreenState();
}

class _OutdoorMapScreenState extends State<OutdoorMapScreen> {
  double _overlayOpacity = 0.0;
  int floorNumber = 1;
  final MapController mapController = MapController();
  bool _mapReady = false;
  bool _locationFocused = true;
  bool _changingFloor = false;

  final Stream<Position> _positionStream = LocationService.getCurrentLocation();
  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _positionSubscription = _positionStream.listen((Position position) {
      if (!mounted) {
        return;
      }

      setState(() {
        _currentPosition = position;
      });

      if (_mapReady && _locationFocused) {
        mapController.move(
          LatLng(position.latitude, position.longitude),
          mapController.camera.zoom,
        );
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    mapController.dispose();
    super.dispose();
  }

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
            tooltip: _locationFocused
                ? 'Stop following location'
                : 'Follow location',
            icon: Icon(
              _locationFocused ? Icons.my_location : Icons.location_searching,
            ),
            onPressed: () {
              final shouldFollow = !_locationFocused;
              setState(() {
                _locationFocused = shouldFollow;
              });

              if (shouldFollow && _mapReady && _currentPosition != null) {
                mapController.move(
                  LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  mapController.camera.zoom,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              if (_mapReady) {
                mapController.rotate(0.0);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Map rotation reset to North.')),
                );
              }
            },
          ),
          IconButton(
            onPressed: () async {
              _locationFocused = false;
              final TextEditingController searchController =
                  TextEditingController();

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
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              searchController.text =
                                  fieldTextEditingController.text;
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
                final buildingPolygon =
                    buildingPolygons[buildingName.toLowerCase()];
                if (buildingPolygon != null) {
                  final bounds = boundsFromPolygon(buildingPolygon);
                  mapController.move(bounds.center, 18);
                }
              }
            },
            icon: Icon(Icons.search),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 28.0),
      ),
      drawer: MapDrawer(mapController: mapController, mapReady: _mapReady),
      body: Stack(
        children: [
          FlutterMap(
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

                if (hasGesture &&
                    _locationFocused &&
                    _currentPosition != null) {
                  final location = LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  );
                  final distanceFromLocation = const Distance().as(
                    LengthUnit.Meter,
                    camera.center,
                    location,
                  );

                  if (distanceFromLocation > 20) {
                    _locationFocused = false;
                  }
                }

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
              PolygonBuilder(
                buildingPolygons: buildingPolygons,
                boundsFromPolygon: boundsFromPolygon,
              ),
              OverlayBuilder(
                buildingPolygons: buildingPolygons,
                boundsFromPolygon: boundsFromPolygon,
                opacity: _overlayOpacity,
                floorNumber: floorNumber,
              ),
              if (_currentPosition != null) ...[
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      radius: _currentPosition!.accuracy,
                      useRadiusInMeter: true,
                      color: Colors.blue.withValues(alpha: 0.16),
                      borderColor: Colors.blue.withValues(alpha: 0.55),
                      borderStrokeWidth: 1.5,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 28,
                      height: 28,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                          border: Border.all(color: Colors.blue, width: 3),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (!_changingFloor) ...[
          Positioned(
            bottom: 16,
            left: 16,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _changingFloor = true;
                });

                await Future.delayed(const Duration(seconds: 5));

                if (mounted) {
                  setState(() {
                    _changingFloor = false;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: _overlayOpacity),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withValues(alpha: _overlayOpacity),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  'Floor $floorNumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87.withValues(alpha: _overlayOpacity),
                  ),
                ),
              ),
            ),
          ),
          ],
          if (_changingFloor) ...[
          Positioned(
            bottom:16,
            left: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'floor_up',
                  onPressed: () {
                    setState(() {
                      floorNumber++;
                    });
                  },
                  child: const Icon(Icons.arrow_upward),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'floor_down',
                  onPressed: () {
                    setState(() {
                      if (floorNumber > 0) {
                        floorNumber--;
                      }
                    });
                  },
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ), 
          ]
        ],
      ),
    );
  }
}
