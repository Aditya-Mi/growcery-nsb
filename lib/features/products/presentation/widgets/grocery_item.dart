import 'package:flutter/material.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/features/products/presentation/item_details_screen.dart';

class GroceryItem extends StatefulWidget {
  final Product product;
  const GroceryItem({super.key, required this.product});

  @override
  State<GroceryItem> createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryItem> {
  String extractQuantity(String inputString) {
    RegExp regex = RegExp(r'\(([^)]+)\)');
    RegExpMatch? match = regex.firstMatch(inputString);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              product: widget.product,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: lightBg,
                width: 2,
              ),
            ),
          ),
          Positioned(
            left: 2,
            top: 2,
            right: 2,
            child: Image(
              image: NetworkImage(
                widget.product.image,
                scale: 1.8,
              ),
            ),
          ),
          Positioned(
            right: 2,
            left: 2,
            bottom: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: dark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 20,
            child: Text(
              '${extractQuantity(widget.product.description)}, \u{20B9}${widget.product.price}',
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: () {},
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: primaryColor,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
