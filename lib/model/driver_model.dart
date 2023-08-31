import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String driverid;
  String driverFirstName;
  String driverSurName;
  String driverAddress;
  String driverPhoneNumber;
  String? driversProfilePic;
  String? driversLicensePic;
  String? driversRegCertPic;
  String? driversVehInsurancePic;
  bool? isApproved;
  String? vehicleType;
  GeoPoint? driverCurrentLocation;
  bool? isReached;
  bool? isOrderAccepted;
  List<String> pickupPlaceNameList = [];
  List<String> dropOffPlaceNameList = [];
  List<String> rideDateList = [];
  List<String> rideTimeList = [];
  List<int> cabeFareList = [];

  DriverModel({
    required this.driverid,
    required this.driverFirstName,
    required this.driverSurName,
    required this.driverAddress,
    required this.driverPhoneNumber,
    required this.vehicleType,
    this.driversProfilePic,
    this.driversLicensePic,
    this.driversRegCertPic,
    this.driversVehInsurancePic,
    this.isApproved,
    this.driverCurrentLocation,
    this.isReached,
    this.isOrderAccepted,
    required this.pickupPlaceNameList,
    required this.dropOffPlaceNameList,
    required this.rideDateList,
    required this.rideTimeList,
    required this.cabeFareList,
  });

  //from Map
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      driverid: map['driverid'] ?? '',
      driverFirstName: map['driverFirstName'] ?? '',
      driverSurName: map['driverSurName'] ?? '',
      driverAddress: map['driverAddress'] ?? '',
      driverPhoneNumber: map['driverPhoneNumber'] ?? '',
      driversProfilePic: map['driversProfilePic'] ?? '',
      driversLicensePic: map['driversLicensePic'] ?? '',
      driversRegCertPic: map['driversRegCertPic'] ?? '',
      driversVehInsurancePic: map['driversVehInsurancePic'] ?? '',
      isApproved: map['isApproved'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      driverCurrentLocation: map['driverCurrentLocation'],
      isReached: map['isReached'],
      isOrderAccepted: map['isOrderAccepted'],
      pickupPlaceNameList: (map['pickupPlaceNameList'] as List<dynamic>?)!
          .map((item) => item.toString())
          .toList()
          .cast<String>(),
      dropOffPlaceNameList: (map['dropOffPlaceNameList'] as List<dynamic>?)!
          .map((item) => item.toString())
          .toList()
          .cast<String>(),
      rideTimeList: (map['rideTimeList'] as List<dynamic>?)!
          .map((item) => item.toString())
          .toList()
          .cast<String>(),
      rideDateList: (map['rideDateList'] as List<dynamic>?)!
          .map((item) => item.toString())
          .toList()
          .cast<String>(),
      cabeFareList: (map['rideDateList'] as List<dynamic>?)!
          .map((item) => item)
          .toList()
          .cast<int>(),
    );
  }

  //to Map
  Map<String, dynamic> toMap() {
    return {
      'driverid': driverid,
      'driverFirstName': driverFirstName,
      'driverSurName': driverSurName,
      'driverAddress': driverAddress,
      'driverPhoneNumber': driverPhoneNumber,
      'driversProfilePic': driversProfilePic,
      'driversLicensePic': driversLicensePic,
      'driversRegCertPic': driversRegCertPic,
      'driversVehInsurancePic': driversVehInsurancePic,
      'isApproved': isApproved,
      'vehicleType': vehicleType,
      'driverCurrentLocation': driverCurrentLocation,
      'isReached': isReached,
      'isOrderAccepted': isOrderAccepted,
      'pickupPlaceNameList': pickupPlaceNameList,
      'dropOffPlaceNameList': dropOffPlaceNameList,
      'rideTimeList': rideTimeList,
      'rideDateList': rideDateList,
      'cabeFareList': cabeFareList,
    };
  }
}
