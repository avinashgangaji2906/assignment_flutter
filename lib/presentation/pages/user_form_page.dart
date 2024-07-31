import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:assignment_flutter/core/utils/show_snackbar.dart';
import 'package:assignment_flutter/models/user_data_model.dart';
import 'package:assignment_flutter/presentation/pages/user_list_page.dart';
import 'package:assignment_flutter/presentation/widgets/address_fields.dart';
import 'package:assignment_flutter/presentation/widgets/form_button.dart';
import 'package:assignment_flutter/presentation/widgets/form_text_field.dart';
import 'package:assignment_flutter/provider/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserFormScreen extends StatefulWidget {
  final UserDataModel? userData;
  static route({UserDataModel? userData}) => MaterialPageRoute(
      builder: (context) => UserFormScreen(
            userData: userData,
          ));
  const UserFormScreen({super.key, this.userData});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _fullNameController = TextEditingController();
  final _panController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      _panController.addListener(() {
        if (_panController.text.trim().length == 10) verifyPanNumber(provider);
      });

      if (widget.userData != null) {
        _panController.text = widget.userData!.panNumber;
        _emailController.text = widget.userData!.email;
        _phoneController.text = widget.userData!.phoneNumber;
      } else {
        provider.resetData = '';
        _panController.clear();
        _fullNameController.clear();
        _emailController.clear();
        _phoneController.clear();
      }
    });
  }

  void verifyPanNumber(UserDataProvider provider) {
    provider.setPanVerified = false;
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (panRegex.hasMatch(_panController.text.toUpperCase().trim())) {
      provider.verifyPanNumber(
          panNumber: _panController.text.toUpperCase().trim());
    } else {
      showSnackbar(context, 'Invalid PAN number',
          color: AppPallete.errorColor, textColor: AppPallete.whiteColor);
    }
  }

  void addUserData() {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    provider.addUserData(
        panNumber: _panController.text.trim().toUpperCase(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        addresses: provider.addresses);
  }

  void updateUserData() {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    UserDataModel updatedUserData = UserDataModel(
        userId: widget.userData!.userId,
        panNumber: _panController.text.trim().toUpperCase(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        addresses: []);
    provider.updateUser(newData: updatedUserData);
  }

// function for disposing all the text field controllers to avoid the memory leak issue
  @override
  void dispose() {
    super.dispose();
    _panController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Information Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Consumer<UserDataProvider>(
            builder: (context, provider, child) {
              if (!provider.isPanLoading || !provider.isPostCodeLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (provider.fullName.isNotEmpty) {
                    _fullNameController.text = provider.fullName;
                  }
                });
                return Form(
                  key: provider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // PAN
                      FormTextField(
                        labelText: 'PAN Number',
                        controller: _panController,
                        maxLength: 10,
                        isLoading: provider.isPanLoading,
                        isVerified: provider.isPanVerified,
                        prefixIcon: const Icon(Icons.credit_card_rounded),
                        validator: (value) => provider.validatePanNumber(value),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Full Name : Non editable field
                      FormTextField(
                        labelText: 'Full Name',
                        controller: _fullNameController,
                        maxLength: 140,
                        isLoading: false,
                        isVerified: false,
                        enabled: false,
                        prefixIcon: const Icon(Icons.abc_rounded),
                        validator: (value) => provider.validateFullName(value),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Email
                      FormTextField(
                        labelText: 'Email Address',
                        controller: _emailController,
                        maxLength: 255,
                        isLoading: false,
                        isVerified: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_rounded),
                        validator: (value) => provider.validateEmail(value),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Phone
                      FormTextField(
                        labelText: 'Phone Number',
                        controller: _phoneController,
                        maxLength: 10,
                        prefixIcon: const Icon(Icons.phone_rounded),
                        prefixText: '+91 ',
                        isLoading: false,
                        isVerified: false,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            provider.validatePhoneNumber(value),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Addresses',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () {
                                provider.addNewAddressField();
                              },
                              icon: const Icon(Icons.add))
                        ],
                      ),

                      SizedBox(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.addressFields.length,
                          itemBuilder: (context, index) {
                            return AddressField(
                              index: index,
                              line1Controller:
                                  provider.addressFields[index].line1Controller,
                              line2Controller:
                                  provider.addressFields[index].line2Controller,
                              postCodeController: provider
                                  .addressFields[index].postCodeController,
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      // form button
                      FormButton(
                        buttonName:
                            widget.userData == null ? 'SUBMIT' : 'UPDATE',
                        onPress: () {
                          if (provider.formKey.currentState!.validate()) {
                            if (widget.userData == null) {
                              addUserData();
                            } else {
                              updateUserData();
                            }
                            Navigator.pushAndRemoveUntil(
                              context,
                              UserListPage.route(),
                              (route) => false,
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

// // City and State dropdown widget
//   Widget dropDownFields(UserDataProvider provider) {
//     return Column(
//       children: [
//         // Reusable Custom dropdown widget
//         CustomDropdownButtonFormField(
//           value: provider.city.first.name,
//           items: provider.city,
//           prefixIcon: const Icon(Icons.location_city_outlined),
//           onChanged: (value) => cityName = value ?? provider.city.first.name,
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         CustomDropdownButtonFormField(
//           value: provider.state.first.name,
//           items: provider.state,
//           prefixIcon: const Icon(Icons.flag_rounded),
//           onChanged: (value) => stateName = value ?? provider.state.first.name,
//         ),
//       ],
//     );
//   }
}

 // Line 1
                      // FormTextField(
                      //   labelText: 'Line 1',
                      //   controller: _line1Controller,
                      //   isLoading: false,
                      //   isVerified: false,
                      //   prefixIcon: const Icon(Icons.location_on_rounded),
                      //   validator: (value) =>
                      //       provider.validateLine1Address(value),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // // Line 2
                      // FormTextField(
                      //   labelText: 'Line 2',
                      //   controller: _line2Controller,
                      //   isLoading: false,
                      //   isVerified: false,
                      //   prefixIcon: const Icon(Icons.location_off_rounded),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // // Line 2
                      // FormTextField(
                      //   labelText: 'Post Code',
                      //   controller: _postCodeController,
                      //   maxLength: 6,
                      //   isLoading: provider.isPostCodeLoading,
                      //   isVerified: provider.isPostCodeVerified,
                      //   prefixIcon: const Icon(Icons.location_pin),
                      //   keyboardType: TextInputType.number,
                      //   validator: (value) => provider.validatePostCode(value),
                      // ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // if (provider.city.isNotEmpty && provider.state.isNotEmpty)
                      //   dropDownFields(provider),
