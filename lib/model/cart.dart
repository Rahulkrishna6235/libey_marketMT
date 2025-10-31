class CartItem {
  String title;
  String image;
  double price;
  int quantity;

  CartItem({
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'price': price,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        title: json['title'],
        image: json['image'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] ?? 1,
      );
}
