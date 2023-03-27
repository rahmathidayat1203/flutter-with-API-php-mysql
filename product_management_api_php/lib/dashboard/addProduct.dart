import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'dart:developer' as dev;

import 'dashboard.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController namaController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool _isLoading = false;

  final picker = ImagePicker();
  File? _imageFile;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future add() async {
    final apiUrl =
        'http://192.168.43.94/api-product-management/addProducts.php';
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['name_product'] = namaController.text;
    request.fields['quantity_product'] = quantityController.text;
    request.fields['price_product'] = priceController.text;
    request.files
        .add(await http.MultipartFile.fromPath('gambar', _imageFile!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD PRODUCT"),
        centerTitle: true,
      ),
      body: ListView(padding: const EdgeInsets.all(50.0), children: [
        Form(
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration:
                    const InputDecoration(hintText: "Masukkan Nama Product"),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextField(
                controller: quantityController,
                decoration:
                    const InputDecoration(hintText: "Masukkan Quantity"),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: "Masukkan Price"),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              ElevatedButton.icon(
                onPressed: () {
                  add();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content: const SingleChildScrollView(
                            child: Text("Success Input Data"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()));
                                },
                                child: const Text("Ok"))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.login),
                label: const Text("Adding Product"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  getImage();
                },
                icon: Icon(Icons.picture_in_picture),
                label: Text("Choose Images"),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Text(
                        'No image selected',
                        textAlign: TextAlign.center,
                      )
                    : null,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
