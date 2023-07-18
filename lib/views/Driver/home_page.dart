import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lecab_driver/provider/user_googlemap_provider.dart';

import 'package:lecab_driver/widgets/driver_home_bottom_appbar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final driverDetailsPro = Provider.of<DriverDetailsProvider>(context);
    // final flutterMapPRo =
    //     Provider.of<FlutterMapProvider>(context, listen: false);
    final googleMapProvider = Provider.of<DriverGoogleMapProvider>(context);
    // flutterMapPRo.getCurrentLocation();
    return Scaffold(
      body: Center(
        child: GoogleMap(
          padding: const EdgeInsets.only(top: 250),

          initialCameraPosition: googleMapProvider.yourLocation,
          mapType: MapType.normal,
          // myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            // googleMapProvider.googleMapController.complete(controller);
            googleMapProvider.newGoogleMapController = controller;
            googleMapProvider.locatePosition();
          },
          // markers: {
          //   Marker(
          //     // icon: BitmapDescriptor.defaultMarkerWithHue(
          //     //     BitmapDescriptor.hueAzure),
          //     markerId:const MarkerId('Destinatin Location'),
          //     position: destinationLocation,
          //   ),
          // },
        ),
        // child: FlutterMap(
        //   mapController: flutterMapPRo.mapController,
        //   options: MapOptions(
        //       center: const LatLng(11.249798337105936, 75.83470285183536),
        //       zoom: 17,
        //       maxZoom: 20,
        //       minZoom: 1),
        //   children: [
        //     TileLayer(
        //       urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        //       subdomains: const ['a', 'b', 'c'],
        //     ),
        //     MarkerLayer(
        //       markers: [
        //         //Driver Location
        //         Marker(
        //           point: const LatLng(11.249798337105936, 75.83470285183536),
        //           builder: (context) => driverDetailsPro.isOnline == true
        //               ? const Icon(
        //                   Icons.location_pin,
        //                   color: Colors.red,
        //                   size: 40,
        //                 )
        //               : const Icon(
        //                   Icons.location_off,
        //                   color: Colors.black,
        //                   size: 40,
        //                 ),
        //         ),
        //         // Marker(
        //         //   point: LatLng(flutterMapPRo.currentLocation?.latitude ?? 0,
        //         //       flutterMapPRo.currentLocation?.longitude ?? 0),
        //         //   builder: (context) => const Icon(
        //         //     Icons.location_pin,
        //         //     color: Colors.red,
        //         //     size: 40,
        //         //   ),
        //         // ),
        //       ],
        //     )
        //   ],
        // ),
      ),
      bottomNavigationBar: const DriverHomeBottomAppBar(),
    );
  }
}
