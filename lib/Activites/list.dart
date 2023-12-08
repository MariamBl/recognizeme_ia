import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activite').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No activities found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var activity = snapshot.data!.docs[index];
              var titre = activity['titre'];
              var lieu = activity['lieu'];
              var prix = activity['prix'];
              var nombreMinimum = activity['nombreMinimum'];
              var categorie = activity['categorie'];
              var imageUrl = activity['imageUrl'];

              return Card(
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl)
                      : Icon(Icons.image),
                  title: Text(titre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lieu: $lieu'),
                      Text('Prix: $prix'),
                      Text('Nombre minimum: $nombreMinimum'),
                      Text('Catégorie: $categorie'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}