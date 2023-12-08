import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recognizeme_ia/Activites/Create.dart';
import 'package:recognizeme_ia/Activites/list.dart';
import 'package:recognizeme_ia/profile.dart';

class Home extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue, // Add color to the AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home page!'),
            // ElevatedButton(
            //   onPressed: _logout,
            //   child: Text('Logout'),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateActivityScreen()),
            );
          }
          // else if (index == 2) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => ActivityListScreen()),
          //   );
          // }
        },
      ),
    );
  }
}

