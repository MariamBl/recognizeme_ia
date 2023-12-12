import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String? _login;
  String? _password;
  DateTime? _birthday;
  String? _address;
  int? _postalCode;
  String? _city;

  void _saveDataToFirebase() {
    if (_login != null &&
        _password != null &&
        _birthday != null &&
        _address != null &&
        _postalCode != null &&
        _city != null) {
      // Assuming Firebase authentication is set up
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Assuming you have a 'users' collection in Firestore
        _firestore.collection('users').doc(user.uid).set({
          'login': _login,
          'password': _password,
          'birthday': _birthday,
          'address': _address,
          'postalCode': _postalCode,
          'city': _city,
        }).then((value) {
          // Data saved successfully
          // You can add any further actions after saving the data
          print('Data saved to Firebase!');
        }).catchError((error) {
          // Handle error while saving data to Firebase
          print('Failed to save data: $error');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Login'),
              readOnly: true,
              onChanged: (value) {
                setState(() {
                  _login = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Birthday'),
              readOnly: true, // You can use a DatePicker here
              controller: _birthdayController,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _birthday = pickedDate;
                    _birthdayController.text =
                        pickedDate.toString(); // Format the date as needed
                  });
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              onChanged: (value) {
                setState(() {
                  _address = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Postal Code',
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              maxLength: 5,
              onChanged: (value) {
                setState(() {
                  _postalCode = int.tryParse(value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'City'),
              onChanged: (value) {
                setState(() {
                  _city = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveDataToFirebase,
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
