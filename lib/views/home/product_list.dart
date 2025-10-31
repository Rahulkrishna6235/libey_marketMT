import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libey_mt/model/cart.dart';
import 'package:libey_mt/model/product.dart';
import 'package:libey_mt/providers/Auth.dart';
import 'package:libey_mt/providers/cart.dart';
import 'package:libey_mt/providers/product.dart';
import 'package:libey_mt/services/repo.dart';
import 'package:libey_mt/utilities/colors.dart';
import 'package:libey_mt/views/home/cart.dart';
import 'package:libey_mt/views/home/product_detail.dart';
import 'package:libey_mt/views/home/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => __HomeScreenStateState();
}

class __HomeScreenStateState extends State<HomeScreen> {

 bool _isfavour = false;
  var selectedindex;
  isselect(value){
    _isfavour=value;
  }

List <Productmodal>? productss;
List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
   }

  List<int> wishlistIds = [];
  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('wishlist') ?? [];
    setState(() {
      wishlistIds = savedIds.map((id) => int.parse(id)).toList();
    });
  }

  Future<void> _toggleWishlist(Productmodal product) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (wishlistIds.contains(product.id)) {
        wishlistIds.remove(product.id);
      } else {
        wishlistIds.add(product.id);
      }
    });
    prefs.setStringList(
      'wishlist',
      wishlistIds.map((id) => id.toString()).toList(),
    );
    
    List<String> savedProducts =
        prefs.getStringList('wishlist_data') ?? [];
    if (wishlistIds.contains(product.id)) {
      savedProducts.add(jsonEncode(product.toJson()));
    } else {
      savedProducts.removeWhere((p) {
        final data = jsonDecode(p);
        return data['id'] == product.id;
      });
    }
    prefs.setStringList('wishlist_data', savedProducts);
  }

  bool _isInWishlist(int id) => wishlistIds.contains(id);

  Future<void> _loadCart() async {
    final items = await CartStorage.loadCart();
    setState(() {
      cartItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.products;
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:ColorControllers().appbarcolor,
        title: Text("WELCOME",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
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
           Container(
            height: 35,width: 35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
             child: IconButton(
              icon: const Icon(Icons.favorite, size: 20, color: Colors.pink),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistPage()),
                ).then((_) => _loadWishlist());
              },
                       ),
           ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFC333B5), Color(0xFFCF75D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
  backgroundImage: auth.userData != null && auth.userData!['image'] != null
      ? NetworkImage(auth.userData!['image'])
      : const AssetImage('assets/images/default_user.png')
          as ImageProvider,
),

              accountName: Text(
                auth != null
                    ? "Name: ${auth.userData?['firstName']} ${auth.userData?['lastName']}"
                    : 'Guest User',
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
               "Email: ${auth.userData?['email']}",style: const TextStyle(color: Colors.white70),
              ),
            ),

            // Drawer items
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                auth.logout();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              print("Search: $value");
            },
            decoration: const InputDecoration(
              hintText: "Search products...",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),

    SizedBox(height: 3,),

    Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text("Category",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w800),)),
       SizedBox(height: 3,),
      SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context,index){
             final product = products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    child: Container(
                      width: 60,height: 40,
                      decoration: BoxDecoration(
                        color: ColorControllers().searchbarcolor,
                        borderRadius: BorderRadius.circular(15),border: Border.all(width: 2,color: ColorControllers().maincolor)),
                      child: Center(child: Text("${product.category}")),
                    ),
                  ),
                );
                
                //CircleAvatar(radius: 40,backgroundColor:ColorControllers().appbarcolor);
              },
               separatorBuilder: (BuildContext context,index){               
                return SizedBox(width:1,);
               }, 
               itemCount: 10),
      ),
      SizedBox(height: 10,),
          Expanded(
            child: provider.isLoading ?
            Center(child: const CircularProgressIndicator())
             : products.isEmpty ? Center(child: Text("no data"),)
             
            : GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12, 
              mainAxisSpacing: 12,
              childAspectRatio: 0.75, 
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
                final isWishlisted = _isInWishlist(product.id);    
              return GestureDetector(
                onTap: (){
                   Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailPage(product: product),
    ),
  );
                },
                child: Container(
                      decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                      },
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                       (product.images != null && product.images!.isNotEmpty)
                    ? product.images!.first
                    : '',
                       fit: BoxFit.cover,
                     )
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: IconButton(
                        onPressed: () =>
                                      _toggleWishlist(product),
                                  icon: Icon(
                                    isWishlisted
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 25,
                                    color: isWishlisted
                                        ? Colors.red
                                        : Colors.brown,
                                  ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.description! ,
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Price: ${product?.price ?? ""}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 5,),
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: (){
                      //       // if(product != null){
                      //       //   addToCart(product);
                      //       // }
                      //     },
                      //     child: Container(
                      //       height: 20,width: 100,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(5),
                      //         color: Color(0xFFF3E4F5),
                              
                      //       ),
                      //       child: Center(child: Text("Add To Cart")),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                            ],
                      ),
                ),
              );
            },
                    ),
          ),]
      )

    );
  }
}