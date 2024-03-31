import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/common_widgets/custom_button.dart';
import 'package:grocery_app/common_widgets/custom_button_text.dart';
import 'package:grocery_app/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';
import 'package:grocery_app/features/cart/data/cart.dart';
import 'package:grocery_app/features/cart/presentation/widgets/cart_list_item.dart';
import 'package:grocery_app/features/cart/provider/cart_provider.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';
import 'package:grocery_app/utils/helper_functions.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String generateOrderSummary(Address address, Cart cart) {
    String orderSummary = """📊 Order Summary:
Total Items: ${cart.totalItems}
Total Price: *₹${cart.totalPrice}*
                          """;
    for (int i = 0; i < cart.cartItem.length; i++) {
      CartItem item = cart.cartItem[i];
      orderSummary +=
          "\n*${i + 1}. ${item.itemDetails.name} -  ${item.quantity} x ₹${item.itemDetails.price} = ₹${item.price}*";
    }
    orderSummary += """\n
📍 Delivery Address:
Name:${address.fullName}
Mobile Number: ${address.alternativePhone}
Locality: ${address.locality}
Landmark: ${address.landmark}
State: ${address.state}
Pincode: ${address.pincode}
🚚 Your order is confirmed and will be delivered soon. Thank you for shopping with us! 🙏""";
    return orderSummary;
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
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.0,
      ),
      body: cartItems.when(
        data: (data) => data.cartItem.isEmpty
            ? Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/empty_cart_image.png'),
                  ),
                ),
              )
            : SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.cartItem.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 1,
                                );
                              },
                              itemBuilder: (context, index) {
                                return CartListItem(
                                  cartItem: data.cartItem[index],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bill details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Item Total',
                                      style: TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '\u{20B9}${data.totalPrice}',
                                      style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: lightGrey,
                              blurRadius: 5,
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: addresses.when(
                                data: (data) {
                                  if (data.isEmpty) {
                                    return TextButton.icon(
                                      style: TextButton.styleFrom(
                                        backgroundColor: lightGrey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                      ),
                                      icon: SvgPicture.asset(
                                          'assets/icons/pin.svg'),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditAddress(),
                                          ),
                                        );
                                      },
                                      label: const Text(
                                        'Add address',
                                        style: TextStyle(
                                          inherit: true,
                                          fontFamily: 'DMSans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: dark,
                                        ),
                                      ),
                                    );
                                  } else {
                                    _selectedAddress ??= data[0];
                                    final finalAddress =
                                        "${_selectedAddress!.locality}, ${_selectedAddress!.landmark}, ${_selectedAddress!.city}, ${_selectedAddress!.state}";
                                    return Row(
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
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              child:
                                  const CustomButtonText(title: 'Place order'),
                              function: () async {
                                if (_selectedAddress == null) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: const BeveledRectangleBorder(),
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
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                await checkInternetConnection();
                                const String number = '917619785845';
                                final String text = generateOrderSummary(
                                    _selectedAddress!, data);
                                final Uri url = Uri.parse(
                                    "https://wa.me/$number?text=$text");
                                // final success = await ref
                                //     .read(cartItemsProvider.notifier)
                                //     .placeOrder(_selectedAddress!.id!);
                                final success = await launchUrl(url);
                                if (success && context.mounted) {
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
                    ),
                  ],
                ),
              ),
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
    );
  }
}
