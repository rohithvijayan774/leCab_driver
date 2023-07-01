import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lecab_driver/widgets/driver_history_bar.dart';

// ignore: must_be_immutable
class HistoryPage extends StatelessWidget {
  DateTime? dateTime;
  HistoryPage({this.dateTime, super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dropOff = [
      "HiLite Mall",
      "Railwaystation 4th Platform Road",
      "SM Street, Palayam, Kozhikode, Kerala",
      "Cyberpark Kozhikode"
    ];
    List<String> pickUp = [
      "Cyberpark Kozhikode",
      "SM Street, Palayam, Kozhikode, Kerala",
      "Railwaystation 4th Platform Road",
      "HiLite Mall",
    ];
    List<int> fare = [45, 110, 84, 38];
    dateTime = DateTime.now();
    String date = DateFormat('dd MMM').format(dateTime!);
    String time = DateFormat('h:mm a').format(dateTime!).toLowerCase();
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
            'History',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return DriverHistoryBar(
              bookedDate: date,
              bookedTime: time,
              pickUpLoc: pickUp[index],
              dropOffLoc: dropOff[index],
              fare: fare[index],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey.shade300,
              endIndent: 25,
              indent: 25,
            );
          },
          itemCount: dropOff.length),
    );
  }
}
