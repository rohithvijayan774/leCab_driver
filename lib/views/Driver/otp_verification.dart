import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/views/Driver/driver_details.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class DriverOTPVerification extends StatelessWidget {
  const DriverOTPVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final driverDetailsPro = Provider.of<DriverDetailsProvider>(context);
    // final userDetailsProLF =
    //     Provider.of<DriverDetailsProvider>(context, listen: false);
    // final defaultPinTheme = PinTheme(
    //     width: 56,
    //     height: 20,
    //     textStyle: TextStyle(
    //       fontSize: 50,
    //       color: Colors.grey,
    //     ),
    //     decoration: BoxDecoration(
    //       border: Border.all(color: Colors.black),
    //     ));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter the OTP send to the number ${driverDetailsPro.numberController.text}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onChanged: (value) {
                    driverDetailsPro.smsCode = value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
            ElevatedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey),
                backgroundColor: MaterialStateProperty.all(Colors.black),
                minimumSize: MaterialStateProperty.all(
                  const Size(50, 40),
                ),
              ),
              onPressed: () {
                // userDetailsProLF.verifyOTP(context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const DriverName(),
                    ),
                    (route) => false);
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
