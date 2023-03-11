import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/doctormodel2.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: FutureBuilder(
            future: fetchDoctor(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final doctor = snapshot.data as Doctormodel;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/female-doctor.jpg'),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Name: ${doctor.name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Email: ${doctor.email}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Specialization: ${doctor.specialization}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Registration Number: ${doctor.regNumber}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Address: ${doctor.address}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Telephone: ${doctor.telephone}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Active Times:',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var activeTime in doctor.activeTimes)
                            Text(
                              '- ${activeTime.getTime()} (max: ${activeTime.getMax()})',

                              style: TextStyle(fontSize: 16),
                            ),

                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}



Future<Doctormodel> fetchDoctor() async {
  final response = await http.get(Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/admin/one/640cde46fef7c4f7550c4480'));

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Doctormodel(
      name: json['name'],
      email: json['email'],
      specialization: json['specialization'],
      regNumber: json['regNumber'],
      address: json['address'],
      telephone: json['telephone'],
      activeTimes: List<ActiveTime>.from(json['activeTimes'].map((x) => ActiveTime(time: x['time'], max: x['max']))),
    );
  } else {
    throw Exception('Failed to fetch doctor');
  }
}


