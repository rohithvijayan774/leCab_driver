import 'package:flutter/material.dart';
import 'package:lecab_driver/widgets/orders_bar.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> pickUpLocations = [
      "HiLite Mall",
      "Railwaystation 4th Platform Road",
      "SM Street, Palayam, Kozhikode, Kerala",
      "Cyberpark Kozhikode",
    ];

    List<String> dropOffLocations = [
      "Cyberpark Kozhikode",
      "SM Street, Palayam, Kozhikode, Kerala",
      "Railwaystation 4th Platform Road",
      "HiLite Mall",
    ];

    List<int> fares = [
      80,
      45,
      90,
      110,
    ];

    List<String> distances = [
      "10",
      "25",
      "8",
      "16",
    ];
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
      body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return OrdersBar(
                    pickUpLocation: pickUpLocations[index],
                    dropOffLocation: dropOffLocations[index],
                    fare: fares[index],
                    distance: distances[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  indent: 10,
                  endIndent: 10,
                );
              },
              itemCount: pickUpLocations.length)),
    );
  }
}
