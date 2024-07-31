import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:assignment_flutter/core/utils/show_snackbar.dart';
import 'package:assignment_flutter/models/post_code_model.dart';
import 'package:assignment_flutter/presentation/widgets/dropdown_form_field.dart';
import 'package:assignment_flutter/presentation/widgets/form_text_field.dart';
import 'package:assignment_flutter/provider/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressField extends StatefulWidget {
  final int? index;
  final TextEditingController line1Controller;
  final TextEditingController line2Controller;
  final TextEditingController postCodeController;
  List<LocationData>? city;
  List<LocationData>? state;

  AddressField({
    super.key,
    this.index,
    required this.line1Controller,
    required this.line2Controller,
    required this.postCodeController,
    this.city,
    this.state,
  });

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  @override
  void initState() {
    super.initState();
    widget.postCodeController.addListener(() {
      if (widget.postCodeController.text.trim().length == 6) verifyPostcode();
    });
  }

  void verifyPostcode() {
    UserDataProvider provider = Provider.of(context, listen: false);
    provider.setPostCodeVerified = false;
    final postcodeRegex = RegExp(r'^[1-9][0-9]{5}$');
    if (postcodeRegex.hasMatch(widget.postCodeController.text.trim())) {
      provider.verifyPostalcodeNumber(
          postCode:
              int.parse(widget.postCodeController.text.toUpperCase().trim()),
          index: widget.index!);
    } else {
      showSnackbar(context, 'Invalid post code number',
          color: AppPallete.errorColor, textColor: AppPallete.whiteColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              provider.removeAddressField(widget.index!);
            },
            icon: const Icon(
              Icons.remove_circle_outline_rounded,
              color: AppPallete.errorColor,
            ),
          ),
        ),
        FormTextField(
          labelText: 'Line 1',
          controller: widget.line1Controller,
          isLoading: false,
          isVerified: false,
          prefixIcon: const Icon(Icons.location_on_rounded),
          validator: (value) => provider.validateLine1Address(value),
        ),
        const SizedBox(
          height: 15,
        ),
        FormTextField(
          labelText: 'Line 2',
          controller: widget.line2Controller,
          isLoading: false,
          isVerified: false,
          prefixIcon: const Icon(Icons.location_off_rounded),
        ),
        const SizedBox(
          height: 15,
        ),
        FormTextField(
          labelText: 'Post Code',
          controller: widget.postCodeController,
          maxLength: 6,
          isLoading: provider.isPostCodeLoading,
          isVerified: provider.isPostCodeVerified,
          prefixIcon: const Icon(Icons.location_pin),
          keyboardType: TextInputType.number,
          validator: (value) => provider.validatePostCode(value),
        ),
        const SizedBox(
          height: 15,
        ),
        if (provider.addressFields[widget.index!].city != null &&
            provider.addressFields[widget.index!].state != null)
          dropDownFields(provider),
        const Divider(
          color: AppPallete.greyColor,
          thickness: 0.5,
        )
      ],
    );
  }

  // City and State dropdown widget
  Widget dropDownFields(UserDataProvider provider) {
    return Column(
      children: [
        CustomDropdownButtonFormField(
          value: provider.addressFields[widget.index!].city!.first.name,
          items: provider.addressFields[widget.index!].city!,
          prefixIcon: const Icon(Icons.location_city_outlined),
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 15,
        ),
        CustomDropdownButtonFormField(
          value: provider.addressFields[widget.index!].state!.first.name,
          items: provider.addressFields[widget.index!].state!,
          prefixIcon: const Icon(Icons.flag_rounded),
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
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
