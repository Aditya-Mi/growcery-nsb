import 'package:grocery_app/features/products/data/category.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  int price;
  @HiveField(4)
  int discountedPrice;
  @HiveField(5)
  String quantity;
  @HiveField(6)
  Category category;
  @HiveField(7)
  bool inStock;
  @HiveField(8)
  String image;
  @HiveField(9)
  int v;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountedPrice,
    required this.quantity,
    required this.category,
    required this.inStock,
    required this.image,
    required this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      discountedPrice: json['discountedPrice'],
      quantity: json['quantity'],
      category: Category.fromJson(json['category']),
      inStock: json['inStock'],
      image: json['image'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountedPrice': discountedPrice,
      'quantity': quantity,
      'category': category.toJson(),
      'inStock': inStock,
      'image': image,
      '__v': v,
    };
  }
}
