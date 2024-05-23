import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/common_widgets/custom_button_2.dart';
import 'package:grocery_app/core/common_widgets/custom_button_text.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/core/constants/images.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/presentation/address_list_item.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
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

  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addressData = ref.watch(addressProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          width: 44,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: stroke)),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: dark,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Addresses',
        ),
      ),
      body: addressData.when(
        data: (data) {
          return data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(Images.noAddress),
                      const Text('No addresses added'),
                      const Spacer(),
                      const AddAddressWidget(),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return AddressListItem(
                            address: data[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 10,
                          );
                        },
                      ),
                    ),
                    const AddAddressWidget(),
                  ],
                );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            return const AddressListItemShimmer();
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15,
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}

class AddAddressWidget extends StatelessWidget {
  const AddAddressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: lightBg,
      ),
      child: SizedBox(
        width: 150,
        child: CustomButton2(
          child: const CustomButtonText(title: 'Add Address'),
          function: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditAddress(),
            ),
          ),
        ),
      ),
    );
  }
}
