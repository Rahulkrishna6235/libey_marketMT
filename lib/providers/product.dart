import 'package:flutter/foundation.dart';
import 'package:libey_mt/model/product.dart';
import 'package:libey_mt/services/repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo _repo = ProductRepo();

  List<Productmodal> _products = [];
  bool _isLoading = false;
  Set<int> _favoriteIds = {}; 

  List<Productmodal> get products => _products;
  bool get isLoading => _isLoading;
  Set<int> get favoriteIds => _favoriteIds;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _repo.getProducts();
      if (data != null) _products = data;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching products: $e");
        print("Fetched ${_products.length} products");

      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    print("Fetched ${_products.length} products");

  }

  void toggleFavorite(int productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }
}
