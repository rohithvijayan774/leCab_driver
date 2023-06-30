import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:lecab_driver/widgets/journey_bottmapp.dart';
import 'package:provider/provider.dart';

import '../../provider/flutter_map_provider.dart';

// ignore: must_be_immutable
class JourneyPage extends StatelessWidget {
  DateTime? dateTime;
  JourneyPage({this.dateTime, super.key});

  @override
  Widget build(BuildContext context) {
    dateTime = DateTime.now();
    Duration durationToAdd = const Duration(minutes: 20);
    DateTime timeTaking = dateTime!.add(durationToAdd);
    String time = DateFormat('h:mm a').format(timeTaking).toLowerCase();

    final flutterMapPRo =
        Provider.of<FlutterMapProvider>(context, listen: false);
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
      bottomNavigationBar: JourneyBottomBar(
        destnName: "",
        estReachTime: time,
        distanceToDestn: 8.5,
        timeToReach: 22,
      ),
    );
  }
}
