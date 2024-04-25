import 'dart:io';
import 'dart:typed_data';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../DATABASE/databaseFunction.dart';
import '../Widget/top_Navigation.dart';
import 'productUpdate.dart';

class ProductManage extends StatefulWidget {
  const ProductManage({Key? key}) : super(key: key);
  @override
  _ProductManageState createState() => _ProductManageState();
}

class _ProductManageState extends State<ProductManage> {
  late List productList = [];
  late List displayedProductList = [];
  bool _isSearchOpened = false;
  late List<String> groupOptions = [
    "All",
    "General",
    "Shirt",
    "Pant",
    "T-shirt",
    "Top"
  ];
  String? selectedGroup;
  String _currentQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true; // Added loading indicator flag
  @override
  void initState() {
    super.initState();
    _fetchDataFromAPI();
  }

  Future<void> _fetchDataFromAPI() async {
    displayedProductList = await getAllProductstockList(context);
    productList = displayedProductList;
    setState(() {
      _isLoading = false;
    });
    print(productList);
  }

  void _navigateToUpdateScreen(BuildContext context, int index) {
    Map<String, dynamic> selectedProduct = displayedProductList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductUpdate(
          displayedProduct: selectedProduct,
          onDataUpdated: () {
            _fetchDataFromAPI();
          },
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _currentQuery = value;
      if (_currentQuery.isEmpty) {
        displayedProductList = productList;
      } else {
        displayedProductList = _filterProducts(_currentQuery);
      }
    });
  }

  void filterByGroup(String groupName) {
    setState(() {
      if (groupName == 'All') {
        displayedProductList = productList;
      } else {
        displayedProductList = productList
            .where((product) => product["Group_Name"]?.toString() == groupName)
            .toList();
      }
    });
    if (displayedProductList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items for selected group'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List _filterProducts(String query) {
    return productList.where((product) {
      final productName =
          product["Product_Name"]?.toString().toLowerCase() ?? '';
      return productName.contains(query.toLowerCase());
    }).toList();
  }

  Widget _loadProductImage(int index) {
    String imageUrl = displayedProductList[index]['Product_Image1'];
    print('Network URL: https://www.savrajaipur.com/BG_API_NEW/$imageUrl');
    return imageUrl.isNotEmpty
        ? Image.network(
            'https://www.savrajaipur.com/BG_API_NEW/$imageUrl',
            width: 50,
            height: 50,
            fit: BoxFit.cover, // Adjust the fit based on your preference
          )
        : Image.asset(
            'assets/plus.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover, // Adjust the fit based on your preference
          );
  }

  Future<void> _pickImage(BuildContext context, int productCode) async {
    if (kIsWeb) {
      html.InputElement uploadInput =
          html.FileUploadInputElement() as html.InputElement;
      uploadInput.multiple = true;
      uploadInput.draggable = true;
      uploadInput.accept = 'image/*';
      uploadInput.click();
      uploadInput.onChange.listen((event) async {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          List<Uint8List> imageDataList = [];
          for (final file in files as List<html.File>) {
            // Cast to List<html.File>
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file);
            await reader.onLoad.first;
            final Uint8List data =
                Uint8List.fromList(reader.result as List<int>);
            imageDataList.add(data);
          }
          await uploadImagesFromWeb(
            imageDataList,
            productCode,
            'Web message',
            0.0, // Sale price, replace with actual value
            0.0, // SP rate 2, replace with actual value
            0.0, // SP rate 3, replace with actual value
            0.0, // Cost price, replace with actual value
          );
          _fetchDataFromAPI();
        } else {
          print('User cancelled picking images');
        }
      });
    } else {
      final ImagePicker _imagePicker = ImagePicker();
      final XFile? pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await updateItems(
          [imageFile],
          productCode,
          message: 'Mobile message',
          salePrice: 0.0, // Sale price, replace with actual value
          spRate2: 0.0, // SP rate 2, replace with actual value
          spRate3: 0.0, // SP rate 3, replace with actual value
          costPrice: 0.0, // Cost price, replace with actual value
        );
        _fetchDataFromAPI();
      } else {
        print('User cancelled picking images');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSearchOpened) {
          setState(() {
            _isSearchOpened = false;
            _searchController.clear();
            displayedProductList = productList;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSearchOpened
              ? TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search Product...',
                    border: InputBorder.none,
                  ),
                )
              : const Text('Product Manage'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchOpened = !_isSearchOpened;
                  if (!_isSearchOpened) {
                    _searchController.clear();
                    displayedProductList = productList;
                  }
                });
              },
            ),
            if (_isSearchOpened)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSearchOpened = false;
                    _searchController.clear();
                    displayedProductList = productList;
                  });
                },
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TopNavigation(
                    onGroupTap: (groupName) {
                      setState(() {
                        selectedGroup = groupName;
                      });
                      filterByGroup(groupName);
                    },
                    groupOptions: groupOptions,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          kBottomNavigationBarHeight,
                      child: ListView.builder(
                        itemCount: displayedProductList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              _navigateToUpdateScreen(context, index);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(2.0),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: InkWell(
                                    onTap: () {
                                      int productCode = int.tryParse(
                                            displayedProductList[index]
                                                    ["Product_Code"]
                                                .toString(),
                                          ) ??
                                          0;
                                      _pickImage(context, productCode);
                                    },
                                    child: _loadProductImage(index),
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: false,
                                      child: Text(
                                        displayedProductList[index]
                                                ["Product_Code"]
                                            .toString(),
                                      ),
                                    ),
                                    Text(
                                      displayedProductList[index]
                                              ["Product_Name"]
                                          .toString(),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '₹ ${displayedProductList[index]["Cost_Price"].toString()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}