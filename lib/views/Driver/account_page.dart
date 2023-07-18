import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/bottom_navbar_provider.dart';

import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/utils/driver_image_viewer.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userNamePro = Provider.of<UserDetailsProvider>(context);
    final driverDetailsPro =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    final driverBottomNavPro = Provider.of<BottomNavBarProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    driverDetailsPro.driverModel.driverFirstName,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Consumer<DriverDetailsProvider>(
                    builder: (context, value, _) {
                      return Stack(
                        children: [
                          InkWell(
                            onLongPress: () {
                              value.driverModel.driversProfilePic == null
                                  ? print('NO IMAGE TO SHOW')
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ImageViewer(
                                            image: value
                                                .driverModel.driversProfilePic),
                                      ),
                                    );
                            },
                            child: value.driverModel.driversProfilePic == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                    child: Image.asset(
                                      'lib/assets/profile.png',
                                      scale: 5,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        value.driverModel.driversProfilePic!,
                                        scale: 5),
                                  ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: 50,
                            child: IconButton(
                              onPressed: () async {
                                await value.selectProPic(context);
                                await value.uploadProPic(
                                  value.proPic!,
                                  () {
                                    value.saveUserdDataToSP().then(
                                      (value) {
                                        driverDetailsPro.setSignIn();
                                      },
                                    );
                                  },
                                );
                                log('Uplaoded : ${value.driverModel.driversProfilePic!}');
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                indent: 20,
                endIndent: 20,
                color: Colors.grey.shade200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "UserName",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${driverDetailsPro.driverModel.driverFirstName} ${driverDetailsPro.driverModel.driverSurName}',
                style: const TextStyle(
                    fontFamily: 'SofiaPro',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Phone Number",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                driverDetailsPro.driverModel.driverPhoneNumber,
                style: const TextStyle(
                    fontFamily: 'SofiaPro',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Email",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "driverEmail",
                style: TextStyle(
                    fontFamily: 'SofiaPro',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Address",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                driverDetailsPro.driverModel.driverAddress,
                style: const TextStyle(
                    fontFamily: 'SofiaPro',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(
                      Icons.car_crash_sharp,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Report Accident',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Call Emergency',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  driverBottomNavPro.currentIndex = 0;
                  driverDetailsPro.signOut(context);
                  // driverDetailsPro.signOut(context);
                  // userDetailsPro.clearNumberField();
                  // userDetailsPro.clearNameFields();
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(
                  //         builder: (ctx1) => const UserStartingPage()),
                  //     (route) => false);
                },
                child: const Text(
                  'SignOut',
                  style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => SyncFutionMap(),
      //   ));
      // }),
    );
  }
}
