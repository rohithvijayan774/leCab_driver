import 'dart:developer';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VehicleDetailsProvider extends ChangeNotifier {
  FilePickerResult? profilePic;
  // ignore: prefer_typing_uninitialized_variables
  var profilePicPath;

  Future<void> uploadProfilePicture() async {
    profilePic = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'doc', 'pdf'],
    );
    if (profilePic == null) {
      log('Profile Upload Failed');
    } else {
      log('Profile Pic Uploaded');
      final file = profilePic!.files.first;
      profilePicPath = file.name;
      log(profilePicPath);
    }

    notifyListeners();
  }

  FilePickerResult? licensePic;
  // ignore: prefer_typing_uninitialized_variables
  var licensePicPath;

  Future<void> uploadLicense() async {
    licensePic = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'doc', 'pdf'],
    );
    if (licensePic == null) {
      log('Profile Upload Failed');
    } else {
      log('Profile Pic Uploaded');
      final file = licensePic!.files.first;
      licensePicPath = file.name;
      log(licensePicPath );
    }

    notifyListeners();
  }
}
