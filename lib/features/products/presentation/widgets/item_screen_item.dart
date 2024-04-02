import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/features/products/presentation/item_details_screen.dart';

class ItemScreenItem extends ConsumerStatefulWidget {
  final Product product;
  const ItemScreenItem({super.key, required this.product});

  @override
  ConsumerState<ItemScreenItem> createState() => _ItemScreenItemState();
}

class _ItemScreenItemState extends ConsumerState<ItemScreenItem> {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: 165,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 141,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.product.image,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.product.name,
              style: CustomTextStyle.boldTextStyleDark12(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.product.quantity,
              style: CustomTextStyle.boldTextStyleBlack4612(),
            ),
            const SizedBox(
              height: 11,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.product.discountedPrice}',
                      style: CustomTextStyle.boldTextStyleBlack12(),
                    ),
                    Text(
                      '${widget.product.price}',
                      style: CustomTextStyle.boldTextStyleBlack4612()
                          .copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroceryShimmerListItem extends StatelessWidget {
  const GroceryShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget.circular(
      width: 100,
      height: 130,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
