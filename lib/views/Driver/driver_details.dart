import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/views/Driver/vehicle_details.dart';
import 'package:provider/provider.dart';

class DriverName extends StatelessWidget {
  const DriverName({super.key});

  @override
  Widget build(BuildContext context) {
    final driverDetailsPro = Provider.of<DriverDetailsProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: driverDetailsPro.driverNameFormKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's your name?",
                    style: TextStyle(fontSize: 25, fontFamily: "Poppins"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Let us know how to address you",
                    style: TextStyle(fontSize: 16, fontFamily: 'SofiaPro'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* This field is Required';
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.words,
                    controller: driverDetailsPro.driverFirstNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Firstname'),
                    onChanged: (value) {
                      driverDetailsPro.driverNameFormKey.currentState!
                          .validate();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* This field is Required';
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.words,
                    controller: driverDetailsPro.driverSurNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Surname'),
                    onChanged: (value) {
                      driverDetailsPro.driverNameFormKey.currentState!
                          .validate();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '* This field is Required';
                      } else {
                        return null;
                      }
                    },
                    textCapitalization: TextCapitalization.words,
                    controller: driverDetailsPro.driverAddressController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Address'),
                    onChanged: (value) {
                      driverDetailsPro.driverNameFormKey.currentState!
                          .validate();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey),
                backgroundColor: MaterialStateProperty.all(Colors.black),
                minimumSize: MaterialStateProperty.all(
                  const Size(50, 40),
                ),
              ),
              onPressed: () {
                if (driverDetailsPro.driverNameFormKey.currentState!
                    .validate()) {
                  driverDetailsPro.storeData(
                    context,
                    () {
                      driverDetailsPro.saveUserdDataToSP().then(
                            (value) => driverDetailsPro.setSignIn().then(
                                  (value) => Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const VehicleDetails(),
                                      ),
                                      (route) => false),
                                ),
                          );
                    },
                  );
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
            ),
          ],
        ),
      ),
    );
  }
}
