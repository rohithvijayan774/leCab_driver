import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class FlutterMapProvider extends ChangeNotifier {
  MapController mapController = MapController();
  LocationData? currentLocation;

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentLocation = await location.getLocation();
    mapController.move(
      LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      13.0,
    );
    log('${currentLocation!.latitude}, ${currentLocation!.longitude}');
    notifyListeners();
  }
}
