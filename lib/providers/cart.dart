import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libey_mt/model/cart.dart';

class CartStorage {
  static const String cartKey = "cart_items";

  static Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(cartKey, jsonList);
  }

  static Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(cartKey) ?? [];
    return jsonList
        .map((item) => CartItem.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }
}
