import 'package:flutter/material.dart';
import 'package:grocery_app/core/common_widgets/add_button.dart';
import 'package:grocery_app/core/common_widgets/floating_action_button.dart';
import 'package:grocery_app/core/common_widgets/increase_decrease_widget.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';

import 'package:grocery_app/features/products/data/product.dart';

class ItemDetailsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ItemDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends ConsumerState<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final cart = ref.watch(cartItemsProvider);
    return SizedBox(
      height: h * 0.55,
      child: Scaffold(
        backgroundColor: lightBg,
        floatingActionButton: const CustomFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        body: Stack(
          children: [
            Positioned(
              top: -600,
              left: -235,
              child: Container(
                height: 906,
                width: 906,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        color: lightBg,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.product.image),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.product.name,
                    style: CustomTextStyle.boldTextStyleDark(fontSize: 20),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.product.description,
                    style: CustomTextStyle.boldTextStyle(
                      fontSize: 12,
                      color: dark.withOpacity(0.63),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.quantity,
                            style:
                                CustomTextStyle.boldTextStyleDark(fontSize: 12)
                                    .copyWith(
                              color: const Color(0xffb4b4b4),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\u{20B9}${widget.product.discountedPrice}',
                                style: CustomTextStyle.boldTextStyleBlack(
                                    fontSize: 20),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '\u{20B9}${widget.product.price}',
                                style: CustomTextStyle.boldTextStyleBlack46(
                                        fontSize: 16)
                                    .copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
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
                                  isItemDetailScreen: true,
                                  quantity: quantity,
                                  increaseOnPressed: () {
                                    ref
                                        .read(cartItemsProvider.notifier)
                                        .increaseQuantityItem(
                                            widget.product.id);
                                  },
                                  decreaseOnPressed: () {
                                    if (quantity == 1) {
                                      ref
                                          .read(cartItemsProvider.notifier)
                                          .deleteItemFromCart(
                                              widget.product.id);
                                    } else {
                                      ref
                                          .read(cartItemsProvider.notifier)
                                          .decreaseQuantityItem(
                                              widget.product.id);
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
          ],
        ),
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
