import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_rest/pages/home-page.dart';
import 'package:flutter_api_rest/utils/auth.dart';
import 'package:flutter_api_rest/utils/dialogs.dart';
import 'package:meta/meta.dart';

class MyAPI {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://curso-api-flutter.herokuapp.com'));

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
}
