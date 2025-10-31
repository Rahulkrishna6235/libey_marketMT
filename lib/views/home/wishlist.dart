import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:libey_mt/model/product.dart';
import 'package:libey_mt/utilities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Productmodal> wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList('wishlist_data') ?? [];
    setState(() {
      wishlist = savedData
          .map((item) => Productmodal.fromJson(jsonDecode(item)))
          .toList();
    });
  }

  Future<void> _removeFromWishlist(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('wishlist_data') ?? [];
    savedData.removeWhere((item) {
      final data = jsonDecode(item);
      return data['id'] == id;
    });
    await prefs.setStringList('wishlist_data', savedData);

    List<String> savedIds = prefs.getStringList('wishlist') ?? [];
    savedIds.remove(id.toString());
    await prefs.setStringList('wishlist', savedIds);

    _loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text("My Wishlist"),
        backgroundColor: ColorControllers().appbarcolor,
      ),
      body: wishlist.isEmpty
          ? const Center(child: Text("Your wishlist is empty."))
          : GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            (product.images != null &&
                                    product.images!.isNotEmpty)
                                ? product.images!.first
                                : '',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeFromWishlist(product.id),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "₹${product.price}",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
