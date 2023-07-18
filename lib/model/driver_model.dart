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

  DriverModel({
    required this.driverid,
    required this.driverFirstName,
    required this.driverSurName,
    required this.driverAddress,
    required this.driverPhoneNumber,
    this.driversProfilePic,
    this.driversLicensePic,
    this.driversRegCertPic,
    this.driversVehInsurancePic,
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
    };
  }
}
