import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class PatientRecordForm extends StatefulWidget {
  @override
  _PatientRecordFormState createState() => _PatientRecordFormState();
}

class _PatientRecordFormState extends State<PatientRecordForm> {
  final _formKey = GlobalKey<FormState>();

  String? diseaseReason, prescriptions, treatmentPlan, progressNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Record Forum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Reason for Disease'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter reason for disease';
                  }
                  return null;
                },
                onSaved: (value) {
                  diseaseReason = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prescriptions'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter prescriptions';
                  }
                  return null;
                },
                onSaved: (value) {
                  prescriptions = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Treatment Plan'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter treatment plan';
                  }
                  return null;
                },
                onSaved: (value) {
                  treatmentPlan = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Progress Notes'),
                maxLines: null,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter progress notes';
                  }
                  return null;
                },
                onSaved: (value) {
                  progressNotes = value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Make Record'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    savePatientRecord(diseaseReason!, prescriptions!,
                        treatmentPlan!, progressNotes!);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> savePatientRecord(String diseaseReason, String prescriptions,
    String treatmentPlan, String progressNotes) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('patientId', '640c74622d6f86d2d09bfca5');
  prefs.setString('appointmentId', '640ce9b2be639302db5347c6');

  // final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString('uid') ?? '';
  final patientId = prefs.getString('patientId');
  final appointmentId = prefs.getString('appointmentId') ?? '';
  final token = prefs.getString('token') ?? '';
  final role = prefs.getString('role') ?? '';

  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/report/create');

  print('Appointment ID: $appointmentId');
  print('Patient ID: $patientId');
  print('Doctor ID: $uid');
  print('Disease Reason: $diseaseReason');
  print('Prescriptions: $prescriptions');
  print('Treatment Plan: $treatmentPlan');
  print('Progress Notes: $progressNotes');
  print('token: $token');
  print('token: $role');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    },
    body: json.encode({
      'appointmentUid': appointmentId,
      'patientUid': patientId,
      'doctorUid': uid,
      'diseaseReason': diseaseReason,
      'prescriptions': prescriptions,
      'treatmentPlan': treatmentPlan,
      'progressNotes': progressNotes,
    }),
  );

  if (response.statusCode == 200) {
    print('Record saved successfully');
    // show success message
  } else {
    print('Failed to create user account.');
  }
}
