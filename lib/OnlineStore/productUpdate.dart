import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:productmaster/OnlineStore/productShare.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../DATABASE/databaseFunction.dart';
import '../ModelClass/productMasterModel.dart';
import '../Widget/widgetInputText.dart';

class ProductUpdate extends StatefulWidget {
  final Map<String, dynamic> displayedProduct;
  final VoidCallback onDataUpdated;
  const ProductUpdate({
    Key? key,
    required this.displayedProduct,
    required this.onDataUpdated,
  }) : super(key: key);
  @override
  _ProductUpdateState createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  late ProductMasterModel displayedProductList;

  late List displayedImage = [];
  bool isSocialMediaSharingAvailable = true; // Set to true initially
  late Map<int, List<XFile>> selectedImages;
  late TextEditingController productNameController;
  late TextEditingController costPriceController;
  late TextEditingController messageController;
  late TextEditingController rateOneController;
  late TextEditingController rateTwoController;
  late TextEditingController productCodeController;
  late TextEditingController rateThreeController;
  late TextEditingController rateFourController;
  late TextEditingController productMarathiController;
  bool showSpinner = false;
  @override
  void initState() {
    super.initState();
    displayedProductList = ProductMasterModel.fromMap(widget.displayedProduct);
    productNameController =
        TextEditingController(text: displayedProductList.productName);
    costPriceController =TextEditingController(text: displayedProductList.costPrice.toString());
    messageController =TextEditingController(text: displayedProductList.message);
    productCodeController = TextEditingController(text: displayedProductList.productCode.toString());
    rateOneController =TextEditingController(text: displayedProductList.salePrice.toString());
    rateTwoController =TextEditingController(text: displayedProductList.spRate2.toString());
    rateThreeController = TextEditingController(text: displayedProductList.spRate3.toString());
    rateFourController =TextEditingController(text: displayedProductList.costPrice.toString());
    productMarathiController = TextEditingController(text: displayedProductList.productMarathi.toString());

    selectedImages = {};
  }

Future<void> _updateProduct() async {
  String productCodeText = productCodeController.text;
  print('Product Code Text: $productCodeText'); // Add this line

  if (productCodeText.isNotEmpty) {
    int? productCode = int.tryParse(productCodeText);
    print('Parsed Product Code: $productCode'); // Add this line

    if (productCode != null) {
      double costPrice = double.parse(costPriceController.text);
      double salePrice = double.parse(rateOneController.text);
      double spRate2 = double.parse(rateTwoController.text);
      double spRate3 = double.parse(rateThreeController.text);
      String message = messageController.text; // Changed

      try {
        await updateItems(
          displayedImage.map((imagePath) => File(imagePath)).toList(),
          productCode,
          message: message, // Updated with optional parameter
          salePrice: salePrice,
          spRate2: spRate2,
          spRate3: spRate3,
          costPrice: costPrice,
        );
        widget.onDataUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update product!'),
            backgroundColor: Colors.red,
          ),
        );
        print('Error updating product: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid product code format!'),
          backgroundColor: Colors.red,
        ),
      );
      print('Invalid product code format!');
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product code is empty!'),
        backgroundColor: Colors.red,
      ),
    );
    print('Product code is empty!');
  }
}
  Future<void> _pickImage(BuildContext context, int productCode,
      int appKeyCodeKey, int firmCodeKey) async {
    final ImagePicker _imagePicker = ImagePicker();
    final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<File> imageFiles = [];
      for (final pickedFile in pickedFiles) {
        final imageFile = File(pickedFile.path);
        imageFiles.add(imageFile);
      }
      await updateItems(
        imageFiles,
        productCode,
        message: messageController.text,
        salePrice: double.parse(rateOneController.text),
        spRate2: double.parse(rateTwoController.text),
        spRate3: double.parse(rateThreeController.text),
        costPrice: double.parse(costPriceController.text),
      );
      setState(() {
        displayedImage = pickedFiles.map((file) => file.path).toList();
      });
    } else {
      print('User cancelled picking images');
    }
  }


  Future<void> _pickImageFromWeb(BuildContext context, int productCode) async {
    final html.InputElement input = html.InputElement(type: 'file');
    input.multiple = true;
    input.accept = 'image/*';
    final html.FileUploadInputElement fileInput =
        input as html.FileUploadInputElement;
    fileInput.click();
    fileInput.onChange.listen((event) async {
      final List<html.File>? files = fileInput.files;
      if (files != null && files.isNotEmpty) {
        List<Uint8List> imageDataList = [];
        for (final html.File file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          await reader.onLoad.first; // Wait for the reader to load the file
          final Uint8List data = Uint8List.fromList(reader.result as List<int>);
          imageDataList.add(data);
        }
        await uploadImagesFromWeb(
          imageDataList,
           productCode,
  messageController.text, // Assuming messageController holds the message text
        double.parse(rateOneController
            .text), // Assuming salePrice is in rateOneController
        double.parse(
            rateTwoController.text), // Assuming spRate2 is in rateTwoController
        double.parse(rateThreeController
            .text), // Assuming spRate3 is in rateThreeController
        double.parse(costPriceController
            .text), // Assuming costPrice is in costPriceController
        );
      } else {
        print('User cancelled picking images');
      }
    });
  }

  ////////////////////////////////////////////////////////////////Mobile view code start/////////////////////////////////////////////////////////////////////////////////
  Widget _buildMobileView() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90, // Provide a fixed height to constrain the ListView
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      1, // You can change this to the number of items you have
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 20);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
    String productCode = displayedProductList.productCode.toString();
                            _pickImage(context, int.parse(productCode), 3939, 5);
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(10.0),
                            color: const Color.fromARGB(255, 223, 227, 230),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/addphoto.png',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                const Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 90,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final imagePath in displayedImage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      child: imagePath.startsWith('http')
                                          ? Image.network(
                                              imagePath,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(imagePath),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Divider(),
              const Text(
                'Item Info',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Product Name',
                controller: productNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Price',
                controller: costPriceController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns widgets at the top
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate',
                              controller: rateOneController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width:
                              10.0), // Adds some space between the text fields
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate 2',
                              controller: rateTwoController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns widgets at the top
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate 3',
                              controller: rateThreeController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width:
                              10.0), // Adds some space between the text fields
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate 4',
                              controller: rateFourController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Description',
                controller: messageController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Product Marathi',
                controller: productMarathiController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 30.0),
              Container(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: showSpinner
                      ? CircularProgressIndicator() // Show loading indicator
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: TextButton(
                            onPressed:
                                _updateProduct, // Call _updateProductWithLoading
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: const Text(
                              "UPDATE",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////Web View Code Start////////////////////////////////////////////////////

  Widget _buildWebView() {
    // Implement the UI for the web view layout here
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150, // Provide a fixed height to constrain the ListView
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      1, // You can change this to the number of items you have
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 20);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                              String productCode = displayedProductList.productCode.toString();
                            _pickImageFromWeb(context, int.parse(productCode));
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            padding: const EdgeInsets.all(10.0),
                            color: ui.Color.fromARGB(255, 174, 175, 176),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/addphoto.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                const Text(
                                  'Add Photo',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 150,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final imagePath in displayedImage)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      child: imagePath.startsWith('http')
                                          ? Image.network(
                                              imagePath,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(imagePath),
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Divider(),
              const Text(
                'Item Info',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Product Name',
                controller: productNameController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Price',
                controller: costPriceController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 10.0),
              Column(
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns widgets at the top
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate',
                              controller: rateOneController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width:
                              10.0), // Adds some space between the text fields
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate 2',
                              controller: rateTwoController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligns widgets at the top
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate 3',
                              controller: rateThreeController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width:
                              10.0), // Adds some space between the text fields
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text fields to the left
                          children: [
                            SizedBox(height: 10.0),
                            WidgetTextField(
                              labelText: 'Rate 4',
                              controller: rateFourController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              WidgetTextField(
                labelText: 'Description',
                controller: messageController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 10.0),
              WidgetTextField(
                labelText: 'Product Marathi',
                controller: productMarathiController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 30.0),
              Container(
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
                      onPressed: _updateProduct,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: const Text(
                        "UPDATE",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Items'), actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: AlertDialog(
                    shadowColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.white,
                    title: const Text(
                      'Product Info :-',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    content: ProductShare(
                      productName: productNameController.text,
                      cost: costPriceController.text,
                      groupName: messageController.text,
                    ),
                    actionsPadding: EdgeInsets.zero,
                    actions: <Widget>[
                      if (isSocialMediaSharingAvailable)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () async {
                              await _shareProductInfo(context);
                            },
                            child: Icon(Icons.share, color: Colors.black),
                          ),
                        ),
                      if (isSocialMediaSharingAvailable)
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close, color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.share,
              color: Color.fromARGB(255, 15, 15, 15),
              size: 30.0,
            ),
          ),
        ),
      ]),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          if (maxWidth < 900) {
            return _buildMobileView();
          } else {
            return _buildWebView();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    productNameController.dispose();
    costPriceController.dispose();
    productMarathiController.dispose();
    rateOneController.dispose();
    rateTwoController.dispose();
    rateThreeController.dispose();
    rateFourController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _shareProductInfo(BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary;
      context.visitAncestorElements((element) {
        if (element.renderObject is RenderRepaintBoundary) {
          boundary = element.renderObject as RenderRepaintBoundary;
          return false; // Stop visiting ancestors
        }
        return true; // Continue visiting ancestors
      });
      if (boundary != null) {
        ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/product_info.png').create();
        await file.writeAsBytes(pngBytes);
        await Share.shareXFiles([XFile('${file.path}')], text: 'Check out this product');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error sharing product info!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sharing product info!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
