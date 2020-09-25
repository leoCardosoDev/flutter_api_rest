import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_rest/models/user.dart';
import 'package:flutter_api_rest/pages/home-page.dart';
import 'package:flutter_api_rest/utils/auth.dart';
import 'package:flutter_api_rest/utils/dialogs.dart';
import 'package:flutter_api_rest/utils/extras.dart';
import 'package:meta/meta.dart';

const baseUrl = 'https://curso-api-flutter.herokuapp.com';

class MyAPI {
  MyAPI._internal();
  static MyAPI _instance = MyAPI._internal();
  static MyAPI get instance => _instance;

  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<void> register(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final Response response = await this._dio.post('/api/v1/register', data: {
        "username": username,
        "email": email,
        "password": password,
      });
      await Auth.instance.setSession(response.data);
      progressDialog.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (_) => false);
    } catch (error) {
      progressDialog.dismiss();
      if (error is DioError) {
        Dialogs.info(
          context,
          title: "ERROR",
          content: error.response.statusCode == 409
              ? 'Duplicated email or username'
              : error.message,
        );
      }
    }
  }

  Future<void> login(
    BuildContext context, {
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final Response response = await this._dio.post('/api/v1/login', data: {
        "email": email,
        "password": password,
      });
      await Auth.instance.setSession(response.data);
      progressDialog.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, HomePage.routeName, (_) => false);
    } catch (error) {
      progressDialog.dismiss();
      if (error is DioError) {
        String errorMessage = error.message;
        if (error.response.statusCode == 404) {
          errorMessage = 'User not found';
        } else if (error.response.statusCode == 403) {
          errorMessage = 'Invalid password';
        }
        Dialogs.info(
          context,
          title: "ERROR",
          content: errorMessage,
        );
      }
    }
  }

  Future<dynamic> refresh(String expiredToken) async {
    try {
      final Response response = await this._dio.post('/api/v1/refresh-token',
          options: Options(headers: {'token': expiredToken}));
      return response.data;
    } catch (error) {
      return null;
    }
  }

  Future<User> getUserInfo() async {
    try {
      final String token = await Auth.instance.accessToken;
      final Response response = await this._dio.get('/api/v1/user-info',
          options: Options(headers: {'token': token}));
      return User.fromJson(response.data);
    } catch (error) {
      return null;
    }
  }

  Future<String> updateAvatar(Uint8List bytes, String filePath) async {
    try {
      final String token = await Auth.instance.accessToken;
      FormData formData = FormData.fromMap({
        'attachment': MultipartFile.fromBytes(
          bytes,
          filename: Extras.getFileName(filePath),
        ),
      });

      final Response response = await this._dio.post('/api/v1/update-avatar',
          options: Options(headers: {
            'token': token,
          }),
          data: formData);
      return baseUrl + response.data;
    } catch (error) {
      if (error is DioError) {
        print(error.response.data);
      }
      return null;
    }
  }
}
