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
        data: (data) => data.isEmpty
            ? const Center(
                child: Text('No items in cart'),
              )
            : ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return CartListItem(
                    cartItem: data[index],
                  );
                },
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(title: 'Checkout', function: () {}),
    );
  }
}
