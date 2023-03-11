import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String? _jobField;

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _telephoneNoController = TextEditingController();

  void _submitForm() {
    final username = _usernameController.text;
    final fullName = _fullNameController.text;
    final emailAddress = _emailAddressController.text;
    final regNumber = _regNumberController.text;
    final password = _passwordController.text;
    final address = _addressController.text;
    final telephoneNo = _telephoneNoController.text;

    // Call your function with the collected attributes here
    print('Username: $username');
    print('Full Name: $fullName');
    print('Email Address: $emailAddress');
    print('Reg Number: $regNumber');
    print('Password: $password');
    print('Address: $address');
    print('Telephone No: $telephoneNo');
    print('Job Field: $_jobField');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              TextField(
                controller: _emailAddressController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                ),
              ),
              TextField(
                controller: _regNumberController,
                decoration: InputDecoration(
                  labelText: 'Reg Number',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
              ),
              TextField(
                controller: _telephoneNoController,
                decoration: InputDecoration(
                  labelText: 'Telephone No',
                ),
              ),
              SizedBox(height: 16),
              Text('Job Field:'),
              Row(
                children: [
                  Radio(
                    value: 'Doctor',
                    groupValue: _jobField,
                    onChanged: (value) {
                      setState(() {
                        _jobField = value.toString();
                      });
                    },
                  ),
                  Text('Doctor'),
                  Radio(
                    value: 'Nurse',
                    groupValue: _jobField,
                    onChanged: (value) {
                      setState(() {
                        _jobField = value.toString();
                      });
                    },
                  ),
                  Text('Nurse'),
                  Radio(
                    value: 'Staff',
                    groupValue: _jobField,
                    onChanged: (value) {
                      setState(() {
                        _jobField = value.toString();
                      });
                    },
                  ),
                  Text('Staff'),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
