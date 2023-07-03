import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class SyncFutionMap extends StatefulWidget {
  const SyncFutionMap({super.key});

  @override
  State<SyncFutionMap> createState() => _SyncFutionMapState();
}

class _SyncFutionMapState extends State<SyncFutionMap> {
  late List<MapLatLng> _polylinePoints;
  // late AnimationController _animationController;
  // late Animation _animation;

  @override
  void initState() {
    _polylinePoints = <MapLatLng>[
      const MapLatLng(13.0827, 80.2707),
      const MapLatLng(13.6373, 79.5037),
      const MapLatLng(14.4673, 78.8242),
      const MapLatLng(14.9091, 78.0092),
      const MapLatLng(16.2160, 77.3566),
      const MapLatLng(17.1557, 76.8697),
      const MapLatLng(18.0975, 75.4249),
      const MapLatLng(18.5204, 73.8567),
      const MapLatLng(19.4760, 72.8777),
    ];

    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 3),

    // );

    // _animation = CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.easeInOut,
    // );
    // _animationController.forward(from: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              initialZoomLevel: 10,
              initialFocalLatLng:const MapLatLng(16.2160, 77.3566),
              initialMarkersCount: _polylinePoints.length,
              markerBuilder: (BuildContext context, int index) {
                if (index == _polylinePoints.length - 1) {
                  return MapMarker(
                    latitude: _polylinePoints[index].latitude,
                    longitude: _polylinePoints[index].longitude,
                    child: Transform.translate(
                      offset:const Offset(0.0, -8.0),
                      child:
                         const Icon(Icons.location_on, color: Colors.red, size: 30),
                    ),
                  );
                } else {
                  return MapMarker(
                    latitude: _polylinePoints[index].latitude,
                    longitude: _polylinePoints[index].longitude,
                    iconType: MapIconType.circle,
                    iconColor: Colors.white,
                    iconStrokeWidth: 2.0,
                    size: index == 0 ?const Size(12.0, 12.0) :const Size(8.0, 8.0),
                    iconStrokeColor: Colors.black,
                  );
                }
              },
              sublayers: [
                MapPolylineLayer(
                  polylines: {
                    MapPolyline(
                      points: _polylinePoints,
                      color:const Color.fromRGBO(112, 115, 121, 1),
                      width: 6.0,
                    )
                  },
                  // animation: _animation,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
