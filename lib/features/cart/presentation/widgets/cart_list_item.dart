import 'package:flutter/material.dart';
import 'package:grocery_app/core/common_widgets/increase_decrease_widget.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';

class CartListItem extends ConsumerWidget {
  final CartItem cartItem;
  const CartListItem({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: lightBg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                  cartItem.itemDetails.image,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.itemDetails.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyle.boldTextStyleDark(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  cartItem.itemDetails.quantity,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff888888),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\u{20B9}${cartItem.itemDetails.discountedPrice}',
                      style: CustomTextStyle.boldTextStyleBlack12()
                          .copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '\u{20B9}${cartItem.itemDetails.price}',
                      style: CustomTextStyle.boldTextStyleBlack46(fontSize: 12)
                          .copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          IncreaseDecreaseWidget(
            quantity: cartItem.quantity,
            increaseOnPressed: () {
              ref
                  .read(cartItemsProvider.notifier)
                  .increaseQuantityItem(cartItem.itemDetails.id);
            },
            decreaseOnPressed: () {
              final quantity = cartItem.quantity;
              if (quantity == 1) {
                ref
                    .read(cartItemsProvider.notifier)
                    .deleteItemFromCart(cartItem.itemDetails.id);
              } else {
                ref
                    .read(cartItemsProvider.notifier)
                    .decreaseQuantityItem(cartItem.itemDetails.id);
              }
            },
            isItemDetailScreen: false,
          ),
        ],
      ),
    );
  }
}

class CartListItemShimmer extends StatelessWidget {
  const CartListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h * .12,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShimmerWidget.circular(
            height: h * .10,
            width: w * 0.19,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget.rectangular(
                  width: 150,
                  height: h * 0.0159,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget.rectangular(
                            width: 50, height: h * 0.0139),
                        ShimmerWidget.rectangular(width: 50, height: h * 0.0159)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
