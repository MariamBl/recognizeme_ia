import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late User? _user;
  late TextEditingController _anniversaireController;
  late TextEditingController _adresseController;
  late TextEditingController _codePostalController;
  late TextEditingController _villeController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _anniversaireController = TextEditingController();
    _adresseController = TextEditingController();
    _codePostalController = TextEditingController();
    _villeController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fetchUserData();
  }

  void _fetchUserData() {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user!.uid;

      FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _anniversaireController.text = data['anniversaire'] ?? '';
            _adresseController.text = data['adresse'] ?? '';
            _codePostalController.text = data['codePostal'] ?? '';
            _villeController.text = data['ville'] ?? '';
            _emailController.text = _user!.email ?? '';
          });
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _anniversaireController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildDataInput(IconData icon, String label, TextEditingController controller, String placeholder, {bool isNumeric = false, bool isDate = false, bool isPassword = false}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.indigo),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.indigo, width: 2.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              onTap: isDate ? () => _selectDate(context) : null,
              readOnly: isDate,
              obscureText: isPassword,
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserData() {
    if (_user != null) {
      String userId = _user!.uid;

      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'anniversaire': _anniversaireController.text,
        'adresse': _adresseController.text,
        'codePostal': _codePostalController.text,
        'ville': _villeController.text,
        'email': _user!.email,
      }, SetOptions(merge: true)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data updated successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user data')),
        );
      });
    }
  }

  Future<void> _changePassword() async {
    if (_passwordController.text.isNotEmpty) {
      try {
        await _user!.updatePassword(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password')),
        );
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Mon Profil', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDataInput(Icons.email, 'Email', _emailController, 'Enter your email'),
              _buildDataInput(Icons.lock, 'Password', _passwordController, 'Enter your new password', isPassword: true),
              _buildDataInput(Icons.cake_rounded, 'Anniversaire', _anniversaireController, 'Select your birthday', isDate: true),
              _buildDataInput(Icons.house, 'Adresse', _adresseController, 'Enter your address'),
              _buildDataInput(Icons.local_post_office, 'Code postal', _codePostalController, 'Enter your postal code', isNumeric: true),
              _buildDataInput(Icons.location_city, 'Ville', _villeController, 'Enter your city'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateUserData();
          _changePassword();
        },
        child: Icon(Icons.save, color: Colors.white),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
