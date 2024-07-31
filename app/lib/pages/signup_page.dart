import 'dart:convert';

import 'package:app/pages/home_page.dart';
import 'package:app/service/account.dart';
import 'package:app/widgets/error_popup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailController = TextEditingController();
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
                  'Sign Up',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
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
                    _signup(_emailController.text, _usernameController.text,
                        _passwordController.text);
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

  void _signup(String email, String username, String password) async {
    final Uri loginUrl = Uri.parse('http://localhost:8000/api/account/signup/');

    // Constructing the request body
    final Map<String, String> requestBody = {
      'email': email,
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
      Account account = Account.fromResponseBody(json.decode(response.body));

      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => HomePage(account: account)));
    } else {
      showError(context, 'Sign up Failed',
          'Please try again with a different username');
    }
  }
}
