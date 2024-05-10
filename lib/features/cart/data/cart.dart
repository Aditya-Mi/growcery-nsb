import 'package:grocery_app/features/products/data/product.dart';
import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 0)
class CartItem {
  @HiveField(0)
  Product itemDetails;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String id;

  CartItem({
    required this.itemDetails,
    required this.quantity,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      '_id': id,
      'itemDetails': itemDetails,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'CartItem(itemDetails: $itemDetails, quantity: $quantity, id: $id)';
  }
}
