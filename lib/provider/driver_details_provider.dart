import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecab_driver/model/driver_model.dart';
import 'package:lecab_driver/utils/users.dart';
import 'package:lecab_driver/views/Driver/driver_splash_screen.dart';
import 'package:lecab_driver/views/Driver/number_validation.dart';
import 'package:lecab_driver/views/Driver/otp_verification.dart';
import 'package:lecab_driver/views/Driver/starting_page.dart';
import 'package:lecab_driver/views/Driver/waiting_for_approval.dart';
import 'package:lecab_driver/widgets/bottom_navbar.dart';
import 'package:permission_handler/permission_handler.dart';
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

  String? selectedVehicle;
  List<String> vehicles = [
    'Auto',
    'Car',
    'SUV',
  ];

  void vehicleListDropDown(String newValue) {
    selectedVehicle = newValue;

    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);
    docRef.update({'vehicleType': selectedVehicle});
    _driverModel = driverModel;
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

  Future<bool> checkIsApproved() async {
    if (driverModel.isApproved == true) {
      return true;
    } else {
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
      isApproved: false,
      isReached: false,
      isOrderAccepted: false,
      vehicleType: selectedVehicle,
      pickupPlaceNameList: [],
      dropOffPlaceNameList: [],
      rideDateList: [],
      rideTimeList: [],
      cabeFareList: [],
    );
    await firebaseFirestore
        .collection('drivers')
        .doc(_driverid)
        .set(_driverModel!.toMap())
        .then((value) {
      onSuccess();
      notifyListeners();
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
        isApproved: snapshot['isApproved'],
        vehicleType: snapshot['vehicleType'],
        isReached: snapshot['isReached'],
        isOrderAccepted: snapshot['isOrderAccepted'],
        pickupPlaceNameList:
            (snapshot['pickupPlaceNameList'] as List<dynamic>).cast<String>(),
        dropOffPlaceNameList:
            (snapshot['dropOffPlaceNameList'] as List<dynamic>).cast<String>(),
        rideDateList:
            (snapshot['rideDateList'] as List<dynamic>).cast<String>(),
        rideTimeList:
            (snapshot['rideTimeList'] as List<dynamic>).cast<String>(),
        cabeFareList: (snapshot['cabeFareList'] as List<dynamic>).cast<int>(),
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
    notifyListeners();
  }

  //get locally stored data
  Future getDataFromSP() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String data = sharedPref.getString('driver_model') ?? '';
    _driverModel = DriverModel.fromMap(jsonDecode(data));
    _driverid = _driverModel!.driverid;

    notifyListeners();
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
      await getDataFromSP();
      await getDataFromFirestore();
      if (driverModel.isApproved == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DriverBottomNavBar(),
            ),
            (route) => false);
      } else if (driverModel.isApproved == false) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const WaitingForApproval(),
            ),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const DriverStartingPage(),
          ),
          (route) => false);
    }

    notifyListeners();
  }

  Future resetRide() async {
    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);

    await docRef.update({
      'isOrderAccepted': false,
      'isReached': false,
    });
  }

  Future<void> addDataToList(
    String pickupPlace,
    String dropOffPlace,
    String rideDate,
    String rideTime,
    int cabFare,
  ) async {
    try {
      DocumentSnapshot driverSnapshot =
          await firebaseFirestore.collection('drivers').doc(_driverid).get();
      if (!driverSnapshot.exists) {
        return;
      }
      DriverModel driver =
          DriverModel.fromMap(driverSnapshot.data() as Map<String, dynamic>);
      driver.pickupPlaceNameList.insert(0, pickupPlace);
      driver.dropOffPlaceNameList.insert(0, dropOffPlace);
      driver.rideDateList.insert(0, rideDate);
      driver.rideTimeList.insert(0, rideTime);
      driver.cabeFareList.insert(0, cabFare);

      Map<String, dynamic> updatedDriverData = driver.toMap();

      await firebaseFirestore
          .collection('drivers')
          .doc(_driverid)
          .update(updatedDriverData);
      log('Driver data updated successfully');
    } catch (e) {
      log('Error $e');
    }
  }

  //----------------------Call emergency-------------------------------

  void emergencyCall(String emergencyNumber) async {
    FlutterPhoneDirectCaller.callNumber(emergencyNumber);
    log('calling $emergencyNumber');
  }

  Future<void> callPermission() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      log('call permission Granted');
    } else {
      log('Call Permission Denied');
    }
  }

  //----------------Get Orders-----------------------------------------

  List<Users> ordersList = [];
  Users? orders;

  Future fetchOrders() async {
    print('fetching orders.....');
    ordersList.clear();
    CollectionReference ordersRef = firebaseFirestore.collection('users');

    QuerySnapshot ordersSnapshot = await ordersRef
        .where('isBooked', isEqualTo: true)
        .where('selectedVehicle', isEqualTo: driverModel.vehicleType)
        .get();

    for (var doc in ordersSnapshot.docs) {
      String passengerId = doc['uid'];
      String passengerFirstName = doc['firstName'];
      String passengerSurName = doc['surName'];
      String phoneNumber = doc['phoneNumber'];
      String profilePicture = doc['profilePicture'] ?? '';
      GeoPoint passengerLocation = doc['userCurrentLocation'];
      GeoPoint pickUpCoordinates = doc['pickUpCoordinates'];
      GeoPoint dropOffCoordinates = doc['dropOffCoordinates'];
      int rideDistance = doc['rideDistance'];
      int cabFare = doc['cabFare'];
      String selectedVehicle = doc['selectedVehicle'];
      String pickUpPlaceName = doc['pickUpPlaceName'];
      String dropOffPlaceName = doc['dropOffPlaceName'];
      bool isBooked = doc['isBooked'];

      orders = Users(
        passengerId: passengerId,
        passengerFirstName: passengerFirstName,
        passengerSurName: passengerSurName,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
        passengerLocation: passengerLocation,
        pickUpCoordinates: pickUpCoordinates,
        dropOffCoordinates: dropOffCoordinates,
        pickUpPlaceName: pickUpPlaceName,
        dropOffPlaceName: dropOffPlaceName,
        cabFare: cabFare,
        rideDistance: rideDistance,
        selectedVehicle: selectedVehicle,
        isBooked: isBooked,
      );
      ordersList.insert(0, orders!);
    }
    print('fetching completed : List Length ${ordersList.length}');
    notifyListeners();
  }

//-----------------------------Setting PolyLines--------------------------------

  Set<Polyline> polylines = {};
  Position? driverPosition;

  getCurrentLocation() async {
    driverPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  List<LatLng> polyLineCoordinates = [
    LatLng(11.249343627871772, 75.83413333424674),
    LatLng(11.235015752333629, 75.80372434433835),
  ];

  setPolyLines() {
    log('PolyLine function ');
    polylines.add(
      Polyline(
        geodesic: true,
        polylineId: PolylineId('polyLine 1'),
        points: polyLineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    );
    notifyListeners();
  }

//-----------------------------update isReached---------------------------------

  Future updateIsReachedtoTrue() async {
    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);

    await docRef.update(
      {'isReached': true},
    );
    print('Is Reached True');
    notifyListeners();
  }

  Future updateIsReachedtoFalse() async {
    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);

    await docRef.update(
      {'isReached': false},
    );
    print('Is Reached false');
    notifyListeners();
  }

//----------------------------Update isOrderAccept---------------------

  Future updateOrderAcceptTrue() async {
    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);
    await docRef.update({'isOrderAccepted': true});

    notifyListeners();
  }

  Future updateOrderAcceptFalse() async {
    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);
    await docRef.update({'isOrderAccepted': false});

    notifyListeners();
  }

//----------------------------Store Driver Current Location---------------------

  storeDriverCurrentLocation() async {
    DocumentReference docRef =
        firebaseFirestore.collection('drivers').doc(_driverid);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    GeoPoint latLongPosition = GeoPoint(position.latitude, position.longitude);

    await docRef.update({'driverCurrentLocation': latLongPosition});
    print('Driver Current Location Stored');
    notifyListeners();
  }

//-----------------------------update user selectDriver-------------------------

  Future updateSelectedDriver(String passengerId) async {
    DocumentReference docRef =
        firebaseFirestore.collection('users').doc(passengerId);

    await docRef.update({'selectedDriver': driverModel.driverid});
    notifyListeners();
  }
}
