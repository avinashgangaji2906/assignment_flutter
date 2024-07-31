import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String keyData;
  final String value;
  const CustomTile({super.key, required this.keyData, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      shape: const Border.symmetric(
        horizontal: BorderSide(color: AppPallete.greyColor, width: 0.1),
      ),
      leading: Text(
        keyData,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
