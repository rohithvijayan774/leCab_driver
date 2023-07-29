import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/widgets/orders_bar.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final driverDetailsPro =
        Provider.of<DriverDetailsProvider>(context, listen: false);
    driverDetailsPro.fetchOrders();
    log('Orders List : ${driverDetailsPro.ordersList.length}');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 20,
          ),
          child: Text(
            'Orders',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Consumer<DriverDetailsProvider>(builder: (context, value, _) {
        return value.ordersList.isEmpty
            ? const Center(
                child: Text('No Orders'),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return OrdersBar(
                          passengerLocation:
                              value.ordersList[index].passengerLocation,
                          passengerFirstName:
                              value.ordersList[index].passengerFirstName,
                          passengerSurName:
                              value.ordersList[index].passengerSurName,
                          pickUpLocation:
                              value.ordersList[index].pickUpPlaceName,
                          dropOffLocation:
                              value.ordersList[index].dropOffPlaceName,
                          fare: value.ordersList[index].cabFare,
                          distance: value.ordersList[index].rideDistance);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        indent: 10,
                        endIndent: 10,
                      );
                    },
                    itemCount: value.ordersList.length));
      }),
    );
  }
}
