import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: Center(
        child: CircularProgressIndicator(
          color: AppPallete.greenColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
