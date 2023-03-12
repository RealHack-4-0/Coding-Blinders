import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Appointment {
  final String id;
  final String patientUid;
  final String doctorUid;
  final String date;
  final String time;

  Appointment({
    required this.id,
    required this.patientUid,
    required this.doctorUid,
    required this.date,
    required this.time,
  });
}

Future<List<Appointment>> getAppointments(String doctorUid) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? '';
  final rolei = prefs.getString('role') ?? '';

  final token = prefs.getString('token') ?? '';
  print(token);

  final response = await http.get(
      Uri.parse(
          'https://api.realhack.saliya.ml:9696/api/v1/admin/one/$doctorUid'),
      headers: {
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0MGNkZTQ2ZmVmN2M0Zjc1NTBjNDQ4MCIsInJvbGUiOiJkb2N0b3IiLCJpYXQiOjE2Nzg1NzYxODMsImV4cCI6MTY4MTE2ODE4M30.KiFngcQf6SofXFze_DKj0W03hCpuog81opSuiTOyhsM'
      });
  final appointments = <Appointment>[];
  if (response.statusCode == 200) {
    final jsonList = json.decode(response.body);
    void printMap(Map<String, dynamic> map) {
      for (final key in map.keys) {
        print('$key: ${map[key]}');
      }
    }
  } else {
    throw Exception('Failed to load appointments');
  }
  return appointments;
}

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: getAppointments('640cde46fef7c4f7550c4480'),
      builder:
          (BuildContext context, AsyncSnapshot<List<Appointment>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final appointment = snapshot.data![index];
                return ListTile(
                  title: Text('Appointment ID: ${appointment.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient UID: ${appointment.patientUid}'),
                      Text('Date: ${appointment.date}'),
                      Text('Time: ${appointment.time}'),
                    ],
                  ),
                );
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
