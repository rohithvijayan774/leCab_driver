import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/views/Driver/route_details.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrdersBar extends StatelessWidget {
  String pickUpLocation;
  String dropOffLocation;
  int fare;
  String distance;
  OrdersBar(
      {required this.pickUpLocation,
      required this.dropOffLocation,
      required this.fare,
      required this.distance,
      super.key});

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
            SizedBox(
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
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RouteDetails(),
                      ))
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
