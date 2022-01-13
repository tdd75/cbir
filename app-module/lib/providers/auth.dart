import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/api.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> login(String email, password) async {
    dynamic response = await Api.login(email, password);

    _token = response['data']['accessToken'];
    _refreshToken = response['data']['refreshToken'];

    _expiryDate =
        DateTime.now().add(Duration(seconds: response['data']['expiresIn']));
    // _autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'refreshToken': _refreshToken,
      'expiryDate': _expiryDate!.toIso8601String(),
    });
    prefs.setString('userData', userData);
  }

  Future<void> signUp(String email, displayName, password) async {
    await Api.signUp(email, displayName, password);
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
