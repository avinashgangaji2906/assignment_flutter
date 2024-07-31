import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context,
  String content, {
  Color color = AppPallete.whiteColor,
  Color textColor = AppPallete.backgroundColor,
}) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            content,
            style: TextStyle(color: textColor),
          ),
          backgroundColor: color,
        ),
      );
