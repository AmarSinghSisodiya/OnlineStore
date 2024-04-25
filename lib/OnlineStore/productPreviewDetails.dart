import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productmaster/OnlineStore/productShare.dart';
import 'package:share_plus/share_plus.dart';
class StorePreviewDetail extends StatefulWidget {
  final Map<String, dynamic> displayedProduct;
  final VoidCallback onDataUpdated;
  // ignore: use_super_parameters
  const StorePreviewDetail({
    Key? key,
    required this.displayedProduct,
    required this.onDataUpdated,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _StorePreviewDetailState createState() => _StorePreviewDetailState();
}
class _StorePreviewDetailState extends State<StorePreviewDetail> {
  int _currentPage = 0;
  BoxFit _boxFit = BoxFit.cover;
  bool isSocialMediaSharingAvailable = true; // Set to true initially
////////////////////////////MOBILE VIEW CODE START////////////////////////////
  Widget _buildMobileView() {
    List<String> imageUrls = [];
    for (int i = 1; i <= 5; i++) {
      String imageUrl = widget.displayedProduct['Product_Image$i'] ?? '';
      if (imageUrl.isNotEmpty) {
        imageUrls.add(imageUrl);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _boxFit =
                        _boxFit == BoxFit.cover ? BoxFit.contain : BoxFit.cover;
                  });
                },
                child: Center(
                  child: imageUrls[index].isNotEmpty
                      ? Image.network(
                          'https://www.savrajaipur.com/BG_API_NEW/${imageUrls[index]}',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: _boxFit,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/products.png',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/products.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                        ),
                ),

              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        '${widget.displayedProduct["Product_Name"]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        '₹${widget.displayedProduct["Cost_Price"]}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // Handle button press
                },
                child: const Text('+Add'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6.0),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Product',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Text(
                'CATEGORIES: ${widget.displayedProduct["Group_Name"]}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
/////////////////////////////////////////////////Web code start /////////////////////////////
  Widget _buildWebView() {
    List<String> imageUrls = [];
    for (int i = 1; i <= 5; i++) {
      String imageUrl = widget.displayedProduct['Product_Image$i'] ?? '';
      if (imageUrl.isNotEmpty) {
        imageUrls.add(imageUrl);
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _boxFit = _boxFit == BoxFit.cover
                              ? BoxFit.contain
                              : BoxFit.cover;
                        });
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(
                              17.0), // Adjust padding as needed
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust radius as needed
                          ),
                          child: imageUrls[index].isNotEmpty
                              ? Image.network(
                                  'https://www.savrajaipur.com/BG_API_NEW/${imageUrls[index]}',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: _boxFit,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/products.png',
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/products.png',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imageUrls.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentPage
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 34,
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.displayedProduct["Product_Name"]}',
                  style: const TextStyle(fontSize: 30),
                ),
                Text(
                  '₹${widget.displayedProduct["Cost_Price"]}',
                  style: const TextStyle(
                      fontSize: 25,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.2, // Adjust width as needed
                  height: MediaQuery.of(context).size.height *
                      0.06, // Adjust width as needed
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    child: const Text('+ Add to Cart'),
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'About Product',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  'CATEGORIES: ${widget.displayedProduct["Group_Name"]}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Preview Details'),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    insetPadding: EdgeInsets.zero,
                    child: AlertDialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      content: ProductShare(
                        productName: widget.displayedProduct["Product_Name"],
                        groupName: widget.displayedProduct["Group_Name"],
                        cost: '₹${widget.displayedProduct["Cost_Price"]}',
                        productImageUrl:
                            'https://www.savrajaipur.com/BG_API_NEW/${widget.displayedProduct["Product_Image1"]}', // Provide the complete URL here
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
        ],
      ),
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