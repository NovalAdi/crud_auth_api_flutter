import 'dart:convert';
import 'dart:developer';

import '../constants/api_config.dart';
import 'package:http/http.dart' as http;

import '../locals/secure_storage.dart';
import '../models/user.dart';

class UserService {
  static Future<bool> update({
    required int id,
    required String email,
    required String name,
  }) async {
    try {
      final url = '${ApiConfig.baseUrl}/${ApiConfig.userUpdateEndpoint}/$id';
      final data = {
        'email': email,
        'name': name,
      };
      final token = await SecureStorage.getToken();

      final header = {
        'authorization': 'Bearer $token',
      };
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: header,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final user = User.fromJson(responseJson['data']);

          await SecureStorage.cacheUser(user: user);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log('$e');
      return false;
    }
  }
}
