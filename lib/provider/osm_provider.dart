
import 'package:flutter/material.dart';

class OSMProvider extends ChangeNotifier {
  // MapController? mapController = MapController(
  //   initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  //   areaLimit: BoundingBox(
  //     east: 10.4922941,
  //     north: 47.8084648,
  //     south: 45.817995,
  //     west: 5.9559113,
  //   ),
  // );

  // Future<List<LatLng>> fetchRouteCoordinates(LatLng start, LatLng end) async {
  //   final url =
  //       'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full';

  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final decoded = json.decode(response.body);
  //     final route = decoded['route'][0]['geometry'];
  //     final encodedPolyline = 
  //   }
  // }
}
