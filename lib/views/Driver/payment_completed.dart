import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/bottom_navbar_provider.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

class PaymentCompleted extends StatelessWidget {
  const PaymentCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DriverDetailsProvider>(context, listen: false);
    final bottomNavBarPro = Provider.of<BottomNavBarProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () async {
                bottomNavBarPro.currentIndex = 0;
                await provider.resetRide().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx1) => const DriverBottomNavBar()),
                      (route) => false);
                });
              },
              icon: const Icon(Icons.close),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Column(
                  children: [
                    Image.asset(
                      'lib/assets/done.png',
                      scale: 8,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Payment Completed',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
