import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activite').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var activity = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(
                  activity['imageUrl'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(activity['titre']),
                subtitle: Text(activity['lieu']),
                trailing: Text("\$${activity['prix']}"),
                onTap: () {
                  // Handle tapping on an activity to view details if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
