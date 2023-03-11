import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _birthday;
  String? _selectedGender,fullname,address,username,telephone,password,gender,formatted_birthday;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  fullname=value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Username';
                  }
                  return null;
                },
                onSaved: (value) {
                  username=value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Address';
                  }
                  return null;
                },
                onSaved: (value) {
                  address=value;
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
                  telephone=value;
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
                  }else if(value.length<8){
                    return 'Password must be 8 Characters Long';
                  }
                  return null;
                },
                onSaved: (value) {
                  password=value;
                },
              ),
              SizedBox(height: 16.0),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _birthday == null
                      ? ''
                      : DateFormat('yyyy-MM-dd').format(_birthday!),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Select Your Birthday';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _birthday = DateTime.parse(value);
                    formatted_birthday= DateFormat('yyyy-MM-dd').format(_birthday!);

                  }
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
                  gender=value;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _birthday = selectedDate;
      });
    }
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      print('Full Name: $fullname');
      print('Username: $username');
      print('Address: $address');
      print('Telephone: $telephone');
      print('Password: $password');

      print('Birthday: $formatted_birthday');
      print('Gender: $gender');


    }
  }
}
