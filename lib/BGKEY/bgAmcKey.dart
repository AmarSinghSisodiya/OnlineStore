import 'package:flutter/material.dart';
import '../Drawer/MyDrawarCard.dart';
class BgAmcKey extends StatefulWidget {
  const BgAmcKey({Key? key}) : super(key: key);
  @override
  _BgAmcKeyState createState() => _BgAmcKeyState();
}
class _BgAmcKeyState extends State<BgAmcKey> {
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
        title: const Text('BG AMC KEY'),
      ),
      drawer: MyDrawarCard(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BG AMC KEY',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Text('Software', style: TextStyle(fontSize: 18)),
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