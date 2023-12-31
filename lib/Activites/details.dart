import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> activityDetails;

  ActivityDetailsScreen(this.activityDetails);

  @override
  _ActivityDetailsScreenState createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  late Map<String, dynamic> _activityDetails;

  @override
  void initState() {
    super.initState();
    _activityDetails = widget.activityDetails;
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Activity"),
          content: _EditActivityForm(
            activityDetails: _activityDetails,
            onActivityUpdated: (updatedDetails) {
              setState(() {
                _activityDetails = updatedDetails;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
        ],
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
                  image: NetworkImage(_activityDetails['image'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                _activityDetails['titre'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 15),
            _buildDetailItem(Icons.location_on, 'Lieu', _activityDetails['lieu']),
            _buildDetailItem(Icons.attach_money, 'Prix', '\$${_activityDetails['prix']}'),
            _buildDetailItem(Icons.group, 'Nombre Minimum', '${_activityDetails['nombreMinimum']}'),
            _buildDetailItem(Icons.category, 'Catégorie', _activityDetails['categorie']),
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
          Icon(icon, size: 24, color: Colors.blue),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditActivityForm extends StatefulWidget {
  final Map<String, dynamic> activityDetails;
  final Function(Map<String, dynamic>) onActivityUpdated;

  _EditActivityForm({required this.activityDetails, required this.onActivityUpdated});

  @override
  __EditActivityFormState createState() => __EditActivityFormState();
}

class __EditActivityFormState extends State<_EditActivityForm> {
  late TextEditingController _titreController;
  late TextEditingController _lieuController;
  late TextEditingController _prixController;
  late TextEditingController _nombreMinimumController;
  late TextEditingController _categorieController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.activityDetails['titre']);
    _lieuController = TextEditingController(text: widget.activityDetails['lieu']);
    _prixController = TextEditingController(text: widget.activityDetails['prix'].toString());
    _nombreMinimumController = TextEditingController(text: widget.activityDetails['nombreMinimum'].toString());
    _categorieController = TextEditingController(text: widget.activityDetails['categorie']);
  }

  void _updateActivity() {
    FirebaseFirestore.instance.collection('activite').doc(widget.activityDetails['docId']).update({
      'titre': _titreController.text,
      'lieu': _lieuController.text,
      'prix': _prixController.text,
      'nombreMinimum': _nombreMinimumController.text,
      'categorie': _categorieController.text,
    }).then((_) {
      widget.onActivityUpdated({
        'titre': _titreController.text,
        'lieu': _lieuController.text,
        'prix': _prixController.text,
        'nombreMinimum': _nombreMinimumController.text,
        'categorie': _categorieController.text,
        'image': widget.activityDetails['image'],
        'docId': widget.activityDetails['docId'],
      });
      Navigator.of(context).pop(); // Close the dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: _titreController, decoration: InputDecoration(labelText: 'Title')),
        TextField(controller: _lieuController, decoration: InputDecoration(labelText: 'Location')),
        TextField(controller: _prixController, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
        TextField(controller: _nombreMinimumController, decoration: InputDecoration(labelText: 'Minimum Number'), keyboardType: TextInputType.number),
        TextField(controller: _categorieController, decoration: InputDecoration(labelText: 'Category')),
        ElevatedButton(onPressed: _updateActivity, child: Text('Update')),
      ],
    );
  }
}
