import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/common_widgets/add_button.dart';
import 'package:grocery_app/core/common_widgets/increase_decrease_widget.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';
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
    final cart = ref.watch(cartItemsProvider);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return ItemDetailsScreen(product: widget.product);
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              height: 10,
            ),
            Text(
              widget.product.name,
              style: CustomTextStyle.boldTextStyleDark12(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // const SizedBox(
            //   height: 8,
            // ),
            Text(
              widget.product.quantity,
              style: CustomTextStyle.boldTextStyleBlack4612(),
            ),
            // const SizedBox(
            //   height: 11,
            // ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      '\u{20B9}${widget.product.discountedPrice}',
                      style: CustomTextStyle.boldTextStyleBlack12(),
                    ),
                    Text(
                      '\u{20B9}${widget.product.price}',
                      style: CustomTextStyle.boldTextStyleBlack4612()
                          .copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                const Spacer(),
                cart.when(
                  data: (data) {
                    final isInCart = ref
                        .read(cartItemsProvider.notifier)
                        .isInCart(widget.product.id);
                    int quantity = 0;
                    if (isInCart) {
                      quantity = ref
                          .read(cartItemsProvider.notifier)
                          .getQuantity(widget.product.id);
                    }
                    return isInCart
                        ? IncreaseDecreaseWidget(
                            isItemDetailScreen: false,
                            quantity: quantity,
                            increaseOnPressed: () {
                              ref
                                  .read(cartItemsProvider.notifier)
                                  .increaseQuantityItem(widget.product.id);
                            },
                            decreaseOnPressed: () {
                              if (quantity == 1) {
                                ref
                                    .read(cartItemsProvider.notifier)
                                    .deleteItemFromCart(widget.product.id);
                              } else {
                                ref
                                    .read(cartItemsProvider.notifier)
                                    .decreaseQuantityItem(widget.product.id);
                              }
                            },
                          )
                        : AddButton(onPressed: () {
                            CartItem cartItem = CartItem(
                                itemDetails: widget.product,
                                quantity: 1,
                                id: widget.product.id);
                            ref
                                .read(cartItemsProvider.notifier)
                                .addItemToCart(cartItem);
                          });
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) {
                    return const CircularProgressIndicator();
                  },
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
