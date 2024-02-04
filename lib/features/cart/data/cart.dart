class Cart {
  List<CartItem> cartItem;
  int totalPrice;
  int totalItems;

  Cart({
    required this.cartItem,
    required this.totalPrice,
    required this.totalItems,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartItem: json['cart']['items']
          .map<CartItem>((model) => CartItem.fromJson(model))
          .toList(),
      totalPrice: json["totalPrice"],
      totalItems: json["totalItems"],
    );
  }
}

class CartItem {
  ItemDetails itemDetails;
  int quantity;
  int price;
  String id;

  CartItem({
    required this.itemDetails,
    required this.quantity,
    required this.price,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemDetails: ItemDetails.fromJson(json['itemDetails']),
      quantity: json['quantity'],
      price: json['price'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'itemDetails': itemDetails,
      'quantity': quantity,
      'price': price
    };
  }

  @override
  String toString() {
    return 'CartItem(itemDetails: $itemDetails, quantity: $quantity, price: $price, id: $id)';
  }
}

class ItemDetails {
  String id;
  String name;
  String description;
  int price;
  bool isVeg;
  String category;
  bool inStock;
  String image;

  ItemDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isVeg,
    required this.category,
    required this.inStock,
    required this.image,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      isVeg: json['isVeg'],
      category: json['category'],
      inStock: json['inStock'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'isVeg': isVeg,
      'category': category,
      'inStock': inStock,
      'image': image,
    };
  }
}
