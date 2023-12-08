import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({Key? key});

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  TextEditingController titreController = TextEditingController();
  TextEditingController lieuController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController nombreMinimumController = TextEditingController();
  TextEditingController categorieController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Activity"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             TextField(
              controller: titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),

            SizedBox(height: 20),
              TextField(
              controller: lieuController,
              decoration: InputDecoration(labelText: 'Lieu'),
            ),

            SizedBox(height: 20),
           TextField(
              controller: prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),
            TextField(
              controller: nombreMinimumController,
              decoration: InputDecoration(labelText: 'Nombre minimum'),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),
             TextField(
              controller: categorieController,
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),

            SizedBox(height: 20),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'URL de l\'image'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var titre = titreController.text.trim();
                var lieu = lieuController.text.trim();
                var prix = prixController.text.trim();
                var nombreMinimum = nombreMinimumController.text.trim();
                var categorie = categorieController.text.trim();
                var imageUrl = imageUrlController.text.trim();

                if (titre.isNotEmpty &&
                    lieu.isNotEmpty &&
                    prix.isNotEmpty &&
                    nombreMinimum.isNotEmpty &&
                    categorie.isNotEmpty &&
                    imageUrl.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection("activite")
                        .doc()
                        .set({
                      "createAt": DateTime.now(),
                      "titre": titre,
                      "lieu": lieu,
                      "prix": prix,
                      "nombreMinimum": nombreMinimum,
                      "categorie": categorie,
                      "imageUrl": imageUrl,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Activity added successfully!"),
                      ),
                    );

                    titreController.clear();
                    lieuController.clear();
                    prixController.clear();
                    nombreMinimumController.clear();
                    categorieController.clear();
                    imageUrlController.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error adding activity: $e"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill all fields."),
                    ),
                  );
                }
              },
              child: Text("Add Activity"),
            ),
          ],
        ),
      ),
    );
  }
}