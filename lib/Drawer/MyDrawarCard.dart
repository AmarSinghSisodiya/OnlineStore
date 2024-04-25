import 'package:flutter/material.dart';
import 'package:productmaster/BGKEY/bgAmcKey.dart';
import 'package:productmaster/BGKEY/bgLicenceKey.dart';
import 'package:productmaster/BGKEY/bgUpdateKey.dart';
import 'package:productmaster/OnlineStore/productManage.dart';
import 'package:productmaster/OnlineStore/productPreview.dart';
import 'package:productmaster/UI/meetingMaster.dart';
import 'package:productmaster/UI/productmaster.dart';
import 'package:productmaster/UI/sendData.dart';
class MyDrawarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        const UserAccountsDrawerHeader(
          accountName: Text("Business Guru"),
          accountEmail: Text('7249887835'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              '',
              style: TextStyle(fontSize: 23.00),
            ),
          ),
        ),
        ListTile(
          title: const Text('Home'),
          leading: const Icon(Icons.home),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductMaster()),
            );
          },
        ),
     commenMenuName2( context),
        ListTile(
          title: const Text('Meeting Master'),
          leading: const Icon(Icons.meeting_room),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MeetingMaster()),
            );
          },
        ),
        ListTile(
          title: const Text('BG LICENCE KEY'),
          leading: const Icon(Icons.key),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BgLicenceKey()),
            );
          },
        ),
        ListTile(
          title: const Text('BG AMC KEY'),
          leading: const Icon(Icons.key),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BgAmcKey()),
            );
          },
        ),
        ListTile(
          title: const Text('BG UPDATE KEY'),
          leading: const Icon(Icons.key),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BgUpdateKey()),
            );
          },
        ),
        ListTile(
          title: const Text('Send Data'),
          leading: const Icon(Icons.data_array),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SendData()),
            );
          },
        ),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(Icons.logout_outlined),
          onTap: () async {},
        )
      ]),
    );
  }
  Widget commenMenuName2(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text('Online Store'),
          leading: const Icon(Icons.store),
          children: <Widget>[
            ListTile(
              title: const Text('Store Manage'),
              leading: const Icon(Icons.storefront_sharp),
              contentPadding:
                  EdgeInsets.only(left: 40.0), // Change the icon here
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductManage()),
                );
              },
            ),
            ListTile(
              title: const Text('Store Preview'),
              leading: const Icon(Icons.store_mall_directory),
              contentPadding:
                  EdgeInsets.only(left: 40.0), // Change the icon here
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StorePreview()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
