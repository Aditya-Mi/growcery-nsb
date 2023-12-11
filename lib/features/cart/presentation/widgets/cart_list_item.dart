import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .13,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 48,
            height: 42,
            child: Image.network(cartItem.itemDetails.image),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.itemDetails.name,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: h * 0.0189,
                    fontWeight: FontWeight.bold,
                    color: dark,
                  ),
                ),
                Text(
                  '${cartItem.itemDetails.price}',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: h * 0.0189,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
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
              }
              await ref
                  .read(cartItemsProvider.notifier)
                  .decreaseQuantityItem(cartItem.itemDetails.id);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: lightBg,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.minimize,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
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
            width: 8,
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
    );
  }
}
