import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productmaster/Widget/top_Navigation.dart';
import 'package:share_plus/share_plus.dart';
import '../DATABASE/databaseFunction.dart';
import 'productPreviewDetails.dart';

class StorePreview extends StatefulWidget {
  const StorePreview({Key? key}) : super(key: key);
  @override
  _StorePreviewState createState() => _StorePreviewState();
}
class _StorePreviewState extends State<StorePreview> {
  late List productList = [];
  late List displayedProductList = [];
  bool _isSearchOpened = false;
  late List<String> groupOptions = [ "All", "General", "Shirt", "Pant", "T-shirt", "Top"];
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

  void _navigateToStorePreviewDetails(BuildContext context, int index) {
    Map<String, dynamic> selectedProduct = displayedProductList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StorePreviewDetail(
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


 void _shareToSocialMedia(String text) {
    String baseUrl = 'https://bgonline.savrajaipur.com';
    // Generate random digits
    String randomDigits = '${"3939"}/${"5"}';
    String fullUrl = '$baseUrl$randomDigits';
    Share.share('$text\n$fullUrl');
  }
  



  Widget _loadProductImage(int index) {
    String imageUrl = displayedProductList[index]['Product_Image1'];
    print('Network URL: https://www.savrajaipur.com/BG_API_NEW/$imageUrl');
    return Container(
      width: 70,
      height: 70,
      color:
          Color.fromARGB(255, 244, 244, 244), // Set the background color here
      child: imageUrl.isNotEmpty
          ? Image.network(
              'https://www.savrajaipur.com/BG_API_NEW/$imageUrl',
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/products.png',
              fit: BoxFit.contain,
            ),
    );
  }

  Widget _buildMobileView() {
    return _isLoading
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
                          _navigateToStorePreviewDetails(context, index);
                        },
                        child: Card(
                          margin: const EdgeInsets.all(2.0),
                          child: ListTile(
                            leading: SizedBox(
                              height: 60,
                              width: 60,
                              child: _loadProductImage(index),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    displayedProductList[index]["Product_Code"]
                                        .toString(),
                                  ),
                                ),
                                Text(
                                  displayedProductList[index]["Product_Name"]
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
                            trailing: OutlinedButton(
                              onPressed: () {
                                // Action to perform when button is pressed
                              },
                              child: const Text('+Add'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildWebView() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // Assuming TopNavigation is your custom widget for navigation
              TopNavigation(
                onGroupTap: (groupName) {
                  setState(() {
                    selectedGroup = groupName;
                  });
                  filterByGroup(groupName);
                },
                groupOptions: groupOptions,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: displayedProductList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        _navigateToStorePreviewDetails(context, index);
                      },
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: _loadProductImage(index),
                              ),
                            ),
                            // Product Name
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                displayedProductList[index]["Product_Name"]
                                    .toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Price
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    '₹ ${displayedProductList[index]["Cost_Price"].toString()}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                // Add to Cart Button
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // Action to perform when button is pressed
                                        },
                                        child: const Text('+Add'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
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
                    hintText: 'Search Store Products...',
                    border: InputBorder.none,
                  ),
                )
              : const Text('Store Preview'),
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
                            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                 _shareToSocialMedia(
                  'Hello! Now place orders from your home and get attractive discounts. Check out my Online Store now:',
                );
              },
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
      ),
    );
  }
}