import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/splash_screen_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class DriverSplashScreen extends StatelessWidget {
  const DriverSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final splashScreenPro =
        Provider.of<SplashScreenProvider>(context, listen: false);
    splashScreenPro.gotoNextPage(context);
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
