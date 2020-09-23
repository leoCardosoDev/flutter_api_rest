import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_rest/pages/login-page.dart';
import 'package:flutter_api_rest/utils/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  Auth._internal();
  static Auth _instance = Auth._internal();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final key = "SESSION";

  Future<String> get accessToken async {
    final Session session = await this.getSession();
    if (session != null) {
      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int differenceInSeconds =
          currentDate.difference(createdAt).inSeconds;
      if (expiresIn - differenceInSeconds >= 60) {
        return session.token;
      } else {
        print("Refresh token");
        return null;
      }
    }
    return null;
  }

  Future<void> setSession(Map<String, dynamic> data) async {
    final session = Session(
      token: data['token'],
      expiresIn: data['expiresIn'],
      createdAt: DateTime.now(),
    );

    final String value = jsonEncode(session.toJson());
    await this._storage.write(key: key, value: value);
  }

  Future<Session> getSession() async {
    final String value = await this._storage.read(key: key);
    if (value != null) {
      final Map<String, dynamic> json = jsonDecode(value);
      final session = Session.fromJson(json);
      return session;
    }
    return null;
  }

  Future<void> logOut(BuildContext context) async {
    await this._storage.deleteAll();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.routeName,
      (_) => false,
    );
  }
}
