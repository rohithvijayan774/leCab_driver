import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/bottom_navbar_provider.dart';
import 'package:provider/provider.dart';

class DriverBottomNavBar extends StatelessWidget {
  const DriverBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarPro = Provider.of<BottomNavBarProvider>(context);
    return Scaffold(
      body: bottomNavBarPro.pages[bottomNavBarPro.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        selectedItemColor: Colors.black,
        currentIndex: bottomNavBarPro.currentIndex,
        onTap: (index) {
          // pro.currentIndex = index;
          bottomNavBarPro.updateIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.route,
              ),
              label: 'Orders'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Account'),
        ],
      ),
    );
  }
}
