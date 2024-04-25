import 'package:flutter/material.dart';

class TopNavigation extends StatelessWidget {
  final Function(String) onGroupTap;
  final List<String> groupOptions;

  const TopNavigation({
    Key? key,
    required this.onGroupTap,
    required this.groupOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color.fromARGB(255, 235, 236, 237),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groupOptions.length,
        itemBuilder: (context, index) {
          final group = groupOptions[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                onGroupTap(group);
              },
              child: Text(group),
            ),
          );
        },
      ),
    );
  }
}
