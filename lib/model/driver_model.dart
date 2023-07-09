class DriverModel {
  String driverid;
  String driverFirstName;
  String driverSurName;
  String driverAddress;
  String driverPhoneNumber;

  DriverModel({
    required this.driverid,
    required this.driverFirstName,
    required this.driverSurName,
    required this.driverAddress,
    required this.driverPhoneNumber,
  });

  //from Map
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      driverid: map['driverid'] ?? '',
      driverFirstName: map['driverFirstName'] ?? '',
      driverSurName: map['driverSurName'] ?? '',
      driverAddress: map['driverAddress'] ?? '',
      driverPhoneNumber: map['driverPhoneNumber'] ?? '',
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
    };
  }
}
