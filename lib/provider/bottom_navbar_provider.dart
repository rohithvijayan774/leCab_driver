import 'package:flutter/material.dart';
import 'package:lecab_driver/views/Driver/account_page.dart';
import 'package:lecab_driver/views/Driver/history_page.dart';
import 'package:lecab_driver/views/Driver/home_page.dart';
import 'package:lecab_driver/views/Driver/orders_page.dart';

class BottomNavBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const OrdersPage(),
    HistoryPage(),
    const AccountPage(),
  ];

  updateIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}
