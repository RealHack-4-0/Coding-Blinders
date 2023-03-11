import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/signin.dart';
import 'screens/signup.dart';
import 'screens/user/user_home.dart';
import 'screens/admin/admin_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/doctor/add_record.dart';
import 'screens/Staff/StaffNurseHome.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkUserLoggedIn(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/splash_bg.svg"),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.00),
              child: Column(
                children: [
                  Spacer(),
                  // SvgPicture.asset(
                  //   "assets/icons/gerda_logo.svg",
                  // ),
                  Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        height: 50.00,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.yellow[900],
                          ),
                          child: Text("Sign Up"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        height: 50.00,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            // backgroundColor: Color(0xFF6CD8D1),
                            elevation: 0,

                            backgroundColor: Colors.transparent,

                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFF6CD8D1)),
                            ),
                          ),
                          child: Text("Sign In"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100.00),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> checkUserLoggedIn(context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final uid = prefs.getString('uid') ?? '';
  final role = prefs.getString('role') ?? '';

  if (token != null && token.isNotEmpty) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChooseRole(role: role)),
    );
  } else {
    MyApp();
  }
}

class ChooseRole extends StatelessWidget {
  final String role;

  const ChooseRole({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'doctor':
        return PatientRecordForm();
      case 'staff':
      case 'nurse':
        return StaffNurseHome();
      case 'admin':
        return RegistrationForm();
      case 'patient':
        return HomeScreen();
      default:
        return Scaffold(
          body: Center(
            child: Text('Invalid role.'),
          ),
        );
    }
  }
}
