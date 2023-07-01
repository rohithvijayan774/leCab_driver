import 'package:flutter/material.dart';
import 'package:lecab_driver/widgets/dot_seperator.dart';

// ignore: must_be_immutable
class DriverHistoryBar extends StatelessWidget {
  String bookedTime;
  String bookedDate;
  String dropOffLoc;
  String pickUpLoc;
  int fare;
  DriverHistoryBar({
    required this.bookedDate,
    required this.bookedTime,
    required this.dropOffLoc,
    required this.pickUpLoc,
    required this.fare,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const Column(
        children: [
          Icon(
            Icons.arrow_downward,
            color: Colors.black,
            size: 30,
          ),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pickUpLoc,
            style: const TextStyle(
                fontFamily: 'SofiaPro',
                fontWeight: FontWeight.w800,
                fontSize: 18),
            maxLines: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            dropOffLoc,
            style: const TextStyle(
                fontFamily: 'SofiaPro',
                fontWeight: FontWeight.w800,
                fontSize: 18),
            maxLines: 1,
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Text(
            bookedDate,
            style: const TextStyle(
                fontFamily: 'SofiaPro',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          const DotSeperator(),
          Text(
            bookedTime,
            style: const TextStyle(
                fontFamily: 'SofiaPro',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ],
      ),
      trailing: Text(
        '₹$fare',
        style:const TextStyle(fontFamily: 'Poppins', fontSize: 20),
      ),
    );
  }
}
