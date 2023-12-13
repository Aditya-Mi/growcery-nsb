import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/address/presentation/add_adress_screen.dart';
import 'package:grocery_app/features/address/presentation/address_list_item.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final addressData = ref.watch(addressProvider);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Shipping address',
          style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: addressData.when(
        data: (data) {
          return data.isEmpty
              ? const Center(
                  child: Text('No addresses added'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return AddressListItem(
                      address: data[index],
                    );
                  },
                );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color.fromRGBO(138, 149, 158, 0.15),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditAddress(),
              ),
            );
          },
        ),
      ),
    );
  }
}
