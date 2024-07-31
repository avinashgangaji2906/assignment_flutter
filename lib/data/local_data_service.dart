import 'package:assignment_flutter/core/constants/constants.dart';
import 'package:assignment_flutter/core/error/exception.dart';
import 'package:assignment_flutter/models/user_data_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class LocalDataService {
  // store data in local storage
  void addUserData({
    required String panNumber,
    required String fullName,
    required String email,
    required String phoneNumber,
    required List<Addresses> addresses,
  }) async {
    UserDataModel userData = UserDataModel(
        userId: const Uuid().v1(),
        panNumber: panNumber,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        addresses: addresses);
    try {
      final box = await Hive.openBox(Constants.hiveBoxName);
      box.put(userData.userId, userData.toJson());
      // final data = box.get(userData.userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

// get all users from hive
  Future<List<UserDataModel>> getAllUsersData() async {
    try {
      final box = await Hive.openBox(Constants.hiveBoxName);
      List<UserDataModel> userDataList = box.values
          .map((e) => UserDataModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return userDataList;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

// Update user in Hive
  Future<void> updateUser({
    required UserDataModel newData,
  }) async {
    try {
      final box = await Hive.openBox(Constants.hiveBoxName);
      var existingUserJson = box.get(newData.userId);
      if (existingUserJson != null) {
        UserDataModel existingUser = UserDataModel.fromJson(
            Map<String, dynamic>.from(existingUserJson as Map));

        UserDataModel updatedUser = existingUser.copyWith(
          panNumber: newData.panNumber,
          fullName: newData.fullName,
          email: newData.email,
          phoneNumber: newData.phoneNumber,
          // addressLine1: newData.addressLine1,
          // addressLine2: newData.addressLine2,
          // postCode: newData.postCode,
          // city: newData.city,
          // state: newData.state,
        );
        await box.put(newData.userId, updatedUser.toJson());
        print('data updated with id ${newData.userId}');
      }
    } catch (e, stackTrace) {
      print('${e.toString()} ${stackTrace.toString()}');
      throw ServerException(message: e.toString());
    }
  }

// delete user from hive
  Future<bool> deleteUser({required String userId}) async {
    try {
      final box = await Hive.openBox(Constants.hiveBoxName);
      await box.delete(userId);
      return true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
