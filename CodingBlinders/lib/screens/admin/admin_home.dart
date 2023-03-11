import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender,
      _selectedOccu = 'staff',
      fullname,
      RegNo,
      email,
      telephone,
      password,
      occupation,
      gender;

  bool _showSpecialisationField = false;
  String? specialisation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Healthcare Professional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Fullname';
                  }
                  return null;
                },
                onSaved: (value) {
                  fullname = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Registration No',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a RegNo';
                  }
                  return null;
                },
                onSaved: (value) {
                  RegNo = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Telephone',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Telephone';
                  }
                  if (value.length != 10) {
                    return 'Telephone number should be exactly 10 digits';
                  }
                  return null;
                },
                onSaved: (value) {
                  telephone = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Password';
                  } else if (value.length < 8) {
                    return 'Password must be 8 Characters Long';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                value: _selectedOccu,
                onChanged: (value) {
                  setState(() {
                    _selectedOccu = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Doctor'),
                    value: 'doctor',
                  ),
                  DropdownMenuItem(
                    child: Text('Nurse'),
                    value: 'nurse',
                  ),
                  DropdownMenuItem(
                    child: Text('Staff'),
                    value: 'staff',
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Select employee Occupation';
                  }
                  return null;
                },
                onSaved: (value) {
                  occupation = value;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Male'),
                    value: 'Male',
                  ),
                  DropdownMenuItem(
                    child: Text('Female'),
                    value: 'Female',
                  ),
                  DropdownMenuItem(
                    child: Text('Other'),
                    value: 'Other',
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Select Your Gender';
                  }
                  return null;
                },
                onSaved: (value) {
                  gender = value;
                },
              ),
              SizedBox(height: 16.0),
              if (_selectedOccu == 'doctor')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Specialisation',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Specialisation';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    specialisation = value;
                  },
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Make an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      print('Full Name: $fullname');
      print('email: $email');
      print('RegNo: $RegNo');
      print('Telephone: $telephone');
      print('Password: $password');
      print('Occupation: $occupation');

      // Call the createUserAccount method with the collected attributes here
      bool accountCreated = await createUserAccount(fullname!, RegNo!, email!,
          telephone!, password!, gender!, occupation!, specialisation!);

      if (accountCreated) {
        // If the account was created successfully, show a success message and navigate to the home screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pushNamed('/home');
      } else {
        // If there was an error creating the account, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

Future<bool> createUserAccount(
    String fullname,
    String RegNo,
    String email,
    String telephone,
    String password,
    String gender,
    String occupation,
    String specialisation) async {
  final url =
      Uri.parse('https://api.realhack.saliya.ml:9696/api/v1/user/create');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': fullname,
      'RegNo': RegNo,
      'email': email,
      'telephone': telephone,
      'password': password,
      'gender': gender,
      'occupation': occupation,
      'specialisation': specialisation
    }),
  );
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print(responseData);
    return true;
  } else {
    print('Failed to create user account.');
    return false;
  }
}
