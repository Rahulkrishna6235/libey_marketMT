import 'package:dio/dio.dart';
import 'package:libey_mt/model/product.dart';

class ProductRepo {
  Future<List<Productmodal>?> getProducts() async {
    try {
      var dio = Dio();
      var response = await dio.get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['products'];

        List<Productmodal> products = responseData
            .map((json) => Productmodal.fromJson(json))
            .toList();

        return products;
      } else {
        print("Server error: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Exception while fetching products: $e");
      return null;
    }
  }
}
