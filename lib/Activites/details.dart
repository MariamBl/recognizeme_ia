import 'package:flutter/material.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> activityDetails;

  ActivityDetailsScreen(this.activityDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.white, // Change the text color to white
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the icon color to white
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(activityDetails['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                activityDetails['titre'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 15),
            _buildDetailItem(Icons.location_on, 'Lieu', activityDetails['lieu']),
            _buildDetailItem(Icons.attach_money, 'Prix', '\$${activityDetails['prix']}'),
            _buildDetailItem(Icons.group, 'Nombre Minimum', '${activityDetails['nombreMinimum']}'),
            _buildDetailItem(Icons.category, 'Catégorie', activityDetails['categorie']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
