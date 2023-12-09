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
  TextEditingController categorieController = TextEditingController();

  File? _imageFile;
  List? _identifieResult;
  String? _uploadedImageUrl; // Added variable to store the uploaded image URL

  @override
  void initState() {
    super.initState();
    loadEmojiModel();
  }

  Future selectImage() async {
    final picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery, maxHeight: 300);
    identifyImage(image);
  }

  Future loadEmojiModel() async {
    Tflite.close();
    String result;
    result = (await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    ))!;
    print(result);
  }

  Future identifyImage(image) async {
    _identifieResult = null;
    // Run tensorflowlite image classification model on the image
    print("classification start $image");
    final List? result = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );
    print("classification done");
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        _identifieResult = result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Activity"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(color: Colors.white),
              ),
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
                  SingleChildScrollView(
                    child: Column(
                      children: _identifieResult != null
                          ? [
                              Text(
                                "Categorie : ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Card(
                                elevation: 1.0,
                                // color: Colors.white,
                                child: Container(
                                  // width: 100,
                                  margin: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      "${_identifieResult?[0]["label"]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]
                          : [],
                    ),
                  ),
                  (_imageFile != null)
                      ? Image.file(_imageFile!)
                      : Image.network('https://i.imgur.com/sUFH1Aq.png'),
                  FloatingActionButton(
                    tooltip: 'Select Image',
                    onPressed: () {
                      selectImage();
                    },
                    child: Icon(
                      Icons.add_a_photo,
                      size: 25,
                      color: Colors.blue,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var titre = titreController.text.trim();
                      var lieu = lieuController.text.trim();
                      var prix = prixController.text.trim();
                      var nombreMinimum = nombreMinimumController.text.trim();
                      // var categorie = categorieController.text.trim();

                      if (titre.isNotEmpty &&
                          lieu.isNotEmpty &&
                          prix.isNotEmpty &&
                          nombreMinimum.isNotEmpty
                          // categorie.isNotEmpty
                          ) {
                        try {
                          if (_imageFile != null) {
                            // Upload the image to Firebase Storage
                            _uploadedImageUrl = await uploadImageToFirebase(_imageFile!);
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
                            // "categorie": categorie,
                            "image": _uploadedImageUrl, // Store the uploaded image URL in Firestore
                            "result": _identifieResult,
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
          ],
        ),
      ),
    );
  }
}
