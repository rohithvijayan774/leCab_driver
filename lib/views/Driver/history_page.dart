import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lecab_driver/provider/driver_details_provider.dart';
import 'package:lecab_driver/widgets/driver_history_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<DriverDetailsProvider>(builder: (context, provider, _) {
        provider.getDataFromFirestore();
        return provider.driverModel.pickupPlaceNameList.isEmpty
            ? const Center(
                child: Text('No History'),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return DriverHistoryBar(
                    bookedDate: provider.driverModel.rideDateList[index],
                    bookedTime: provider.driverModel.rideTimeList[index],
                    pickUpLoc: provider.driverModel.pickupPlaceNameList[index],
                    dropOffLoc:
                        provider.driverModel.dropOffPlaceNameList[index],
                    fare: provider.driverModel.cabeFareList[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey.shade300,
                    endIndent: 25,
                    indent: 25,
                  );
                },
                itemCount: provider.driverModel.pickupPlaceNameList.length);
      }),
    );
  }
}
