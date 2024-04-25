import 'package:flutter/material.dart';
import 'package:productmaster/BGKEY/bgAmcKey.dart';
import 'package:productmaster/BGKEY/bgLicenceKey.dart';
import 'package:productmaster/BGKEY/bgUpdateKey.dart';
import '../Drawer/MyDrawarCard.dart';

class KEY extends StatefulWidget {
  const KEY({Key? key}) : super(key: key);

  @override
  _KeyState createState() => _KeyState();
}

class _KeyState extends State<KEY> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KEY'),
      ),
      drawer: MyDrawarCard(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SELECT SOFTWARE KEY',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BgLicenceKey()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color of the button
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No radius
                ),
              ),
              child: const Text(
                'BG LICENCE KEY',
                style: TextStyle(color: Colors.white), // Text color white
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BgUpdateKey()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color of the button
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No radius
                ),
              ),
              child: const Text(
                'BG UPDATE KEY',
                style: TextStyle(color: Colors.white), // Text color white
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BgAmcKey()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color of the button
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No radius
                ),
              ),
              child: const Text(
                'BG AMC KEY',
                style: TextStyle(color: Colors.white), // Text color white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
