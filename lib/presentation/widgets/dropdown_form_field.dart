import 'package:assignment_flutter/models/post_code_model.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String value;
  final List<LocationData> items;
  final Function(String?) onChanged;
  final String label;
  final Icon prefixIcon;

  const CustomDropdownButtonFormField(
      {super.key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.label = '',
      required this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, prefixIcon: prefixIcon),
      items: items
          .map(
            (e) => DropdownMenuItem<String>(
              value: e.name,
              alignment: Alignment.center,
              child: Text(e.name),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
