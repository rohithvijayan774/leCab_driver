import 'package:flutter/material.dart';

class DriverWaitApproval extends StatelessWidget {
  const DriverWaitApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
