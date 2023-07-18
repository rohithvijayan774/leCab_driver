import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class DriverSplashScreen extends StatelessWidget {
  const DriverSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driverDetailsProLF =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    driverDetailsProLF.gotoNextPage(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "leCab.",
              style: TextStyle(
                  fontSize: 80,
                  fontFamily: "Fabada",
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Driver",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Fabada",
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            LoadingAnimationWidget.newtonCradle(color: Colors.black, size: 100),
          ],
        ),
      ),
    );
  }
}
