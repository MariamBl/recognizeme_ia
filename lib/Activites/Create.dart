import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:tflite/tflite.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({Key? key}) : super(key: key);

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<String> _getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  Future loadEmojiModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
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
      }
    });
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    String fileName = Path.basename(imageFile.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    return await taskSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Activity", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(titreController, 'Titre', Icons.title),
            SizedBox(height: 20),
            _buildTextField(lieuController, 'Lieu', Icons.location_on),
            SizedBox(height: 20),
            _buildTextField(prixController, 'Prix', Icons.attach_money, isNumber: true),
            SizedBox(height: 20),
            _buildTextField(nombreMinimumController, 'Nombre Minimum', Icons.format_list_numbered, isNumber: true),
            const SizedBox(height: 20),
            _buildCategoryDisplay(),
            const SizedBox(height: 20),
            _buildImageDisplay(),
            const SizedBox(height: 20),
            _buildSelectImageButton(),
            const SizedBox(height: 20),
            _buildAddActivityButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  Widget _buildCategoryDisplay() {
    return SingleChildScrollView(
      child: Column(
        children: _identifieResult != null && _identifieResult!.isNotEmpty
            ? _identifieResult!.map((result) {
                String label = result["label"].toString().replaceAll(RegExp(r'[0-9]'), '');
                return Text(
                  "Categorie : $label",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w900,
                  ),
                );
              }).toList()
            : [],
      ),
    );
  }

  Widget _buildImageDisplay() {
    return Container(
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
    );
  }

  Widget _buildSelectImageButton() {
    return FloatingActionButton(
      tooltip: 'Select Image',
      onPressed: selectImage,
      child: const Icon(Icons.add_a_photo, size: 25, color: Colors.white),
      backgroundColor: Colors.indigo,
    );
  }

  Widget _buildAddActivityButton() {
    return ElevatedButton(
      onPressed: () {
        if (_validateFields()) {
          _addActivity();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all fields and select an image.")),
          );
        }
      },
      child: const Text("Add Activity", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        primary: Colors.indigo,
      ),
    );
  }

  bool _validateFields() {
    return titreController.text.trim().isNotEmpty &&
           lieuController.text.trim().isNotEmpty &&
           prixController.text.trim().isNotEmpty &&
           nombreMinimumController.text.trim().isNotEmpty &&
           _imageFile != null;
  }

  Future<void> _addActivity() async {
    try {
      String? uploadedImageUrl;
      if (_imageFile != null) {
        uploadedImageUrl = await uploadImageToFirebase(_imageFile!);
      }
      final userId = await _getCurrentUserId();
      String category = '';
      if (_identifieResult != null && _identifieResult!.isNotEmpty) {
        category = _identifieResult![0]["label"].toString().replaceAll(RegExp(r'[0-9]'), '');
      }

      // Create the document and get the document reference
      DocumentReference docRef = await FirebaseFirestore.instance.collection("activite").add({
        "titre": titreController.text.trim(),
        "lieu": lieuController.text.trim(),
        "prix": prixController.text.trim(),
        "nombreMinimum": nombreMinimumController.text.trim(),
        "image": uploadedImageUrl ?? '',
        "categorie": category,
        'uid': userId,
      });

      // Update the document with its own docId
      await docRef.update({"docId": docRef.id});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Activity added successfully!")),
      );

      titreController.clear();
      lieuController.clear();
      prixController.clear();
      nombreMinimumController.clear();
      setState(() {
        _imageFile = null;
        _identifieResult = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding activity: $e")),
      );
    }
  }
}
