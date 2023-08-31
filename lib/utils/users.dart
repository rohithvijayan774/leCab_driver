import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String passengerId;
  final String passengerFirstName;
  final String passengerSurName;
  final String phoneNumber;
  final String profilePicture;
  final GeoPoint passengerLocation;
  final GeoPoint pickUpCoordinates;
  final GeoPoint dropOffCoordinates;
  final int rideDistance;
  final int cabFare;
  final String selectedVehicle;
  final String pickUpPlaceName;
  final String dropOffPlaceName;
  final bool isBooked;

  Users({
    required this.passengerId,
    required this.passengerFirstName,
    required this.passengerSurName,
    required this.phoneNumber,
    required this.profilePicture,
    required this.passengerLocation,
    required this.pickUpCoordinates,
    required this.dropOffCoordinates,
    required this.pickUpPlaceName,
    required this.dropOffPlaceName,
    required this.cabFare,
    required this.rideDistance,
    required this.selectedVehicle,
    required this.isBooked,
  });
}
