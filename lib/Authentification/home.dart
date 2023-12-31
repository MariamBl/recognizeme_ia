import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recognizeme_ia/Activites/Create.dart';
import 'package:recognizeme_ia/Activites/details.dart';
import 'package:recognizeme_ia/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String selectedCategory = 'all';

  String _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void _logout() async {
    await _auth.signOut();
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.home, // Add the home icon
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterByCategory('all'),
                child: Text('All'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterByCategory('shopping'),
                child: Text('Shopping'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterByCategory('sport'),
                child: Text('Sport'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('activite')
                  .where('uid', isEqualTo: _getCurrentUserId())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var activities = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .where((activity) {
                  var category = activity['categorie'].trim() ?? '';
                  return selectedCategory == 'all' || category == selectedCategory;
                }).toList();

                return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  children: activities.map((activity) {
                    var imageUrl = activity['image'] ?? '';
                    var category = activity['categorie'] ?? '';

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.all(20),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailsScreen(activity),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 120,
                                      color: Colors.grey,
                                    ),
                            ),
                            ListTile(
                              title: Text(activity['titre'] ?? ''),
                              subtitle: Text(activity['lieu'] ?? ''),
                              trailing: Text("\$${activity['prix'] ?? ''}"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateActivityScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfile()),
            );
          }
        },
      ),
    );
  }
}
