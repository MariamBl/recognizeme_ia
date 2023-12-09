import 'package:flutter/material.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> activityDetails;

  ActivityDetailsScreen(this.activityDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              activityDetails['titre'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Lieu: ${activityDetails['lieu']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Prix: \$${activityDetails['prix']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Nombre Minimum: ${activityDetails['nombreMinimum']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Catégorie: ${activityDetails['categorie']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Date de création: ${activityDetails['createAt']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Display the activity image
            activityDetails['image'] != null
                ? Image.network(
                    activityDetails['image'],
                    width: 200, // Adjust the width as needed
                    height: 200, // Adjust the height as needed
                    fit: BoxFit.cover, // Adjust the fit based on your preference
                  )
                : Container(), // Placeholder if no image available
          ],
        ),
      ),
    );
  }
}
