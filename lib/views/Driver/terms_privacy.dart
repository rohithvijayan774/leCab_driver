import 'package:flutter/material.dart';
import 'package:lecab_driver/widgets/bottom_navbar.dart';

class TermsAndPrivacy extends StatelessWidget {
  const TermsAndPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
            child: Column(
              children: [
                const Text(
                  'Accept Terms & Privacy Notice',
                  style: TextStyle(fontFamily: 'SofiaPro', fontSize: 40),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Image.asset('lib/assets/terms_conditions.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'By clicking next button, I have reviewed and agree to the Terms of Use and acknowledge the Privacy Notice.',
                  style: TextStyle(
                    fontFamily: 'SofiaPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            ElevatedButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.grey),
                backgroundColor: MaterialStateProperty.all(Colors.black),
                minimumSize: MaterialStateProperty.all(
                  const Size(50, 40),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const DriverBottomNavBar(),
                    ),
                    (route) => false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "next",
                    style: TextStyle(
                        fontFamily: 'SofiaPro',
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
