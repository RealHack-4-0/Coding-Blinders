import 'package:flutter/material.dart';
import 'showAppoinment.dart';
import 'addAppoinment.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codingblinders/screens/signin.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AddAppointment(),
    HomeScreenWidget(),
    AddAppointment(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient View"),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Show',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
        ],
      ),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 200,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: [
                      Image.network('https://picsum.photos/id/1015/800/600'),
                      Image.network('https://picsum.photos/id/1016/800/600'),
                      Image.network('https://picsum.photos/id/1018/800/600'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'That is a paragraph',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              signOut(context);
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class MakeAppointmentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Make Appointment Screen",
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

void signOut(BuildContext context) async {
  await clearUserData();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInPage()),
  );
}

Future<void> clearUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
