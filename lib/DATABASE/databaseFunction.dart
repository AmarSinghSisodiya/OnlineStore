import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:productmaster/DATABASE/database_Helpher.dart';
import '../error_handling.dart';
String uRL = 'https://savrajaipur.com/BG_API_NEW/';
Future getProductList(BuildContext context) async {
  List ProductList = [];
  String url = uRL + "" + "PRODUCT_LIST.php";
  http.Response? response = await http.post(Uri.parse(url), headers: {
    "Accept": "application/json"
  }, body: <String, String>{
    'appKeyCodeKey': "3939",
    'firmCodeKey': "5",
  });
  if (response.body.isNotEmpty) {
    // Check if JSON decoding was successful
    try {
      ProductList = jsonDecode(response.body);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error parsing JSON: $e"),
      ));
      // Handle the JSON parsing error here
      print("Error parsing JSON: $e");
    }
  }
  return ProductList;
}
Future<bool> insertProductMasterModel(
  List<Map<String, dynamic>> productMaps,
  BuildContext context,
) async {
  String url = uRL + "PRODUCT_CREATE_MASTER.php";
  http.Response? response;
  try {
    print('API Request URL: $url');
    print('API Request Headers: {"Accept": "application/json"}');
    print('API Request Body: ${productMaps.join('\n')}');
    response = await http.post(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
      body: jsonEncode(productMaps),
    );
    print('API Response Status Code: ${response.statusCode}');
    print('API Response Body: ${response.body}');
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          try {
            List<dynamic> responseBody = jsonDecode(response!.body);
            if (responseBody.isNotEmpty) {
              List<String> productCodes = [];
              for (var productData in responseBody) {
                String productCode =
                    productData['Product_Code'] as String? ?? '';
                productCodes.add(productCode);
                print('Product Code: $productCode');
              }
              DatabaseHelper().updateProductCodes(productCodes);
            } else {
              print('Unexpected response format: $responseBody');
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Error parsing JSON: $e"),
            ));
            print("Error parsing JSON: $e");
          }
        },
      );
      return true;
    } else {
      print('Failed to send data to API. Status Code: ${response.statusCode}');
      // Handle non-successful status codes if needed
      return false;
    }
  } catch (e) {
    print('Error sending data to API: $e');
    print('Response Status Code: ${response?.statusCode}');
    print('Response Body: ${response?.body}');
    return false;
  }
}
////////////////////////////Get All Product From API//////////////////
Future getAllProductstockList(
  BuildContext context,
) async {
  List? purchaseItemList = [];
  String url = uRL + "" + "PRODUCT_STOCK_DISPLAY.php";
  http.Response? response = await http.post(Uri.parse(url), headers: {
    "Accept": "application/json"
  }, body: <String, String>{
    'appKeyCodeKey': "3939",
    'firmCodeKey': "5",
  });
  httpErrorHandle(
    response: response,
    context: context,
    onSuccess: () {
      purchaseItemList = jsonDecode(response.body);
    },
  );
  return purchaseItemList;
}
Future<void> updateItems(
  List<File> imageFiles,
  int productCode, {
  String? message,
  double? salePrice,
  double? spRate2,
  double? spRate3,
  double? costPrice,
}) async {
  String url =
      uRL + "" + "Product_Image.php"; // Assuming uRL is defined somewhere else
  try {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['productCode'] = productCode.toString();
    request.fields['appKeyCodeKey'] = '3939'; // Converted to String
    request.fields['firmCodeKey'] = '5'; // Converted to String
    // Check if optional parameters are provided and add them to the request if available
    if (message != null) request.fields['message'] = message;
    if (salePrice != null) request.fields['salePrice'] = salePrice.toString();
    if (spRate2 != null) request.fields['spRate2'] = spRate2.toString();
    if (spRate3 != null) request.fields['spRate3'] = spRate3.toString();
    if (costPrice != null) request.fields['costPrice'] = costPrice.toString();
    for (int i = 0; i < imageFiles.length; i++) {
      File imageFile = imageFiles[i];
      print('Uploading image ${i + 1} for product: $productCode');
      String fileName = "${DateTime.now().millisecondsSinceEpoch % 1000}";
      final List<int> imageBytes = await imageFile.readAsBytes();
      String contentType = 'image/jpeg'; // Default to JPEG
      if (imageFile.path.toLowerCase().endsWith('.png')) {
        contentType = 'image/png';
      } else if (imageFile.path.toLowerCase().endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (imageFile.path.toLowerCase().endsWith('.jpg')) {
        contentType = 'image/jpeg';
      }
      final http.MultipartFile image = http.MultipartFile.fromBytes(
        'files[]',
        imageBytes,
        filename: '$fileName.${imageFile.path.split('.').last}',
        contentType: MediaType(
          contentType.split('/').first,
          contentType.split('/').last,
        ),
      );
      request.files.add(image);
    }
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      // Image upload successful
    } else {
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('Exception during image upload for product: $productCode');
    print('Error: $e');
  }
}
Future<void> uploadImagesFromWeb(
  List<Uint8List> imageDataList,
  int productCode,
  String message,
  double salePrice,
  double spRate2,
  double spRate3,
  double costPrice, 
) async {
  String url = uRL + "" + "Product_Image.php";
  final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['productCode'] = productCode.toString();
    request.fields['appKeyCodeKey'] = '3939'; // Converted to String
    request.fields['firmCodeKey'] = '5'; // Converted to String
    request.fields['costPrice'] = costPrice.toString();
    request.fields['message'] = message.toString();
    request.fields['salePrice'] = salePrice.toString();
    request.fields['spRate2'] = spRate2.toString();
    request.fields['spRate3'] = spRate3.toString();
  try {
    for (int i = 0; i < imageDataList.length; i++) {
      Uint8List imageData = imageDataList[i];
      print('Uploading image ${i + 1} for product: $productCode');
      String fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().second * (i + 1)}";
      final http.MultipartFile image = http.MultipartFile.fromBytes(
        'files[]',
        imageData,
        filename: '$fileName.png', // Assuming PNG format for simplicity
        contentType:
            MediaType('image', 'png'), // Specify image/png content type
      );
      request.files.add(image);
    }
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
    } else {
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('Exception during image upload for product: $productCode');
    print('Error: $e');
  }
}