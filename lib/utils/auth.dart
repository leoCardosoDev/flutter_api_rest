import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_rest/api/my_api.dart';
import 'package:flutter_api_rest/pages/login-page.dart';
import 'package:flutter_api_rest/utils/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  Auth._internal();
  static Auth _instance = Auth._internal();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final key = "SESSION";

  Completer _completer;

  Future<String> get accessToken async {
    if (_completer != null) {
      await _completer.future;
    }
    _completer = Completer();

    final Session session = await this.getSession();
    if (session != null) {
      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int differenceInSeconds =
          currentDate.difference(createdAt).inSeconds;
      if (expiresIn - differenceInSeconds >= 60) {
        _complete();
        return session.token;
      } else {
        final Map<String, dynamic> data =
            await MyAPI.instance.refresh(session.token);
        if (data != null) {
          await this.setSession(data);
          _complete();
          return data['token'];
        }
        _complete();
        return null;
      }
    }
    _complete();
    return null;
  }

  _complete() {
    if (this._completer != null && !this._completer.isCompleted) {
      this._completer.complete();
    }
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
