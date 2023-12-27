import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/cart/data/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';

class CartListItem extends ConsumerWidget {
  final CartItem cartItem;
  const CartListItem({
    super.key,
    required this.cartItem,
  });
  String extractQuantity(String inputString) {
    RegExp regex = RegExp(r'\(([^)]+)\)');
    RegExpMatch? match = regex.firstMatch(inputString);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h * .12,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: h * .10,
            width: w * 0.19,
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(
                color: lightGrey,
              ),
              borderRadius: BorderRadius.circular(5),
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
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: h * 0.0159,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          extractQuantity(cartItem.itemDetails.description),
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: h * 0.0139,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '\u{20B9}${cartItem.itemDetails.price}',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: h * 0.0159,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        final quantity = ref
                            .read(cartItemsProvider.notifier)
                            .getQuantity(cartItem.itemDetails.id);
                        if (quantity == 1) {
                          await ref
                              .read(cartItemsProvider.notifier)
                              .deleteItemFromCart(cartItem.itemDetails.id);
                        } else {
                          await ref
                              .read(cartItemsProvider.notifier)
                              .decreaseQuantityItem(cartItem.itemDetails.id);
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: lightBg,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icons/minus.svg",
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${cartItem.quantity}',
                      style: const TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: dark,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        await ref
                            .read(cartItemsProvider.notifier)
                            .increaseQuantityItem(cartItem.itemDetails.id);
                      },
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
