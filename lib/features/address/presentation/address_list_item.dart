import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/common_widgets/shimmer_widget.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/custom_textstyle.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';

class AddressListItem extends ConsumerStatefulWidget {
  final Address address;
  const AddressListItem({super.key, required this.address});

  @override
  ConsumerState<AddressListItem> createState() => _AddressListItemState();
}

class _AddressListItemState extends ConsumerState<AddressListItem> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkInternetConnection() async {
    final isInternetAvailable = await ref.read(networkProvider.future);
    if (!isInternetAvailable && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection.'),
        ),
      );
    }
    return isInternetAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final finalAddress =
        "${widget.address.locality}, ${widget.address.landmark}, ${widget.address.city}, ${widget.address.state}";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightBg,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.address.fullName,
                  style: CustomTextStyle.boldTextStyleDark(fontSize: 16),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  finalAddress,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff888888),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditAddress(
                    address: widget.address,
                  ),
                ),
              );
            },
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            icon: const Icon(
              Icons.edit_outlined,
              color: dark,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () async {
              bool isInternetAvailable = await checkInternetConnection();
              if (isInternetAvailable) {
                await ref
                    .read(addressProvider.notifier)
                    .deleteAddress(widget.address.id!);
              }
            },
            icon: const Icon(
              Icons.delete_rounded,
              color: dark,
            ),
            style: IconButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

class AddressListItemShimmer extends StatelessWidget {
  const AddressListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget.circular(
      width: double.infinity,
      height: 100,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
