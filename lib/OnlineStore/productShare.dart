import 'package:flutter/material.dart';

class ProductShare extends StatelessWidget {
  final String productName;
  final String cost;
  final String groupName;
  final String? productImageUrl; // Accept product image URL

  const ProductShare({
    Key? key,
    required this.productName,
    required this.groupName,
    required this.cost,
    this.productImageUrl, // Initialize product image URL parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0), // Add padding to avoid edge sticking
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items to start (top)
        children: [
          const Text(
            'Product Info :-',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Divider(),
          if (productImageUrl != null && productImageUrl!.isNotEmpty)
            Image.network(
              productImageUrl!,
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              fit: BoxFit.cover, // Adjust fit as needed
            ),
          Text(
            '$productName',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Cost: $cost',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Categories: $groupName',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
