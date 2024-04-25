import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:productmaster/DATABASE/databaseProductMaster.dart';
import 'package:productmaster/Drawer/MyDrawarCard.dart';
import 'package:productmaster/Widget/calculation.dart';

import '../DATABASE/database_Helpher.dart';
import '../Widget/dropdown.dart';
import '../Widget/list_Options.dart';
import '../Widget/widgetInputText.dart';

class ProductMaster extends StatefulWidget {
  const ProductMaster({Key? key}) : super(key: key);
  @override
  _ProductMasterState createState() => _ProductMasterState();
}

class _ProductMasterState extends State<ProductMaster> {
  final DatabaseProductMaster productDatabase = DatabaseProductMaster();
  final DatabaseHelper dbHelper = DatabaseHelper();
  String selectedGroup = 'Group';
  String selectedUnit = 'Unit';
  String selectedGST = 'GST';
  late ListOptions listOptions;
  Timer? revertTimer;
  // Text editing controllers for various input fields
  TextEditingController controllerBarcode = TextEditingController();
  TextEditingController isPending = TextEditingController();
  TextEditingController controllerHsnCode = TextEditingController();
  TextEditingController controllerCostPrice = TextEditingController();
  TextEditingController controllerProductName = TextEditingController();
  TextEditingController controllerMrp = TextEditingController();
  TextEditingController controllerDiscount = TextEditingController();
  TextEditingController controllerRate = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();
  TextEditingController controllerOpeningStock = TextEditingController();
  // Focus nodes for handling text field focus
  FocusNode productNameFocusNode = FocusNode();
  FocusNode barcodeFocusNode = FocusNode();
  FocusNode selectgroupsFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode hsnCodeFocusNode = FocusNode();
  FocusNode unitFocusNode = FocusNode();
  FocusNode gstFocusNode = FocusNode();
  FocusNode costPriceFocusNode = FocusNode();
  FocusNode mrpFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  FocusNode discountFocusNode = FocusNode();
  FocusNode openingStockFocusNode = FocusNode();
  // Function to clear input field values
  void clearvalue() {
    controllerBarcode.clear();
    controllerHsnCode.clear();
    controllerCostPrice.clear();
    controllerProductName.clear();
    controllerMrp.clear();
    controllerDiscount.clear();
    controllerRate.clear();
    isPending.clear();
    controllerDescription.clear();
    controllerOpeningStock.clear();
  }

  // Dispose of focus nodes and cancel the timer
  @override
  void dispose() {
    productNameFocusNode.dispose();
    barcodeFocusNode.dispose();
    selectgroupsFocusNode.dispose();
    descriptionFocusNode.dispose();
    hsnCodeFocusNode.dispose();
    unitFocusNode.dispose();
    isPending.dispose();
    gstFocusNode.dispose();
    costPriceFocusNode.dispose();
    mrpFocusNode.dispose();
    rateFocusNode.dispose();
    discountFocusNode.dispose();
    openingStockFocusNode.dispose();
    revertTimer?.cancel();
    super.dispose();
  }

  // Function to move focus to the next text field
  void moveToNextField(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void updateRateAndDiscount() {
    Calculation.updateRateAndDiscount(
      mrpController: controllerMrp,
      rateController: controllerRate,
      discountController: controllerDiscount,
      discountFocusNode: discountFocusNode,
    );
  }

  void updateRate() {
    Calculation.updateRate(
      mrpController: controllerMrp,
      discountController: controllerDiscount,
      rateController: controllerRate,
    );
  }

  void updateDiscount() {
    Calculation.updateDiscount(
      mrpController: controllerMrp,
      rateController: controllerRate,
      discountController: controllerDiscount,
    );
  }

  // Function to scan a barcode using the device's camera
  Future<String?> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (barcode == '-1') {
        return null;
      }
      return barcode;
    } catch (e) {
      print('Error scanning barcode: $e');
      return null;
    }
  }

///////////////////////InitState code started//////////////////////////////
  @override
  void initState() {
    super.initState();
    // Start the timer for auto-reverting changes
    productDatabase.startRevertTimer();
    // Fetch data from JSON file and update the state
    fetchData().then((options) {
      setState(() {
        listOptions = options;
      });
    });
    mrpFocusNode.addListener(() {
      if (!mrpFocusNode.hasFocus) {
        if (controllerRate.text.isEmpty) {
          double mrp = double.tryParse(controllerMrp.text) ?? 0;
          controllerRate.text = mrp.toStringAsFixed(2);
          updateDiscount();
        }
        updateRateAndDiscount();
      }
    });
    rateFocusNode.addListener(() {
      if (controllerRate.text.isEmpty && controllerDiscount.text.isEmpty) {
        double mrp = double.tryParse(controllerMrp.text) ?? 0;
        controllerRate.text = mrp.toStringAsFixed(2);
        controllerDiscount.text = '0.00';
      }
    });
  }

///////////////////////InitState code finished//////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Master'),
      ),
      drawer: MyDrawarCard(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 2.0),
                    WidgetTextField(
                      controller: controllerProductName,
                      focusNode: productNameFocusNode,
                      labelText: 'Product Name',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(productNameFocusNode, barcodeFocusNode);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: controllerBarcode,
                      focusNode: barcodeFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Barcode',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code),
                          onPressed: () async {
                            String? barcode = await _scanBarcode();
                            if (barcode != null) {
                              setState(() {
                                controllerBarcode.text = barcode;
                              });
                              moveToNextField(
                                  barcodeFocusNode, selectgroupsFocusNode);
                            }
                          },
                        ),
                      ),
                      onEditingComplete: () {
                        moveToNextField(
                            barcodeFocusNode, selectgroupsFocusNode);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    DropdownWidget(
                      selectedValue: selectedGroup,
                      options: listOptions.groupOptions,
                      labelText: 'Select Group',
                      onTap: (value) {
                        setState(() {
                          selectedGroup = value;
                        });
                      },
                      focusNode: selectgroupsFocusNode,
                    ),
                    const SizedBox(height: 10.0),
                    WidgetTextField(
                      controller: controllerDescription,
                      focusNode: descriptionFocusNode,
                      labelText: 'Description',
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        moveToNextField(descriptionFocusNode, hsnCodeFocusNode);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    WidgetTextField(
                      controller: controllerHsnCode,
                      focusNode: hsnCodeFocusNode,
                      labelText: 'HSN Code(GST)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onEditingComplete: () {
                        moveToNextField(hsnCodeFocusNode, unitFocusNode);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    DropdownWidget(
                      selectedValue: selectedUnit,
                      options: listOptions.unitGroupOptions,
                      labelText: 'Select Group',
                      onTap: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                      focusNode: selectgroupsFocusNode,
                    ),
                    const SizedBox(height: 10.0),
                    DropdownWidget(
                      selectedValue: selectedGST,
                      options: listOptions.selectedGSTOptions,
                      labelText: 'Select GST',
                      onTap: (value) {
                        setState(() {
                          selectedGST = value;
                        });
                      },
                      focusNode: gstFocusNode,
                    ),
                    const SizedBox(height: 10.0),
                    WidgetTextField(
                      controller: controllerCostPrice,
                      focusNode: costPriceFocusNode,
                      labelText: 'Cost Price (PUR)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onEditingComplete: () {
                        moveToNextField(costPriceFocusNode, mrpFocusNode);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: WidgetTextField(
                            controller: controllerMrp,
                            focusNode: mrpFocusNode,
                            labelText: 'MRP',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (value) {
                              controllerRate.text = '';
                            },
                            onEditingComplete: () {
                              if (controllerRate.text.isEmpty) {
                                double mrp =
                                    double.tryParse(controllerMrp.text) ?? 0;
                                controllerRate.text = mrp.toStringAsFixed(2);
                                updateDiscount();
                              }
                              moveToNextField(mrpFocusNode, rateFocusNode);
                              updateRateAndDiscount();
                            },
                            // Add any other required parameters or callbacks here
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: WidgetTextField(
                            controller: controllerRate,
                            focusNode: rateFocusNode,
                            labelText: 'Rate',
                            onChanged: (value) {
                              updateDiscount();
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onEditingComplete: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    WidgetTextField(
                      controller: controllerDiscount,
                      focusNode: discountFocusNode,
                      labelText: 'Discount',
                      onChanged: (value) {
                        if (!rateFocusNode.hasFocus) {
                          updateRate();
                        }
                      },
                      onEditingComplete: () {
                        moveToNextField(
                            discountFocusNode, openingStockFocusNode);
                        updateRate();
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    WidgetTextField(
                      controller: controllerOpeningStock,
                      focusNode: openingStockFocusNode,
                      labelText: 'Opening Stock',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onEditingComplete: () {
                        moveToNextField(
                            openingStockFocusNode, openingStockFocusNode);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    // Check if product name is empty
                    if (controllerProductName.text.isEmpty) {
                      // Show a snackbar indicating that product name cannot be empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product name cannot be empty'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Try to save the product to the database
                      try {
                        await productDatabase.saveProductToDatabase(
                          context: context,
                          selectedGroup: selectedGroup,
                          controllerProductName: controllerProductName,
                          controllerBarcode: controllerBarcode,
                          controllerDescription: controllerDescription,
                          hsnCodeController:
                              controllerHsnCode, // Make sure to include this line
                          selectedUnit: selectedUnit,
                          selectedGST: selectedGST,
                          costPriceController: controllerCostPrice,
                          mrpController: controllerMrp,
                          rateController: controllerRate,
                          discountController: controllerDiscount,
                          openingStockController: controllerOpeningStock,
                        );
                        clearvalue();
                        await dbHelper.setAllProducts();
                        productDatabase.startRevertTimer();
                      } catch (e) {
                        // Print an error message if there's an issue saving the product
                        print("Error saving product: $e");
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
