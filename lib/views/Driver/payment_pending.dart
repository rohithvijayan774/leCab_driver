import 'package:flutter/material.dart';
import 'package:lecab_driver/views/Driver/payment_completed.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaymentPending extends StatelessWidget {
  const PaymentPending({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Payment Pending',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.black, size: 40)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filled(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaymentCompleted(),
                  ));
                },
                icon:const Icon(Icons.arrow_forward_ios_outlined),
              )
            ],
          )),
    );
  }
}
