import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin/admin_home.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Call the login function with the username and password
    login(context, username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/splash_bg.svg"),
          Padding(
            padding: EdgeInsets.all(10.00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'User Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    // Update the username value when the text changes
                    // (this is not necessary, but may be useful if you
                    // want to perform validation or other processing
                    // on the input values)
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    // Update the password value when the text changes
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50.00,
                  width: 300.00,
                  child: ElevatedButton(
                    onPressed: () {
                      _login(); // Call the login function on button press
                    },
                    style: TextButton.styleFrom(
                      // backgroundColor: Color(0xFF6CD8D1),
                      elevation: 0,

                      backgroundColor: Colors.blue[600],

                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xFF6CD8D1)),
                      ),
                    ),
                    child: Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> login(
    BuildContext context, String username, String password) async {
  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/user/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    // Login successful, navigate to adminHome screen
    final responseData = json.decode(response.body);
    print(responseData);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationForm()),
    );
  } else {
    // Login failed, handle error here
    print('Login failed');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationForm()),
    );
  }
}
