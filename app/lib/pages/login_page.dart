import 'package:app/pages/home_page.dart';
import 'package:app/pages/signup_page.dart';
import 'package:app/service/account.dart';
import 'package:app/widgets/error_popup.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

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
                  onPressed: () async {
                    _guestLogin();
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

  void _guestLogin() async {
    showLoaderDialog(context);
    String username = generateUniqueUsername();
    String password = generateUniqueUsername();
    Account? account =
        await Account.signup('$username@email.com', username, password);
    Navigator.pop(context);

    if (account != null) {
      _nextPage(account);
    } else {
      showError(context, 'Login Failed', 'Please try again.');
    }
  }

  void _login(String username, String password) async {
    showLoaderDialog(context);
    Account? account = await Account.login(username, password);
    Navigator.pop(context);

    if (account != null) {
      _nextPage(account);
    } else {
      showError(context, 'Login Failed', 'Please try again.');
    }
  }

  void _nextPage(Account account) {
    Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => HomePage(account: account)));
  }

  String generateUniqueUsername() {
    var uuid = Uuid();
    String uniqueId = uuid.v4(); // Generates a random UUID

    String uniqueUsername = "Guest_$uniqueId";

    return uniqueUsername;
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
