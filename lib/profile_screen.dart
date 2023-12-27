import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/address/presentation/address_screen.dart';
import 'package:grocery_app/features/authentication/presentation/login_screen.dart';
import 'package:grocery_app/features/authentication/provider/auth_provider.dart';
import 'package:grocery_app/profile_list_item.dart';
import 'package:grocery_app/utils/helper_functions.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void signOut() async {
    var success = await ref.read(authProvider.notifier).logout();
    if (context.mounted && success) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (Route<dynamic> route) => false);
    } else {
      if (context.mounted) {
        Helper.showSnackbar(
          context,
          'There was an error while logging out. Please try again later',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final mobileNo = ref.watch(mobileNoProvider);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: const BeveledRectangleBorder(),
                    title: const Text('Log Out'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          signOut();
                        },
                        child: const Text('Log out'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: mobileNo.when(
        data: (mobileNo) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1682685797736-dabb341dc7de?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mobile Number',
                          style: TextStyle(
                            fontFamily: 'NuntioSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: grey,
                          ),
                        ),
                        Text(
                          mobileNo,
                          style: const TextStyle(
                            fontFamily: 'NuntioSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.044,
                ),
                ProfileListItem(
                  title: 'My order',
                  function: () {},
                  icon: Icons.shopping_bag_rounded,
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                ProfileListItem(
                  title: 'Shipping Addresses',
                  function: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressScreen(),
                      ),
                    );
                  },
                  icon: Icons.article,
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                ProfileListItem(
                  title: 'Setting',
                  function: () {},
                  icon: Icons.settings,
                ),
              ],
            ),
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
    );
  }
}
