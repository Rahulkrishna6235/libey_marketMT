import 'package:flutter/material.dart';
import 'package:libey_mt/model/cart.dart';
import 'package:libey_mt/model/product.dart';
import 'package:libey_mt/providers/cart.dart';
import 'package:libey_mt/utilities/colors.dart';
import 'package:libey_mt/views/home/cart.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final Productmodal product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  //final List<CartItem> cartItems = [];
  List<CartItem> cartItems = [];

   Future<void> _loadCart() async {
    final items = await CartStorage.loadCart();
    setState(() {
      cartItems = items;
    });
  }


  Future<void> _addToCart(Productmodal product) async {
    final existingIndex =
        cartItems.indexWhere((item) => item.title == product.title);
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(CartItem(
        title: product.title ?? "",
        image: product.images?.isNotEmpty == true ? product.images!.first : "",
        price: double.tryParse(product.price.toString()) ?? 0,
      ));
    }

    await CartStorage.saveCart(cartItems);

    setState(() {}); // refresh count
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart 🛒")),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCart();
  }
  @override
  Widget build(BuildContext context) {
     

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorControllers().appbarcolor,
        title: Center(child: Text("Details")),
        actions: [
           Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () async{
                   final updatedCart = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartPage(cartItems: cartItems),
                      ),
                    );
                    if (updatedCart != null) {
                      setState(() => cartItems = updatedCart);
                      await CartStorage.saveCart(cartItems);
                    }
                  },
                  icon: const Icon(Icons.shopping_cart, size: 35),
                ),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartItems.length.toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorControllers().popuptfieldbtn
                ),
                height: 300,
                child: PageView.builder(
                  itemCount: widget.product.images!.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.product.images![index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                    
                      Text("price : ${widget.product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 30, color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      Text("dis%${widget.product.discountPercentage}%"
                        ,style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(widget.product.rating.toString()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.description!,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorControllers().ElevatedButtoncolor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                         if(widget.product != null){
                              _addToCart(widget.product);
                            }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Added to cart 🛒"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
