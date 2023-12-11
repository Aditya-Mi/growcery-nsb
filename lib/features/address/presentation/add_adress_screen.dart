import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/common_widgets/custom_button.dart';
import 'package:grocery_app/constants/colors.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';

class EditAddress extends ConsumerStatefulWidget {
  final String uid;
  const EditAddress(this.uid, {super.key});

  @override
  ConsumerState<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends ConsumerState<EditAddress> {
  final _form = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredLocality = '';
  var _enteredZipcode = '';
  var _enteredCity = '';
  var _enteredLandmark = '';
  var _enteredState = '';
  var _enteredAlternateNo = '';
  var _addressType = '';

  void _updateAddress() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    final address = Address(
      fullName: _enteredName,
      locality: _enteredLocality,
      pincode: _enteredZipcode,
      city: _enteredCity,
      state: _enteredState,
      landmark: _enteredLandmark,
      alternativePhone: _enteredAlternateNo,
      addressType: _addressType,
    );
    await ref.read(addressProvider.notifier).addAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Add ahipping address',
          style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: h,
          width: w,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Full Name'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Ex. John Doe"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredName = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: lightGrey,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Locality'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Enter locality"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredLocality = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Zipcode (postal code)'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Ex. 123456"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredZipcode = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'City'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Enter city"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredCity = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'State'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Enter state"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredState = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Landmark'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Enter landmark"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredLandmark = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Alternate mobile no.'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Enter alternate mobile no."),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredAlternateNo = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lightGrey),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Address type'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Select Address type"),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cannot be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _addressType = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        function: () {
          _updateAddress();
        },
        title: 'Save Address',
      ),
    );
  }
}

class Field extends StatelessWidget {
  final String field;
  const Field({
    super.key,
    required this.field,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      field,
      style: const TextStyle(
        color: Color.fromRGBO(128, 128, 128, 1),
        fontSize: 12,
        fontFamily: 'NunitoSans',
      ),
    );
  }
}

class CommonStyle {
  static InputDecoration inputDecoration({String hintText = ""}) {
    return InputDecoration.collapsed(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color.fromRGBO(179, 179, 179, 1),
        fontSize: 16,
        fontFamily: 'NunitoSans',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
