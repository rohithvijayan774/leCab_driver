import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:provider/provider.dart';

class DriverHomeBottomAppBar extends StatelessWidget {
  const DriverHomeBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final driverDetailsPro = Provider.of<DriverDetailsProvider>(context);
    final driverDetailsProLF =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: const BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    driverDetailsPro.isOnline == true ? 'Online' : 'Offline',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                    textAlign: TextAlign.center,
                  ),
                ),
                Switch(
                  activeTrackColor: Colors.black,
                  // activeColor: Colors.black,
                  value: driverDetailsPro.isOnline,
                  onChanged: (value) {
                    driverDetailsProLF.isOnlineOffline(value);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                driverDetailsPro.driverModel.driversProfilePic == null
                    ? CircleAvatar(
                        radius: 30,
                        child: Image.asset(
                          'lib/assets/profile.png',
                          scale: 5,
                        ),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                            driverDetailsPro.driverModel.driversProfilePic!,
                            scale: 5),
                      ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${driverDetailsPro.driverModel.driverFirstName} ${driverDetailsPro.driverModel.driverSurName}",
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Poppins',
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.currency_rupee_rounded,
                        ),
                      ),
                      const Text(
                        'Todays',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'SofiaPro'),
                      ),
                      const Text(
                        '0.0',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Poppins'),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.check,
                        ),
                      ),
                      const Text(
                        'Finished',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'SofiaPro'),
                      ),
                      const Text(
                        '0',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Poppins'),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                      const Text(
                        'Cancelled',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'SofiaPro'),
                      ),
                      const Text(
                        '0',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Poppins'),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
