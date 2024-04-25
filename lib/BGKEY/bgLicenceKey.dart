import 'package:flutter/material.dart';
import '../Drawer/MyDrawarCard.dart';

class BgLicenceKey extends StatefulWidget {
  const BgLicenceKey({Key? key}) : super(key: key);

  @override
  _BgLicenceKeyState createState() => _BgLicenceKeyState();
}

class _BgLicenceKeyState extends State<BgLicenceKey> {
  String currentDateTime = DateTime.now().toString();
  String licenseKey = "";

    void generateNewKey() {
    // Logic to generate a new 3-digit key for each group
    String group1 = "${DateTime.now().millisecondsSinceEpoch % 1000}";
    String group2 = "${(DateTime.now().millisecondsSinceEpoch + 250) % 1000}";
    String group3 = "${(DateTime.now().millisecondsSinceEpoch + 750) % 1000}";
    String group4 = "${(DateTime.now().millisecondsSinceEpoch + 120) % 1000}";

    licenseKey = "$group1-$group2-$group3-$group4";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BG LICENCE KEY'),
      ),
      drawer: MyDrawarCard(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text for "BG LICENCE KEY"
            const Text(
              'BG LICENCE KEY',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Text('Software', style: TextStyle(fontSize: 18)),

            // Text for current time and date
            Text(
              'Date:- $currentDateTime',
              style: const TextStyle(fontSize: 14),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '$licenseKey',
                style: const TextStyle(fontSize: 35),
              ),
            ),

            // Button to generate a new key
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generateNewKey();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color of the button
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No radius
                ),
                minimumSize: const Size(150, 50), // Set the desired height
              ),
              child: const Text(
                'NEW - KEY',
                style: TextStyle(
                    color: Colors.white, // Text color white
                    fontWeight: FontWeight.bold,
                    fontSize: 30 // Text style bold
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
