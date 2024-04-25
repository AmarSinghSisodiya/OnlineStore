// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../DATABASE/database_Helpher.dart';
// import '../ModelClass/productMasterModel.dart';
// import '../Widget/top_Navigation.dart';

// class ProdcuctManage extends StatefulWidget {
//   const ProdcuctManage({Key? key}) : super(key: key);
//   @override
//   _ProdcuctManageState createState() => _ProdcuctManageState();
// }

// class _ProdcuctManageState extends State<ProdcuctManage> {
//   late List<ProductMasterModel> allProductList = [];
//   final databaseHelper = DatabaseHelper();
//   String? selectedGroup;
//   late ImagePicker _imagePicker;
//   Map<int, XFile?> selectedImages = {};
//   @override
//   void initState() {
//     super.initState();
//       print('initState called');

//     _initializeData();
//     _imagePicker = ImagePicker();
//   }

//   Future<void> _initializeData() async {
//     await _fetchData();
//     // Initialize with existing product images
//     for (int index = 0; index < allProductList.length; index++) {
//       final product = allProductList[index];
//       // Check if the image already exists in selectedImages
//       if (product.imagePath != null) {
//         selectedImages[product.id!] = XFile(product.imagePath!);
//       } else {
//         // If imagePath is null, set null for new products
//         selectedImages[product.id!] = null;
//       }
//     }
//   }

//   Future<void> _fetchData() async {
//       print('_fetchData called');

//     await databaseHelper.initDatabase();
//     final products = await databaseHelper.database!.transaction((txn) async {
//       return await databaseHelper.getAllProducts(txn);
//     });
//     for (final product in products) {
//     print('Product: ${product.productName}, Group Code: ${product.groupCode}');
//   }
//     setState(() {
//       allProductList = products;
//     });
//   }

//   Future<void> _pickImage(int productId) async {
//     final XFile? pickedFile =
//         await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       // Update the product in the database with the selected image path
//     //  await databaseHelper.updateProductImage(productId, pickedFile.path);
//       // Update the selectedImages map
//       setState(() {
//         selectedImages[productId] = pickedFile;
//       });
//     } else {
//       print('Image picking cancelted or failed');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Manage'),
//       ),
//       body: Column(
//         children: [
//          TopNavigation(
//             onGroupTap: (groupCode) {
//               setState(() {
//                 selectedGroup = (groupCode == 'All') ? null : groupCode;
//               });
//             },
//             groupOptions: const ["All", "General", "Shirt", "Pant", "T-shirt", "Top"],
//           ),   Expanded(
//             child: SingleChildScrollView(
//               child: Container(
//                 padding: const EdgeInsets.all(0.0),
//                 child: allProductList.isEmpty
//                     ? const Center(child: Text('No product found'))
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: allProductList.length,
//                         itemBuilder: (context, index) {
//                           final product = allProductList.reversed.toList()[index];
//                           if ((selectedGroup == null ||  product.groupCode == selectedGroup)) {
//                             return Card(
//                               margin: const EdgeInsets.all(2.0),
//                               child: ListTile(
//                                 leading: GestureDetector(
//                                   onTap: () => _pickImage(product.id!),
//                                   child: _buildProductImage(product.id!),
//                                 ),
//                                 title: Text(product.productName ?? 'N/A'),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '₹ ${product.costPrice}',
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           } else {
//                                 print('Not matching filters');

//                             return Container(); // Return an empty container if not matching the selected filters
//                           }
//                         },
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildProductImage(int productId) {
//     final imageFile = selectedImages[productId];
//   if (imageFile != null && File(imageFile.path).existsSync()) {
//       return Image.file(
//         File(imageFile.path),
//         width: 50,
//         height: 50,
//         fit: BoxFit.cover,
//       );
//     } else {
//       return Image.asset(
//         'assets/plus.png',
//         width: 50,
//         height: 50,
//         fit: BoxFit.cover,
//       );
//     }
//   }
// }