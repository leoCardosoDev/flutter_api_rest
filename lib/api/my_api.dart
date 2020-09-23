import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_rest/utils/dialogs.dart';
import 'package:meta/meta.dart';

class MyAPI {
  final Dio _dio = Dio();

  Future<void> register(
    BuildContext context, {
    @required String username,
    @required String email,
    @required String password,
  }) async {
    final ProgressDialog progressDialog = ProgressDialog(context);
    try {
      progressDialog.show();
      final Response response = await this._dio.post(
          'https://curso-api-flutter.herokuapp.com/api/v1/register',
          data: {
            "username": username,
            "email": email,
            "password": password,
          });
      progressDialog.dismiss();
      if (response.statusCode == 200) {
        Dialogs.info(
          context,
          title: "SUCCESS",
          content: 'User created with success!',
        );
      }
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
}
