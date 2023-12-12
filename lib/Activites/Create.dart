import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:tflite/tflite.dart';

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

  File? _imageFile;
  List? _identifieResult;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    loadEmojiModel();
  }

  Future selectImage() async {
    final picker = ImagePicker();
    var image =
        await picker.pickImage(source: ImageSource.gallery, maxHeight: 300);
    identifyImage(image);
  }

  Future loadEmojiModel() async {
    Tflite.close();
    String categorie;
    categorie = (await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    ))!;
    print(categorie);
  }

  Future identifyImage(image) async {
    _identifieResult = null;
    final List? categorie = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        _identifieResult = categorie;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    String fileName = Path.basename(imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  int getCategoryIndex(String category) {
    if (category.toLowerCase() == 'sport') {
      return 1;
    } else if (category.toLowerCase() == 'shopping') {
      return 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Activity"),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titreController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: lieuController,
                  decoration: const InputDecoration(labelText: 'Lieu'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: prixController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nombreMinimumController,
                  decoration: const InputDecoration(labelText: 'Nombre minimum'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Column(
                children: _identifieResult != null &&
                        _identifieResult!.isNotEmpty
                    ? _identifieResult!.map((result) {
                        String label = result["label"]
                            .toString()
                            .replaceAll(RegExp(r'[0-9]'), '');
                        return Text(
                          "Categorie : $label",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      }).toList()
                    : [],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: (_imageFile != null)
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : Image.network(
                      'https://i.imgur.com/sUFH1Aq.png',
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              tooltip: 'Select Image',
              onPressed: () {
                selectImage();
              },
              child: const Icon(
                Icons.add_a_photo,
                size: 25,
                color: Colors.blue,
              ),
              backgroundColor: Colors.white,
              shape: CircleBorder(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var titre = titreController.text.trim();
                var lieu = lieuController.text.trim();
                var prix = prixController.text.trim();
                var nombreMinimum = nombreMinimumController.text.trim();

                if (titre.isNotEmpty &&
                    lieu.isNotEmpty &&
                    prix.isNotEmpty &&
                    nombreMinimum.isNotEmpty) {
                  try {
                    if (_imageFile != null) {
                      _uploadedImageUrl =
                          await uploadImageToFirebase(_imageFile!);
                    }

                    String category = '';
                    if (_identifieResult != null &&
                        _identifieResult!.isNotEmpty) {
                      category = _identifieResult![0]["label"]
                          .toString()
                          .replaceAll(RegExp(r'[0-9]'), '');
                    }

                    await FirebaseFirestore.instance
                        .collection("activite")
                        .doc()
                        .set({
                      "createAt": DateTime.now(),
                      "titre": titre,
                      "lieu": lieu,
                      "prix": prix,
                      "nombreMinimum": nombreMinimum,
                      "image": _uploadedImageUrl,
                      "categorie": category,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Activity added successfully!"),
                      ),
                    );

                    titreController.clear();
                    lieuController.clear();
                    prixController.clear();
                    nombreMinimumController.clear();
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error adding activity: $e"),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Please fill all fields and select an image."),
                    ),
                  );
                }
              },
              child: const Text("Add Activity"),
            ),
          ],
        ),
      ),
    );
  }
}