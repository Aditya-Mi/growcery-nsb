import 'package:flutter/material.dart';
import 'package:grocery_app/common_widgets/custom_button.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';

import 'package:grocery_app/features/products/data/product.dart';

class ItemDetailsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ItemDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends ConsumerState<ItemDetailsScreen> {
  Future<void> addItemToCart(String id) async {
    await ref.read(cartItemsProvider.notifier).addItemToCart(id);
  }

  Future<void> deleteItemFromCart(String id) async {
    await ref.read(cartItemsProvider.notifier).deleteItemFromCart(id);
  }

  String extractQuantity(String inputString) {
    RegExp regex = RegExp(r'\(([^)]+)\)');
    RegExpMatch? match = regex.firstMatch(inputString);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }

  String extractProductDesc(String inputString) {
    RegExp regex = RegExp(r'([^()]+)');
    RegExpMatch? match = regex.firstMatch(inputString);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final cartNotifer = ref.watch(cartItemsProvider);

    return cartNotifer.when(
      data: (data) {
        final isInCart =
            ref.read(cartItemsProvider.notifier).isInCart(widget.product.id);
        print('$isInCart');
        int quantity = 0;
        if (isInCart) {
          final cartItem = data.cartItem.firstWhere(
              (element) => element.itemDetails.id == widget.product.id);
          quantity = cartItem.quantity;
        }

        return Scaffold(
          backgroundColor: lightBg,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: CustomClipPath(),
                      child: Container(
                        height: h * 0.47549763033,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: h * 0.05061611374,
                      child: Image.network(
                        widget.product.image,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: IconButton.styleFrom(backgroundColor: lightBg),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.03791469194,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: h * 0.0284,
                          fontWeight: FontWeight.bold,
                          color: dark,
                        ),
                        maxLines: 2,
                      ),
                      Row(
                        children: [
                          Text(
                            '${extractQuantity(widget.product.description)}, \u{20B9}${widget.product.price}',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: h * 0.0236,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                          const Spacer(),
                          if (isInCart)
                            IconButton(
                              onPressed: () async {
                                if (quantity == 1) {
                                  ref
                                      .read(cartItemsProvider.notifier)
                                      .deleteItemFromCart(widget.product.id);
                                }
                                ref
                                    .read(cartItemsProvider.notifier)
                                    .decreaseQuantityItem(widget.product.id);
                              },
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.minimize),
                              style: IconButton.styleFrom(
                                  backgroundColor: lightBg),
                            ),
                          if (isInCart)
                            SizedBox(
                              width: w * 0.0410,
                            ),
                          if (isInCart)
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: dark,
                              ),
                            ),
                          if (isInCart)
                            SizedBox(
                              width: w * 0.0410,
                            ),
                          if (isInCart)
                            IconButton(
                              onPressed: () async {
                                ref
                                    .read(cartItemsProvider.notifier)
                                    .increaseQuantityItem(widget.product.id);
                              },
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              icon: const Icon(Icons.add),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.0105,
                      ),
                      Text(
                        extractProductDesc(widget.product.description),
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: h * 0.0189,
                          fontWeight: FontWeight.bold,
                          color: grey,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: h * 0.0305,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                isInCart
                    ? CustomButton(
                        title: 'Remove from cart',
                        function: () async {
                          await deleteItemFromCart(widget.product.id);
                        },
                      )
                    : CustomButton(
                        title: 'Add to cart',
                        function: () async {
                          await addItemToCart(widget.product.id);
                        },
                      ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(
          error.toString(),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, h - (h * 0.11819148936));
    path.arcToPoint(
      Offset(w, h - (h * 0.11819148936)),
      radius: Radius.circular(w * 1.16153846154),
      clockwise: false,
    );
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
