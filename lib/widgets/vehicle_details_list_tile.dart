import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VehicleDetailsListTile extends StatelessWidget {
  String title;
  String subtitile;
  VoidCallback onPressed;
  VehicleDetailsListTile(
      {required this.title,
      required this.subtitile,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Image.asset(
        'lib/assets/docs.png',
        scale: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'SofiaPro', fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitile,
        style:const TextStyle(color: Colors.grey, fontFamily: 'SofiaPro'),
      ),
    );
  }
}
