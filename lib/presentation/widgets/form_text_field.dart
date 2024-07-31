import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:assignment_flutter/presentation/widgets/loader.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final int? maxLength;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool isLoading;
  final bool isVerified;
  final TextInputType? keyboardType;
  final bool? enabled;
  final String? Function(String?)? validator;
  // final ValueChanged<String?>? onChanged;
  const FormTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.maxLength,
    this.prefixIcon,
    this.prefixText,
    required this.isLoading,
    required this.isVerified,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.validator,
    // this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget? suffix;
    if (isLoading) {
      suffix = const Loader();
    } else if (isVerified) {
      suffix = const Icon(
        Icons.verified_outlined,
        color: AppPallete.greenColor,
      );
    }
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppPallete.whiteColor),
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffix: suffix,
      ),
      maxLength: maxLength,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      // onChanged: (value) => onChanged,
    );
  }
}
