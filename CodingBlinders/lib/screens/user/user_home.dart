import 'package:flutter/material.dart';
import 'showAppoinment.dart';
import 'addAppoinment.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          SizedBox(height: 15,),
          Text(
            'Welcome to National Hospital',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Centre of Excellence in Health Care',
            style: TextStyle(
              fontSize: 24,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15,),
          Container(
            child: Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        viewportFraction: 2,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: [
                        Image.network('http://www.nhsl.health.gov.lk/web/images/h-slide-5.jpg'),
                        Image.network('http://www.nhsl.health.gov.lk/web/images/h-slide-3.jpg'),
                        Image.network('http://www.nhsl.health.gov.lk/web/images/h-slide-4.jpg'),
                        Image.network('http://www.nhsl.health.gov.lk/web/images/h-slide-21.jpg'),
                        // Image.network('https://cdn.hirunews.lk/Data/News_Images/202004/1587210106_650168_hirunews_Genaral-Hospital.jpg'),
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
