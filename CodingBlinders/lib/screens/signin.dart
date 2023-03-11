import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50.00,
                  width: 300.00,
                  child: ElevatedButton(
                    onPressed: () {},
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
