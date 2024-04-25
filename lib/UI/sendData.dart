import 'dart:async';
import 'package:flutter/material.dart';
import 'package:productmaster/ModelClass/productMasterModel.dart';
import 'package:productmaster/apiServiceProduct.dart';

import '../DATABASE/database_Helpher.dart';

class SendData extends StatefulWidget {
  const SendData({Key? key}) : super(key: key);

  @override
  _SendDataState createState() => _SendDataState();
}

class _SendDataState extends State<SendData> {
  late List<ProductMasterModel> productList = [];
  final dbHelper = DatabaseHelper();
  late Timer _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    _fetchData();

    // Start a periodic timer to send data every 30 seconds
    _timer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      _sendDataToDatabase();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  Future<void> _fetchData() async {
    await dbHelper.initDatabase();
    final products = await dbHelper.database!.transaction((txn) async {
      return await dbHelper.getNewProductList(txn);
    });

    setState(() {
      productList = products;
    });
  }

  Future<void> _sendDataToDatabase() async {
    if (productList.isEmpty) {
      print('No pending products to send.');
      return;
    }

    // Now, send the pending products to your MySQL database
    final success = await ApiService.sendProductsToApi(productList);

    if (success) {
      // Update sentToApi for all pending products
    //  await dbHelper.updateProductsSentToApi(productList);
      print('Data sent successfully to API for pending products.');
      _fetchData(); // Refresh the list after sending data
    } else {
      print('Failed to send data to API for some products.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Pending Data'),
      ),
      body: productList.isEmpty
          ? Center(child: Text('No pending products.'))
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return ListTile(
                  title: Text(product.productName ?? 'N/A'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${product.productCode}'),
                      Text('Product Name: ${product.productName}'),
                      Text('Barcode: ${product.printName}'),
                      Text('Group: ${product.groupCode}'),
                      Text('Description: ${product.message}'),
                      Text('HSN Code: ${product.hsnCode}'),
                      Text('Unit: ${product.unit}'),
                      Text('GST: ${product.gst}'),
                      Text('Cost Price: ${product.costPrice}'),
                      Text('MRP: ${product.salePrice}'),
                      Text('Rate: ${product.wholeSalePrice}'),
                      Text('Discount: ${product.discount}%'),
                      Text('Opening Stock: ${product.openingStock}'),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendDataToDatabase,
        child: const Icon(Icons.send),
      ),
    );
  }
}
