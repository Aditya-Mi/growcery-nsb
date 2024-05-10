import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/core/common_widgets/custom_button.dart';
import 'package:grocery_app/core/common_widgets/custom_button_text.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';
import 'package:grocery_app/features/cart/presentation/widgets/cart_list_item.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';
import 'package:grocery_app/utils/helper_functions.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  Address? _selectedAddress;

  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }

  Future<void> checkInternetConnection() async {
    final isInternetAvailable = await ref.read(networkProvider.future);
    if (!isInternetAvailable && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection.'),
        ),
      );
    }
  }

  void bottomSheet(BuildContext context, List<Address> addresses) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          floatingActionButton: Container(
            transform: Matrix4.translationValues(0.0, -60.0, 0.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Select address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              for (final address in addresses)
                RadioListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.addressType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${address.fullName}, ${address.locality}, ${address.landmark}, ${address.city}, ${address.state}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: grey,
                        ),
                      ),
                    ],
                  ),
                  value: address,
                  groupValue: _selectedAddress,
                  onChanged: (value) {
                    setState(() {
                      _selectedAddress = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartItemsProvider);
    final addresses = ref.watch(addressProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: cartItems.when(
          data: (data) {
            if (data.isEmpty) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/empty_cart_image.png'),
                  ),
                ),
              );
            }
            double totalPrice = 0;
            double discountedPrice = 0;
            double savings = 0;
            for (var cartItem in data) {
              totalPrice += cartItem.itemDetails.price * cartItem.quantity;
              discountedPrice +=
                  cartItem.itemDetails.discountedPrice * cartItem.quantity;
            }
            savings = totalPrice - discountedPrice;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return CartListItem(
                          cartItem: data[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          addresses.when(
                            data: (data) {
                              if (data.isEmpty) {
                                return TextButton.icon(
                                  style: TextButton.styleFrom(
                                    backgroundColor: lightBg,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                  ),
                                  icon: SvgPicture.asset(
                                    'assets/icons/pin.svg',
                                    color: primaryColor,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditAddress(),
                                      ),
                                    );
                                  },
                                  label: Text(
                                    'Add address',
                                    style: CustomTextStyle.boldTextStyleDark(
                                        fontSize: 16),
                                  ),
                                );
                              } else {
                                _selectedAddress ??= data[0];
                                final finalAddress =
                                    "${_selectedAddress!.locality}, ${_selectedAddress!.landmark}, ${_selectedAddress!.city}, ${_selectedAddress!.state}";
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/pin.svg',
                                        color: primaryColor,
                                        width: 24,
                                        height: 24,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedAddress!.fullName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              finalAddress,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          bottomSheet(context, data);
                                        },
                                        child: const Text(
                                          'Change',
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            error: (error, stackTrace) {
                              return Center(
                                child: Text(error.toString()),
                              );
                            },
                            loading: () {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: lightBg,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Text(
                                      'Bill details',
                                      style: CustomTextStyle.boldTextStyleBlack(
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                billItems(
                                    text: 'Item Total',
                                    subText: '\u{20B9}$discountedPrice',
                                    isLast: false,
                                    isFirst: true,
                                    savings: savings),
                                const SizedBox(height: 10),
                                billItems(
                                    text: 'Delivery Charge',
                                    subText: 'FREE',
                                    isLast: false,
                                    isFirst: false),
                                const SizedBox(height: 10),
                                billItems(
                                    text: 'Grand Total',
                                    subText: '\u{20B9}$discountedPrice',
                                    isLast: true,
                                    isFirst: false),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                  child: const CustomButtonText(
                                      title: 'Place order'),
                                  function: () async {
                                    if (_selectedAddress == null) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape:
                                                const BeveledRectangleBorder(),
                                            title: const Text(
                                              'Warning!',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: const Text(
                                              'Please add a address before ordering.',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Ok',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    await checkInternetConnection();
                                    if (context.mounted) {
                                      Helper.showSnackbar(
                                        context,
                                        "Order placed successfully",
                                      );
                                    } else {
                                      if (context.mounted) {
                                        Helper.showSnackbar(
                                            context, 'Try again later');
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/error_image.png',
                  ),
                ),
              ),
            );
          },
          loading: () {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return const CartListItemShimmer();
                    },
                    itemCount: 5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ShimmerWidget.circular(
                  width: double.infinity,
                  height: 200,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const ShimmerWidget.circular(
                  width: double.infinity,
                  height: 200,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget billItems({
    required String text,
    required String subText,
    required bool isLast,
    required bool isFirst,
    double savings = 0,
  }) {
    final intSavings = savings.toInt();
    return Row(
      children: [
        Text(
          text,
          style: isLast
              ? CustomTextStyle.boldTextStyleBlack(fontSize: 14)
              : CustomTextStyle.boldTextStyleBlack46(fontSize: 16),
        ),
        const SizedBox(
          width: 10,
        ),
        isFirst
            ? Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Saved',
                      style: CustomTextStyle.mediumTextStylePrimaryColor(
                          fontSize: 10),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '\u{20B9}$intSavings',
                      style: CustomTextStyle.mediumTextStylePrimaryColor(
                          fontSize: 10),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        const Spacer(),
        Text(
          subText,
          style: CustomTextStyle.boldTextStyleBlack(fontSize: 14),
        ),
      ],
    );
  }
}
