import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/views/Driver/payment_pending.dart';
import 'package:lecab_driver/widgets/dot_seperator.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class JourneyBottomBar extends StatelessWidget {
  int timeToReach;
  double distanceToDestn;
  String estReachTime;
  String destnName;
  String pickUpLocation;
  String dropOffLocation;
  String rideTime;
  String rideDate;
  int cabFare;
  JourneyBottomBar({
    required this.estReachTime,
    required this.distanceToDestn,
    required this.timeToReach,
    required this.destnName,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.rideTime,
    required this.rideDate,
    required this.cabFare,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final driverProvider =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        decoration: const BoxDecoration(
            // color: Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                '$timeToReach mins',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$distanceToDestn km',
                    style: TextStyle(
                        fontFamily: 'SofiaPro',
                        fontSize: 22,
                        color: Colors.grey.shade500),
                  ),
                  const DotSeperator(),
                  Text(
                    estReachTime,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'SofiaPro',
                        fontSize: 22,
                        color: Colors.grey.shade500),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              ElevatedButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.grey),
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  minimumSize: MaterialStateProperty.all(
                    const Size(30, 30),
                  ),
                ),
                onPressed: () {
                  driverProvider
                      .addDataToList(pickUpLocation, dropOffLocation, rideDate, rideTime, cabFare)
                      .then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const PaymentPending(),
                        ),
                        (route) => false);
                  });
                },
                child: const Text(
                  "Finish",
                  style: TextStyle(
                      fontFamily: 'SofiaPro',
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
