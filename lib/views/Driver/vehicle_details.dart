import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
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
                  Consumer<DriverDetailsProvider>(
                    builder: (context, value, _) {
                      return VehicleDetailsListTile(
                        title: 'Profile Pic',
                        subtitile: value.proPic == null
                            ? 'Nothing Selected'
                            : value.proPicName.toString(),
                        onPressed: () async {
                          await value.selectProPic(context);
                          await value.uploadProPic(
                            value.proPic!,
                            () {
                              value.saveUserdDataToSP().then(
                                (value) {
                                  driverPro.setSignIn();
                                },
                              );
                            },
                          );
                          log('Uploaded : ${value.driverModel.driversProfilePic}');
                        },
                      );
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                  Consumer<DriverDetailsProvider>(
                    builder: (context, value, _) {
                      return VehicleDetailsListTile(
                        title: 'License Pic',
                        subtitile: value.licensePic == null
                            ? 'Nothing Selected'
                            : value.licenseName.toString(),
                        onPressed: () async {
                          await value.selectLicensePic(context);
                          await value.uploadLicensePic(
                            value.licensePic!,
                            () {
                              value.saveUserdDataToSP().then(
                                (value) {
                                  driverPro.setSignIn();
                                },
                              );
                            },
                          );
                          log('Uploaded : ${value.driverModel.driversLicensePic}');
                        },
                      );
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                  Consumer<DriverDetailsProvider>(
                    builder: (context, value, _) {
                      return VehicleDetailsListTile(
                        title: 'Registration Certificate (RC)',
                        subtitile: value.rcPic == null
                            ? 'Nothing Selected'
                            : value.rcName.toString(),
                        onPressed: () async {
                          await value.selectRCPic(context);
                          await value.uploadRCPic(
                            value.rcPic!,
                            () {
                              value.saveUserdDataToSP().then(
                                (value) {
                                  driverPro.setSignIn();
                                },
                              );
                            },
                          );
                          log('Uploaded : ${value.driverModel.driversRegCertPic}');
                        },
                      );
                    },
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 20,
                  ),
                  Consumer<DriverDetailsProvider>(
                    builder: (context, value, _) {
                      return VehicleDetailsListTile(
                        title: 'Vehicle Insurance',
                        subtitile: value.vehicleInsurePic == null
                            ? 'Nothing Selected'
                            : value.vehicleInsureName.toString(),
                        onPressed: () async {
                          await value.selectInsurePic(context);
                          await value.uploadVehicleInsurePic(
                            value.vehicleInsurePic!,
                            () {
                              value.saveUserdDataToSP().then(
                                (value) {
                                  driverPro.setSignIn();
                                },
                              );
                            },
                          );
                          log('Uploaded : ${value.driverModel.driversVehInsurancePic}');
                        },
                      );
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
            Consumer<DriverDetailsProvider>(
              builder: (context, value, _) {
                return ElevatedButton(
                  style: value.driverModel.driversLicensePic == null ||
                          value.driverModel.driversProfilePic == null ||
                          value.driverModel.driversRegCertPic == null ||
                          value.driverModel.driversVehInsurancePic == null
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
                    if (value.driverModel.driversProfilePic == null ||
                        value.driverModel.driversLicensePic == null ||
                        value.driverModel.driversRegCertPic == null ||
                        value.driverModel.driversVehInsurancePic == null) {
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
