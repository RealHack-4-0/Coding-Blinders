import 'package:flutter/material.dart';
import 'add_record.dart';
import 'showAppointment.dart';

class DoctorView extends StatefulWidget {
  @override
  _DoctorViewState createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    PatientRecordForm(),
    PatientRecordForm(),
    AppointmentList(),
    PatientRecordForm(),
    PatientRecordForm()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor View'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Doctor Drawer'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Make Time Slot'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Show Appointments'),
              onTap: () {
                Navigator.pop(context);
                MaterialPageRoute(context) =>
                    getAppointments('640cde46fef7c4f7550c4480');
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('See Reports'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                // add sign out functionality here
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
