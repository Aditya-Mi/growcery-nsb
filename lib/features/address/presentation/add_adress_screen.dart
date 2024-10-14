import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/core/common_widgets/custom_button.dart';
import 'package:grocery_app/core/common_widgets/custom_button_text.dart';
import 'package:grocery_app/core/constants/colors.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/provider/address_provider.dart';
import 'package:grocery_app/features/products/provider/network_provider.dart';
import 'package:grocery_app/utils/helper_functions.dart';

class EditAddress extends ConsumerStatefulWidget {
  final Address? address;
  const EditAddress({
    super.key,
    this.address,
  });

  @override
  ConsumerState<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends ConsumerState<EditAddress> {
  var addressType = ['Home', 'Work', 'Other'];
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  var _enteredName = '';
  var _enteredLocality = '';
  var _enteredZipcode = '127306';
  var _enteredCity = 'Charkhi Dadri';
  var _enteredLandmark = '';
  var _enteredState = 'Haryana';
  var _enteredAlternateNo = '';
  var _addressType = 'Home';

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _enteredName = widget.address!.fullName;
      _enteredLocality = widget.address!.locality;
      _enteredZipcode = widget.address!.pincode;
      _enteredCity = widget.address!.city;
      _enteredLandmark = widget.address!.landmark;
      _enteredState = widget.address!.state;
      _enteredAlternateNo = widget.address!.alternativePhone;
      _addressType = widget.address!.addressType;
    }
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

  Future<void> _updateAddress() async {
    bool success = false;
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    Address address;

    if (widget.address != null) {
      address = Address(
        fullName: _enteredName,
        locality: _enteredLocality,
        pincode: _enteredZipcode,
        city: _enteredCity,
        state: _enteredState,
        landmark: _enteredLandmark,
        alternativePhone: _enteredAlternateNo,
        addressType: _addressType,
        isDefault: false,
        id: widget.address!.id,
      );
    } else {
      address = Address(
        fullName: _enteredName,
        locality: _enteredLocality,
        pincode: _enteredZipcode,
        city: _enteredCity,
        state: _enteredState,
        landmark: _enteredLandmark,
        alternativePhone: _enteredAlternateNo,
        addressType: _addressType,
      );
    }

    if (widget.address != null) {
      success = await ref.read(addressProvider.notifier).updateAddress(address);
    } else {
      success = await ref.read(addressProvider.notifier).addAddress(address);
    }
    if (success && context.mounted) {
      Helper.showSnackbar(
          context,
          widget.address != null
              ? 'Address updated successfully'
              : 'New address added successfully');
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Add Shipping address',
          style: TextStyle(
              fontFamily: 'Merriweather',
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Full Name'),
                        TextFormField(
                          decoration: CommonStyle.inputDecoration(
                              hintText: "Ex. John Doe"),
                          initialValue: _enteredName,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Locality'),
                        TextFormField(
                          initialValue: _enteredLocality,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Zipcode (postal code)'),
                        TextFormField(
                          initialValue: _enteredZipcode,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'City'),
                        TextFormField(
                          initialValue: _enteredCity,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'State'),
                        TextFormField(
                          initialValue: _enteredState,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Landmark'),
                        TextFormField(
                          initialValue: _enteredLandmark,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Alternate mobile no.'),
                        TextFormField(
                          initialValue: _enteredAlternateNo,
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
                  const SizedBox(height: 20),
                  CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Field(field: 'Address type'),
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            items: addressType.map(buildMenuItem).toList(),
                            value: _addressType,
                            icon: const Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            onChanged: (value) =>
                                setState(() => _addressType = value!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomButton(
        function: _isLoading
            ? null
            : () async {
                bool isInternet = await checkInternetConnection();
                if (isInternet) {
                  await _updateAddress();
                }
              },
        child:
            CustomButtonText(title: _isLoading ? 'Saving...' : 'Save Address'),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(),
        ),
      );
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

class CustomContainer extends StatelessWidget {
  final Widget child;
  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: lightGrey),
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }
}
