import 'package:flutter/material.dart';
import 'package:lecab_driver/views/Driver/driver_splash_screen.dart';

class DriverDetailsProvider extends ChangeNotifier {
  //Driver Number Details
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  var smsCode = '';
  static String verificationCode = '';
  final numberFormKey = GlobalKey<FormState>();

  clearNumberField() {
    numberController.clear();
    notifyListeners();
  }

  bool isOnline = true;

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

  clearNameFields() {
    driverFirstNameController.clear();
    driverSurNameController.clear();
    driverAddressController.clear();
    notifyListeners();
  }

  signOut(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // content: Text("Do you want to SignOut?"),
          title: const Text(
            'Do you want to SignOut?',
            style:
                TextStyle(fontFamily: 'SofiaPro', fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 17, fontFamily: "SofiaPro"),
              ),
            ),
            TextButton(
              onPressed: () {
                clearNameFields();
                clearNumberField();
                Navigator.of(ctx).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (ctx1) => const DriverSplashScreen(),
                    ),
                    (route) => false);
              },
              child: const Text(
                'SignOut',
                style: TextStyle(
                    fontSize: 17, color: Colors.red, fontFamily: "SofiaPro"),
              ),
            ),
          ],
        );
      },
    );
    notifyListeners();
  }
}
