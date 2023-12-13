import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final finalAddress =
        "${widget.address.locality}, ${widget.address.landmark}, ${widget.address.city}, ${widget.address.state}";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Color.fromRGBO(138, 149, 158, 0.15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.address.fullName,
                        style: const TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                        icon: const Icon(Icons.edit_outlined),
                        padding: const EdgeInsets.all(0),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(addressProvider.notifier)
                              .deleteAddress(widget.address.id!);
                        },
                        icon: const Icon(Icons.delete_rounded),
                        padding: const EdgeInsets.all(0),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    finalAddress,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
