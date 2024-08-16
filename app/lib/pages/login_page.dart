import 'dart:convert';

import 'package:app/pages/home_page.dart';
import 'package:app/pages/signup_page.dart';
import 'package:app/service/account.dart';
import 'package:app/service/url.dart';
import 'package:app/widgets/error_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      appBar: AppBar(title: Text('FilmFinder')),
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
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text('Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                    _nextPage(Account.createGuest());
                  },
                  child: Text('Continue as Guest'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(String username, String password) async {
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
      Account account = Account.fromResponseBody(json.decode(response.body));
      _nextPage(account);
    } else {
      showError(
          context, 'Login Failed', 'Incorrect username/password combination.');
    }
  }

  void _nextPage(Account account) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => HomePage(account: account)));
  }
}
