import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  String? imageUrl;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      // Upload the image to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = ref.putFile(imageFile);

      // Get the image URL after upload
      await uploadTask.whenComplete(() async {
        String url = await ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
      }).catchError((onError) {
        print('Error uploading image: $onError');
      });
    }
  }

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
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                height: 100,
                width: 100,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text("Import Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var titre = titreController.text.trim();
                var lieu = lieuController.text.trim();
                var prix = prixController.text.trim();
                var nombreMinimum = nombreMinimumController.text.trim();
                var categorie = categorieController.text.trim();

                if (titre.isNotEmpty &&
                    lieu.isNotEmpty &&
                    prix.isNotEmpty &&
                    nombreMinimum.isNotEmpty &&
                    categorie.isNotEmpty &&
                    imageUrl != null) {
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
                    setState(() {
                      imageUrl = null;
                    });
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
                      content: Text("Please fill all fields and select an image."),
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
