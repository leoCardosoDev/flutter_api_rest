import 'dart:convert';

import 'package:flutter_api_rest/utils/session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  Auth._internal();
  static Auth _instance = Auth._internal();
  static Auth get instance => _instance;

  final _storage = FlutterSecureStorage();
  final key = "SESSION";

  Future<void> setSession(Session session) async {
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
}
