import 'dart:convert';

import 'package:app/service/url.dart';
import 'package:http/http.dart' as http;

class Account {
  String username;
  String email;
  String token;

  Account({
    required this.username,
    required this.email,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'token': token,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      username: map['username'] as String,
      email: map['email'] as String,
      token: map['token'] as String,
    );
  }

  factory Account.fromResponseBody(var jsonResponse) {
    return Account(
      email: jsonResponse['user']['email'],
      username: jsonResponse['user']['username'],
      token: jsonResponse['token'],
    );
  }

  static Future<Account?> login(String username, String password) async {
    Uri loginUri = getUrl("/api/account/login/");

    // Constructing the request body
    final Map<String, String> requestBody = {
      'username': username,
      'password': password,
    };

    // Making the POST request
    final http.Response response = await http.post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      return Account.fromResponseBody(json.decode(response.body));
    } else {
      return null;
    }
  }

  static Future<Account?> signup(
      String email, String username, String password) async {
    Uri signupUrl = getUrl("/api/account/signup/");

    // Constructing the request body
    final Map<String, String> requestBody = {
      'email': email,
      'username': username,
      'password': password,
    };

    // Making the POST request
    final http.Response response = await http.post(
      signupUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      return Account.fromResponseBody(json.decode(response.body));
    } else {
      return null;
    }
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(username: $username, email: $email, token: $token)';
  }
}
