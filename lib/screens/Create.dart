import 'dart:io';

import 'package:database/services/user-services.dart';
import 'package:flutter/material.dart';
import 'package:database/model/database_model.dart';
import 'package:image_picker/image_picker.dart';

class Detailspage extends StatefulWidget {
  const Detailspage({super.key});

  @override
  State<Detailspage> createState() => _DetailspageState();
}

class _DetailspageState extends State<Detailspage> {
  final _formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final studyController = TextEditingController();
  final admissionController = TextEditingController();
  final addressController = TextEditingController();

  var userService = UserService();
  File? imagepath;
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Details page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add new user',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: IconButton(
                          onPressed: () {
                            pickImageFromGallery();
                          },
                          icon: Icon(Icons.camera_alt_outlined)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //   Container(
                  //  width: 100,
                  //  height: 100,
                  //  decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     fit:BoxFit.cover,
                  //   image: imagepath != null),
                  //  ),
                  //   ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your full name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name Is Required';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: studyController,
                    decoration: const InputDecoration(
                      labelText: 'Class',
                      hintText: 'Enter your class',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'class Is Required';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: admissionController,
                    decoration: const InputDecoration(
                      labelText: 'Admission number',
                      hintText: 'Enter your Admission number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Admission number Is Required';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'address',
                      hintText: 'Enter your address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'address Is Required';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.lightBlue)),
                        onPressed: () async {
                          saveDetails();
                        },
                        child: const Text(
                          'Save Data',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () {
                          forclear();
                        },
                        child: const Text(
                          'Clear Data',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      imagepath = File(returnedImage.path);
      selectedImage = returnedImage.path.toString();
    });
  }

  void saveDetails() async {
    if (_formkey.currentState!.validate() && selectedImage != null) {
      var user = User();
      user.name = nameController.text;
      user.study = studyController.text;
      user.admission = admissionController.text;
      user.address = addressController.text;
      user.selectedImage = selectedImage;
      var result = await userService.SaveUser(user);
      Navigator.pop(context, result);
    }
    // if (selectedImage == null) {}
  }

  void forclear() {
    nameController.text = '';
    studyController.text = '';
    admissionController.text = '';
    addressController.text = '';
  }
}
