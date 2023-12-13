import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/common_widgets/custom_button.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/cart/presentation/widgets/cart_list_item.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: cartItems.when(
        data: (data) => data.cartItem.isEmpty
            ? const Center(
                child: Text('No items in cart'),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: data.cartItem.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        return CartListItem(
                          cartItem: data.cartItem[index],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${data.totalPrice}',
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Items:',
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${data.totalItems}',
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        CustomButton(title: 'Checkout', function: () {})
                      ],
                    ),
                  ),
                ],
              ),
        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
