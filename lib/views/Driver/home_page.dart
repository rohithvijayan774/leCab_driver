import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lecab_driver/provider/flutter_map_provider.dart';

import 'package:lecab_driver/widgets/driver_home_bottom_appbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final flutterMapPRo =
        Provider.of<FlutterMapProvider>(context, listen: false);
    // final googleMapProvider = Provider.of<UserGoogleMapProvider>(context);
    // flutterMapPRo.getCurrentLocation();
    return Scaffold(
      body: Center(
        child: FlutterMap(
          mapController: flutterMapPRo.mapController,
          options: MapOptions(
              center:const LatLng(11.248152117816762, 75.83425366164742),
              zoom: 15,
              maxZoom: 20,
              minZoom: 1),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(flutterMapPRo.currentLocation?.latitude ?? 0,
                      flutterMapPRo.currentLocation?.longitude ?? 0),
                  builder: (context) => const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: const DriverHomeBottomAppBar(),
    );
  }
}
