import 'package:flutter/material.dart';

class DriverDetailsProvider extends ChangeNotifier {
  //Driver Number Details
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  var smsCode = '';
  static String verificationCode = '';
  final numberFormKey = GlobalKey<FormState>();

  bool isOnline = false;

  isOnlineOffline(value) {
    isOnline = value;
    notifyListeners();
  }

  //Driver Name Details
  TextEditingController driverFirstNameController = TextEditingController();
  TextEditingController driverSurNameController = TextEditingController();
  TextEditingController driverAddressController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  final driverNameFormKey = GlobalKey<FormState>();
}
