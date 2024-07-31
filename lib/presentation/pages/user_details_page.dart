import 'package:assignment_flutter/core/theme/app_pallete.dart';
import 'package:assignment_flutter/models/user_data_model.dart';
import 'package:assignment_flutter/presentation/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final UserDataModel userData;
  static route(UserDataModel userData) => MaterialPageRoute(
      builder: (context) => UserDetailsPage(
            userData: userData,
          ));
  const UserDetailsPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userData.fullName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
              width: 100,
              child: CircleAvatar(
                backgroundColor: AppPallete.greyColor,
                child: Center(
                  child: Icon(
                    Icons.person_2_rounded,
                    size: 60,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // const Divider(
            //   color: AppPallete.greyColor,
            //   thickness: 0.5,
            // ),
            CustomTile(keyData: 'Full Name', value: userData.fullName),
            CustomTile(keyData: 'Pan Number', value: userData.panNumber),
            CustomTile(keyData: 'Email ', value: userData.email),
            CustomTile(keyData: 'Phone Number', value: userData.phoneNumber),
            // CustomTile(keyData: 'Line1 Address', value: userData.addressLine1),
            // CustomTile(keyData: 'Post code', value: userData.postCode),
          ],
        ),
      ),
    );
  }
}
