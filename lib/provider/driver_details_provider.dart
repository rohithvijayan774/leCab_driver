import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lecab_driver/model/driver_model.dart';
import 'package:lecab_driver/views/Driver/driver_splash_screen.dart';
import 'package:lecab_driver/views/Driver/number_validation.dart';
import 'package:lecab_driver/views/Driver/otp_verification.dart';
import 'package:lecab_driver/views/Driver/starting_page.dart';
import 'package:lecab_driver/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/authentication_dialogue_widget.dart';

class DriverDetailsProvider extends ChangeNotifier {
  //Driver Number Details

  DriverDetailsProvider() {
    checkSignedIn();
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

  //---------------------------------
  //Phone Number Authentication

  final numberFormKey = GlobalKey<FormState>();

  TextEditingController countryCodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String? otpError;
  String? _driverid;
  String get driverid => _driverid!;
  DriverModel? _driverModel;
  DriverModel get driverModel => _driverModel!;
  // var smsCode = '';
  // static String verificationCode = '';

  clearNumberField() {
    numberController.clear();
    notifyListeners();
  }

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  showCountries(context) {
    showCountryPicker(
      context: context,
      countryListTheme: const CountryListThemeData(
        bottomSheetHeight: 600,
      ),
      onSelect: (value) {
        selectedCountry = value;
        notifyListeners();
      },
    );
  }

  Future<void> sendOTP(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AuthenticationDialogueWidget(
          message: 'Authenticating, Please wait...',
        );
      },
    );
    String userPhoneNumber = numberController.text.trim();
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+${selectedCountry.phoneCode}$userPhoneNumber}",
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException error) {
        otpError = error.toString();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverNumberValidation(),
            ));
        // Navigator.pop(context);

        log("Verification failed $error");
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        // verificationCode = verificationId;
        log(verificationId);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              DriverOTPVerification(verifiactionId: verificationId),
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    log("OTP Sent to ${selectedCountry.phoneCode}$userPhoneNumber");

    notifyListeners();
  }

  verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required Function onSuccess,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AuthenticationDialogueWidget(
          message: 'Verifying OTP...',
        );
      },
    );
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        _driverid = user.uid;
        onSuccess();
      }
      log("OTP correct");
    } catch (e) {
      Navigator.pop(context);
      log('$e');
    }
    notifyListeners();
  }

  //Database Operation
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection('drivers').doc(_driverid).get();

    if (snapshot.exists) {
      log('USER EXISTS');
      return true;
    } else {
      log('NEW USER');
      return false;
    }
  }

  void storeData(BuildContext context, Function onSuccess) async {
    log('Store data called');

    _driverModel = DriverModel(
      driverid: driverid,
      driverFirstName: driverFirstNameController.text.trim(),
      driverSurName: driverSurNameController.text.trim(),
      driverAddress: driverAddressController.text.trim(),
      driverPhoneNumber: firebaseAuth.currentUser!.phoneNumber!,
    );
    await firebaseFirestore
        .collection('drivers')
        .doc(_driverid)
        .set(_driverModel!.toMap())
        .then((value) {
      onSuccess();
    });
  }

  Future getDataFromFirestore() async {
    await firebaseFirestore
        .collection('drivers')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _driverModel = DriverModel(
        driverid: driverid,
        driverFirstName: snapshot['driverFirstName'],
        driverSurName: snapshot['driverSurName'],
        driverAddress: snapshot['driverAddress'],
        driverPhoneNumber: snapshot['driverPhoneNumber'],
      );
      _driverid = driverModel.driverid;
    });
    notifyListeners();
  }

  // Storing data locally
  Future saveUserdDataToSP() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(
        'driver_model', jsonEncode(_driverModel!.toMap()));
  }

  //get locally stored data
  Future getDataFromSP() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String data = sharedPref.getString('driver_model') ?? '';
    _driverModel = DriverModel.fromMap(jsonDecode(data));
    _driverid = _driverModel!.driverid;
  }

  //----------------------------------
  //for splash screen

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  void checkSignedIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _isSignedIn = sharedPreferences.getBool('is_signedIn') ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('is_signedIn', true);
    _isSignedIn = true;
    log('SignedIn = True');
    notifyListeners();
  }

  gotoNextPage(context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (isSignedIn == true) {
      await getDataFromSP().whenComplete(
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DriverBottomNavBar(),
          ),
        ),
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DriverStartingPage(),
          ));
    }

    notifyListeners();
  }
}
