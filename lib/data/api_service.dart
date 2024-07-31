import 'dart:convert';

import 'package:assignment_flutter/core/constants/constants.dart';
import 'package:assignment_flutter/core/error/exception.dart';
import 'package:assignment_flutter/models/pan_model.dart';
import 'package:assignment_flutter/models/post_code_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // function to verify PAN Number
  Future<PanModel> verifyPanNumber({required String panNumber}) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.verifyPanApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'panNumber': panNumber}),
      );

      if (response.statusCode == 200) {
        print(' Pan Data : ${response.body}');
        return PanModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException(message: 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // function to verify PostCode
  Future<PostcodeModel> verifyPostcodeNumber({required int postCode}) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.verifyPostcodeApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'postcode': postCode}),
      );

      if (response.statusCode == 200) {
        print(' PostCode Data : ${response.body}');
        return PostcodeModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException(message: 'Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print(e.toString() + stackTrace.toString());
      throw ServerException(message: e.toString());
    }
  }
}
