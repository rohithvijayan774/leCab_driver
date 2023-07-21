import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                _isSignedIn = false;
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
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

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

  //-------------------- Vehicle Doc Picker-------------------

  Future<String> storeImagestoStorage(String ref, File file) async {
    log('Store Profile function Called');
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    log(downloadUrl);

    log('Profile pic stored to storage');
    return downloadUrl;
  }

//Profile Pic---------------------

  File? proPic;
  File? proPicName;
  Future<File?> pickProPic(BuildContext context) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        proPic = File(pickedImage.path);
        proPicName = File(pickedImage.name);
        log('$proPicName');
      }
    } catch (e) {
      log('$e');
    }
    return proPic;
  }

  selectProPic(context) async {
    proPic = await pickProPic(context);
    notifyListeners();
  }

  uploadProPic(File profilePic, Function onSuccess) async {
    await storeImagestoStorage(
            'Drivers Docs/Profile Pics/$_driverid', profilePic)
        .then((value) async {
      log(value);
      driverModel.driversProfilePic = value;

      DocumentReference docRef =
          firebaseFirestore.collection('drivers').doc(_driverid);
      docRef.update({'driversProfilePic': value});
    });
    _driverModel = driverModel;
    log('Driver Profile Pic Stored');
    notifyListeners();
  }

  //License Pic----------------------

  File? licensePic;
  File? licenseName;

  Future<File?> pickLicensePic(BuildContext context) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        licensePic = File(pickedImage.path);
        licenseName = File(pickedImage.name);
        log('$licenseName');
      }
    } catch (e) {
      log('$e');
    }
    return licensePic;
  }

  selectLicensePic(context) async {
    licensePic = await pickLicensePic(context);
    notifyListeners();
  }

  uploadLicensePic(File licensePic, Function onSuccess) async {
    await storeImagestoStorage(
            'Drivers Docs/License Pics/$_driverid', licensePic)
        .then((value) async {
      log(value);
      driverModel.driversLicensePic = value;

      DocumentReference docRef =
          firebaseFirestore.collection('drivers').doc(_driverid);
      docRef.update({'driversLicensePic': value});
    });
    _driverModel = driverModel;
    log('Driver License Pic Stored');
    notifyListeners();
  }

  //RC Pic-----------------------------------

  File? rcPic;
  File? rcName;

  Future<File?> pickRCPic(BuildContext context) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        rcPic = File(pickedImage.path);
        rcName = File(pickedImage.name);
        log('$rcName');
      }
    } catch (e) {
      log('$e');
    }
    return rcPic;
  }

  selectRCPic(context) async {
    rcPic = await pickRCPic(context);
    notifyListeners();
  }

  uploadRCPic(File rcPic, Function onSuccess) async {
    await storeImagestoStorage('Drivers Docs/RC Pics/$_driverid', rcPic)
        .then((value) async {
      log(value);
      driverModel.driversRegCertPic = value;

      DocumentReference docRef =
          firebaseFirestore.collection('drivers').doc(_driverid);
      docRef.update({'driversRegCertPic': value});
    });
    _driverModel = driverModel;
    log('Driver RC Pic Stored');
    notifyListeners();
  }

  //Vehicle Insurance Pic----------------

  File? vehicleInsurePic;
  File? vehicleInsureName;

  Future<File?> pickVehicleInsurePic(BuildContext context) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        vehicleInsurePic = File(pickedImage.path);
        vehicleInsureName = File(pickedImage.name);
        log('$vehicleInsureName');
      }
    } catch (e) {
      log('$e');
    }
    return vehicleInsurePic;
  }

  selectInsurePic(context) async {
    vehicleInsurePic = await pickVehicleInsurePic(context);
    notifyListeners();
  }

  uploadVehicleInsurePic(File vehicleInsurePic, Function onSuccess) async {
    await storeImagestoStorage(
            'Drivers Docs/Vehicle Insurance Pics/$_driverid', vehicleInsurePic)
        .then((value) async {
      log(value);
      driverModel.driversVehInsurancePic = value;

      DocumentReference docRef =
          firebaseFirestore.collection('drivers').doc(_driverid);
      docRef.update({'driversVehInsurancePic': value});
    });
    _driverModel = driverModel;
    log('Vehicle Insurance Pic Stored');
    notifyListeners();
  }

  //-----------------------------Database Operation----------------------
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
        driversProfilePic: snapshot['driversProfilePic'],
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

  Future setSignOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('is_signedIn', false);
    _isSignedIn = false;
    log('SIgnedIn = False');
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
