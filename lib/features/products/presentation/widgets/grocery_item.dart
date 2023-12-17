import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';
import 'package:grocery_app/features/products/data/product.dart';
import 'package:grocery_app/features/products/presentation/item_details_screen.dart';

class GroceryItem extends ConsumerStatefulWidget {
  final Product product;
  const GroceryItem({super.key, required this.product});

  @override
  ConsumerState<GroceryItem> createState() => _GroceryItemState();
}

class _GroceryItemState extends ConsumerState<GroceryItem> {
  String extractQuantity(String inputString) {
    RegExp regex = RegExp(r'\(([^)]+)\)');
    RegExpMatch? match = regex.firstMatch(inputString);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = ref.read(cartItemsProvider);
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
          cartItem.when(
            data: (data) {
              final isInCart = ref
                  .read(cartItemsProvider.notifier)
                  .isInCart(widget.product.id);
              print('$isInCart');
              int quantity = 0;
              if (isInCart) {
                final cartItem = data.cartItem.firstWhere(
                    (element) => element.itemDetails.id == widget.product.id);
                quantity = cartItem.quantity;
              }
              if (isInCart) {
                return Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (quantity == 1) {
                            await ref
                                .read(cartItemsProvider.notifier)
                                .deleteItemFromCart(widget.product.id);
                          }
                          await ref
                              .read(cartItemsProvider.notifier)
                              .decreaseQuantityItem(widget.product.id);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            "assets/icons/minus.svg",
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: dark,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      InkWell(
                        onTap: () async {
                          print('inside button');
                          await ref
                              .read(cartItemsProvider.notifier)
                              .increaseQuantityItem(widget.product.id);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () async {
                      await ref
                          .read(cartItemsProvider.notifier)
                          .addItemToCart(widget.product.id);
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
                );
              }
            },
            error: (error, stackTrace) {
              return Positioned(
                right: 10,
                bottom: 10,
                child: Text(
                  error.toString(),
                ),
              );
            },
            loading: () => const Positioned(
              right: 10,
              bottom: 10,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
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
