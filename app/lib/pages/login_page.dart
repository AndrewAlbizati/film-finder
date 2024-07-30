import 'dart:convert';

import 'package:app/service/account.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    _login(_usernameController.text, _passwordController.text);
                  },
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    // Add sign up logic here
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(String username, String password) async {
    final Uri loginUrl = Uri.parse('http://localhost:8000/api/account/login/');

    // Constructing the request body
    final Map<String, String> requestBody = {
      'username': username,
      'password': password,
    };

    // Making the POST request
    final http.Response response = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      Account account = Account(
        email: jsonResponse['user']['email'],
        username: jsonResponse['user']['username'],
        token: jsonResponse['token'],
      );
      print(account);
    } else {
      throw Exception('Failed to login');
    }
  }
}
