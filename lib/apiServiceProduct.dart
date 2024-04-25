import 'package:http/http.dart' as http;

import 'ModelClass/productMasterModel.dart';

class ApiService {
  static Future<bool> sendProductsToApi(List<ProductMasterModel> products) async {
    final url = Uri.parse('http://your-api-endpoint.com/send-to-mysql'); // Adjust the endpoint

    try {
   //   final List<Map<String, dynamic>> productList = products.map((product) => product.toMap()).toList();

      print('Sending the following data to API:');
   //   print(jsonEncode(productList));

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
   //     body: jsonEncode(productList),
      );

      if (response.statusCode == 200) {
        print('Data sent to API successfully');
        return true;
      } else {
        print('Failed to send data to API. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error sending request to API: $error');
      return false;
    }
  }
}
