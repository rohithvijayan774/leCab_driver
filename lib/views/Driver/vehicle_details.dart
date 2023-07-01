import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/provider/vehicle_details_provider.dart';
import 'package:lecab_driver/views/Driver/terms_privacy.dart';
import 'package:lecab_driver/widgets/vehicle_details_list_tile.dart';
import 'package:provider/provider.dart';

class VehicleDetails extends StatelessWidget {
  const VehicleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    log('Rebuilding Whole');
    final driverPro = Provider.of<DriverDetailsProvider>(context);
    // final VehicleProLF =
    //     Provider.of<VehicleDetailsProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Text(
                "Welcome ${driverPro.driverFirstNameController.text}",
                style: const TextStyle(fontSize: 25, fontFamily: "Poppins"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Required steps",
                    style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Here's what you need to do set up your account",
                    style: TextStyle(fontSize: 16, fontFamily: 'SofiaPro'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<VehicleDetailsProvider>(
                    builder: (context, value, _) {
                      // log('Rebuilding Tile');
                      // log("${value.profilePic == null}");
                      return VehicleDetailsListTile(
                          title: 'Profile Pic',
                          subtitile: value.profilePic == null
                              ? 'Nothing Selected'
                              : value.profilePicPath!,
                          onPressed: () {
                            value.uploadProfilePicture();
                          });
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                  Consumer<VehicleDetailsProvider>(
                    builder: (context, value, _) {
                      // log('Rebuilding Tile');
                      // log("${value.licensePic == null}");
                      return VehicleDetailsListTile(
                          title: 'Driving License',
                          subtitile: value.licensePic == null
                              ? 'Nothing Selected'
                              : value.licensePicPath!,
                          onPressed: () {
                            value.uploadLicense();
                          });
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                  Consumer<VehicleDetailsProvider>(
                    builder: (context, value, _) {
                      // log('Rebuilding Tile');
                      // log("${value.rcPic == null}");
                      return VehicleDetailsListTile(
                          title: 'Registration Certificate (RC)',
                          subtitile: value.rcPic == null
                              ? 'Nothing Selected'
                              : value.rcPicPath!,
                          onPressed: () {
                            value.uploadRC();
                          });
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                  Consumer<VehicleDetailsProvider>(
                    builder: (context, value, _) {
                      // log('Rebuilding Tile');
                      // log("${value.insurePic == null}");
                      return VehicleDetailsListTile(
                          title: 'Vehicle Insurance',
                          subtitile: value.insurePic == null
                              ? 'Nothing Selected'
                              : value.insurePicPath!,
                          onPressed: () {
                            value.uploadInsure();
                          });
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            Consumer<VehicleDetailsProvider>(
              builder: (context, value, _) {
                return ElevatedButton(
                  style: value.licensePic == null ||
                          value.profilePic == null ||
                          value.rcPic == null ||
                          value.insurePic == null
                      ? ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          minimumSize: MaterialStateProperty.all(
                            const Size(50, 40),
                          ),
                        )
                      : ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.grey),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          minimumSize: MaterialStateProperty.all(
                            const Size(50, 40),
                          ),
                        ),
                  onPressed: () {
                    // userDetailsProLF.verifyOTP(context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const DriverName(),
                    // ));
                    if (value.profilePic == null ||
                        value.licensePic == null ||
                        value.insurePic == null ||
                        value.rcPic == null) {
                      return;
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TermsAndPrivacy(),
                      ));
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "next",
                        style: TextStyle(
                            fontFamily: 'SofiaPro',
                            fontSize: 25,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
