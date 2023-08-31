import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/views/Driver/route_details.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrdersBar extends StatelessWidget {
  final String passengerId;
  final String passengerFirstName;
  final String passengerSurName;
  final String pickUpLocation;
  final String dropOffLocation;
  final int fare;
  final int distance;
  final GeoPoint passengerLocation;
  const OrdersBar({
    required this.passengerId,
    required this.passengerFirstName,
    required this.passengerSurName,
    required this.pickUpLocation,
    required this.dropOffLocation,
    required this.fare,
    required this.distance,
    required this.passengerLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final driverDetailsPro = Provider.of<DriverDetailsProvider>(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_downward_outlined,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pickUpLocation,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SofiaPro'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    dropOffLocation,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SofiaPro'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  "₹$fare",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${distance}km",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey),
                backgroundColor: driverDetailsPro.isOnline == true
                    ? MaterialStateProperty.all(Colors.black)
                    : MaterialStateProperty.all(Colors.grey),
                minimumSize: MaterialStateProperty.all(
                  const Size(30, 30),
                ),
              ),
              onPressed: () {
                driverDetailsPro.isOnline == true
                    ? driverDetailsPro.updateOrderAcceptTrue().then(
                        (value) {
                          driverDetailsPro
                              .updateSelectedDriver(passengerId)
                              .then(
                            (value) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RouteDetails(
                                    passengerLocation: passengerLocation,
                                    passengerFirstName: passengerFirstName,
                                    passengerSurName: passengerSurName,
                                    pickUpPlaceName: pickUpLocation,
                                    dropOffPlaceName: dropOffLocation,
                                    cabFare: fare,
                                    rideDistance: distance,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : null;
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //       builder: (context) => const UserChooseVehicle(),
                //     ),
                //     (route) => false);
              },
              child: const Text(
                "Accept",
                style: TextStyle(
                    fontFamily: 'SofiaPro', fontSize: 25, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}
