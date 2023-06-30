import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/bottom_navbar_provider.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/provider/flutter_map_provider.dart';
import 'package:lecab_driver/provider/osm_provider.dart';
import 'package:lecab_driver/provider/splash_screen_provider.dart';
import 'package:lecab_driver/provider/vehicle_details_provider.dart';
import 'package:lecab_driver/views/Driver/driver_splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DriverDetailsProvider>(
          create: (context) => DriverDetailsProvider(),
        ),
        ChangeNotifierProvider<VehicleDetailsProvider>(
          create: (context) => VehicleDetailsProvider(),
        ),
        ChangeNotifierProvider<BottomNavBarProvider>(
          create: (context) => BottomNavBarProvider(),
        ),
        ChangeNotifierProvider<OSMProvider>(
          create: (context) => OSMProvider(),
        ),
        ChangeNotifierProvider<FlutterMapProvider>(
          create: (context) => FlutterMapProvider(),
        ),
        ChangeNotifierProvider<SplashScreenProvider>(
          create: (context) => SplashScreenProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'leCab Driver',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const DriverSplashScreen(),
      ),
    );
  }
}
