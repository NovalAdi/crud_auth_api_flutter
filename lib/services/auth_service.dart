import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crud_api_app/constants/api_config.dart';
import 'package:crud_api_app/locals/secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  // ! Dibikin singleton biar mastiin yg dibikin program hanya 1 object yg dibuat dari class ini
  AuthService._();

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}';
      final data = {
        'email': email,
        'password': password,
      };
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final token = responseJson['access_token'];
          final user = User.fromJson(responseJson['data']);
          // ! Cache User dan token
          await SecureStorage.cacheToken(token: token);
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

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.registerEndpoint}';
      final data = {
        'name': name,
        'email': email,
        'password': password,
      };
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final token = responseJson['access_token'];
          final user = User.fromJson(responseJson['data']);
          // ! Cache User dan token
          await SecureStorage.cacheToken(token: token);
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

  static Future<bool> logout() async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.logoutEndpoint}';
      final token = await SecureStorage.getToken();
      log(token.toString());
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await http.get(Uri.parse(url), headers: headers);
      log(response.body);
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log('Error $e');
      return false;
    }
  }
}
