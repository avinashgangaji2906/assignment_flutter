import 'package:assignment_flutter/core/error/exception.dart';
import 'package:assignment_flutter/data/api_service.dart';
import 'package:assignment_flutter/data/local_data_service.dart';
import 'package:assignment_flutter/models/user_data_model.dart';
import 'package:assignment_flutter/presentation/widgets/address_fields.dart';
import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier {
  String _fullName = '';

  List<UserDataModel> _allUsers = [];
  List<AddressField> _addressFields = [];
  List<Addresses> _addresses = [];
  bool _isPanLoading = false;
  bool _isPanVerified = false;
  bool _isPostCodeLoading = false;
  bool _isPostCodeVerified = false;
  bool _isAllUsersLoading = false;
  final _formKey = GlobalKey<FormState>();

  String get fullName => _fullName;

  List<UserDataModel> get allUsers => _allUsers;
  List<AddressField> get addressFields => _addressFields;
  List<Addresses> get addresses => _addresses;
  bool get isPanLoading => _isPanLoading;
  bool get isPanVerified => _isPanVerified;
  bool get isPostCodeLoading => _isPostCodeLoading;
  bool get isPostCodeVerified => _isPostCodeVerified;
  bool get isAllUsersLoading => _isAllUsersLoading;
  GlobalKey<FormState> get formKey => _formKey;

  set resetData(String fullName) {
    _fullName = fullName;
    notifyListeners();
  }

  set setPanVerified(bool isVerified) {
    _isPanVerified = isVerified;
    notifyListeners();
  }

  set setPostCodeVerified(bool isVerified) {
    _isPostCodeVerified = isVerified;
    notifyListeners();
  }

  final ApiService _apiService = ApiService();
  final LocalDataService _localDataService = LocalDataService();

  String? validatePanNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "PAN number is required";
    }
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(value.trim().toUpperCase())) {
      return "Enter a valid PAN number";
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'FullName is required';
    }
    return null;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateLine1Address(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  String? validatePostCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postcode is required';
    }
    final postcoderegex = RegExp(r'^[1-9][0-9]{5}$');
    if (!postcoderegex.hasMatch(value)) {
      return 'Enter a valid PostCode';
    }
    return null;
  }

  void addNewAddressField() {
    _addressFields.add(
      AddressField(
        line1Controller: TextEditingController(),
        line2Controller: TextEditingController(),
        postCodeController: TextEditingController(),
      ),
    );
    notifyListeners();
  }

  void removeAddressField(int index) {
    _addressFields[index].line1Controller.dispose();
    _addressFields[index].line2Controller.dispose();
    _addressFields[index].postCodeController.dispose();
    _addressFields.removeAt(index);
    notifyListeners();
  }

// verify PAN function connects with data layer verify pan function
  Future<void> verifyPanNumber({
    required String panNumber,
  }) async {
    try {
      _isPanLoading = true;
      notifyListeners();
      final res = await _apiService.verifyPanNumber(panNumber: panNumber);
      _fullName = res.fullName;
      _isPanVerified = true;
      notifyListeners();
    } catch (e) {
      _isPanLoading = false;
      _isPanVerified = false;
      notifyListeners();
      throw ServerException(message: e.toString());
    } finally {
      _isPanLoading = false;
      notifyListeners();
    }
  }

// verify Post Code function connects with data layer verify Post Code function
  Future<void> verifyPostalcodeNumber(
      {required int postCode, required int index}) async {
    try {
      _isPostCodeLoading = true;
      notifyListeners();
      final res = await _apiService.verifyPostcodeNumber(postCode: postCode);
      _addressFields[index].city = res.city; // Set city
      _addressFields[index].state = res.state; // Set state
      _isPostCodeVerified = true;
      notifyListeners();
    } catch (e) {
      _isPostCodeLoading = false;
      _isPostCodeVerified = false;
      notifyListeners();
      throw ServerException(message: e.toString());
    } finally {
      _isPostCodeLoading = false;
      notifyListeners();
    }
  }

// store user data function connects with data layer addUser data function
  void addUserData({
    required String panNumber,
    required String fullName,
    required String email,
    required String phoneNumber,
    required List<Addresses> addresses,
  }) async {
    try {
      _localDataService.addUserData(
        panNumber: panNumber,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        addresses: addresses,
      );
    } catch (e) {
      ServerException(message: e.toString());
    }
  }

// get all users
  void getAllUsers() async {
    try {
      _isAllUsersLoading = true;
      notifyListeners();
      _allUsers = await _localDataService.getAllUsersData();
    } catch (e) {
      _isAllUsersLoading = false;
      notifyListeners();
      throw ServerException(message: e.toString());
    } finally {
      _isAllUsersLoading = false;
      notifyListeners();
    }
  }

// Update user and update the local list
  Future<void> updateUser({
    required UserDataModel newData,
  }) async {
    await _localDataService.updateUser(newData: newData);
    int index = _allUsers.indexWhere((user) => user.userId == newData.userId);
    if (index != -1) {
      _allUsers[index] = newData;
      notifyListeners();
    }
  }

// delete user
  Future<bool> deleteUser({required String userId}) async {
    try {
      final res = await _localDataService.deleteUser(userId: userId);
      if (res) {
        allUsers.removeWhere((user) => user.userId == userId);
        notifyListeners();
      }
      return res;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
