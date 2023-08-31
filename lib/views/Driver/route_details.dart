import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/provider/driver_googlemap_provider.dart';
import 'package:lecab_driver/widgets/route_details_bottombar.dart';
import 'package:provider/provider.dart';

class RouteDetails extends StatelessWidget {
  final String passengerFirstName;
  final String passengerSurName;
  final String pickUpPlaceName;
  final String dropOffPlaceName;
  final int cabFare;
  final int rideDistance;
  final GeoPoint passengerLocation;
  const RouteDetails({
    required this.passengerFirstName,
    required this.passengerSurName,
    required this.pickUpPlaceName,
    required this.dropOffPlaceName,
    required this.cabFare,
    required this.rideDistance,
    required this.passengerLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final driverDetailsPro =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    final googleMapProvider =
        Provider.of<DriverGoogleMapProvider>(context, listen: false);
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
            googleMapProvider.newGoogleMapController = controller;
            googleMapProvider.locatePosition();
            driverDetailsPro.setPolyLines();
          },
          polylines: driverDetailsPro.polylines,
          markers: {
            Marker(
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              markerId: const MarkerId('Destinatin Location'),
              position: LatLng(
                  passengerLocation.latitude, passengerLocation.longitude),
            ),
          },
        ),
      ),
      bottomNavigationBar: RouteDetailsBottmBar(
        passengerFirstName: passengerFirstName,
        passengerSurName: passengerSurName,
        pickUpPlaceName: pickUpPlaceName,
        dropOffPlaceName: dropOffPlaceName,
        cabFare: cabFare,
        rideDistance: rideDistance,
      ),
    );
  }
}
