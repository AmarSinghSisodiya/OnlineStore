import 'package:flutter/material.dart';
import 'dart:async';

import 'package:productmaster/DATABASE/database_Helpher.dart';
import 'package:productmaster/ModelClass/productMasterModel.dart';

class DatabaseProductMaster {
  final DatabaseHelper dbHelper = DatabaseHelper();
  Timer? revertTimer;

  Future<void> saveProductToDatabase({
    required BuildContext context,
    required String selectedGroup,
    required TextEditingController controllerProductName,
    required TextEditingController controllerBarcode,
    required TextEditingController controllerDescription,
    required TextEditingController hsnCodeController,
    required String selectedUnit,
    required String selectedGST,
    required TextEditingController costPriceController,
    required TextEditingController mrpController,
    required TextEditingController rateController,
    required TextEditingController discountController,
    required TextEditingController openingStockController,
  }) async {
    bool productExists = await dbHelper.doesProductExist(
      selectedGroup,
      controllerProductName.text,
    );

    if (productExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product with the same group and name already exists'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool isPending = true;
    bool sentToApiValue = false;
    DateTime now = DateTime.now();

    ProductMasterModel product = ProductMasterModel(
      productName: controllerProductName.text,
      printName: controllerBarcode.text,
      groupCode: selectedGroup,
      message: controllerDescription.text,
      hsnCode: hsnCodeController.text,
      pendingFlag: isPending,
      unit: selectedUnit,
      gst: selectedGST,
      costPrice: (double.tryParse(costPriceController.text) ?? 0).toDouble(),
      salePrice: (double.tryParse(mrpController.text) ?? 0).toDouble(),
      wholeSalePrice: (double.tryParse(rateController.text) ?? 0).toDouble(),
      sentToApi: sentToApiValue,
      discount:
          (double.tryParse(discountController.text.replaceAll('%', '')) ?? 0.0)
              .toDouble(),
      openingStock: int.tryParse(openingStockController.text) ?? 0,
      createdAt: now,
    );

    int result = await dbHelper.insertProduct(product);

    if (result != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product saved successfully'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving product'),
          backgroundColor: Colors.red,
        ),
      );
    }

    print('Pending Flag: ${product.pendingFlag ? '1' : '0'}');
    updatePendingProducts();
  }

  void updatePendingProducts() async {
    await dbHelper.setAllProducts();
    startRevertTimer();
  }

  void startRevertTimer() {
    revertTimer?.cancel();
    revertTimer = Timer(const Duration(seconds: 30), () async {
      await dbHelper.setNewProductsPendingFlag(0);
      print('PendingFlag reverted to 0 for new products after 30 seconds');
    });
  }
}
