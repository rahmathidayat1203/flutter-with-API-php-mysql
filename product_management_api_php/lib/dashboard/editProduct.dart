import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as dev;

import 'package:product_management_api_php/dashboard/dashboard.dart';

class EditProducts extends StatefulWidget {
  const EditProducts(
      {super.key,
      required this.id,
      required this.nama_product,
      required this.quantity_product,
      required this.price_product,
      required this.image});

  final String id;
  final String nama_product;
  final String image;
  final int quantity_product;
  final int price_product;

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final picker = ImagePicker();
  File? _imageFile;
  @override
  Widget build(BuildContext context) {
    TextEditingController namaController = TextEditingController(
      text: widget.nama_product.toString(),
    );
    TextEditingController quantityController = TextEditingController(
      text: widget.quantity_product.toString(),
    );
    TextEditingController priceController = TextEditingController(
      text: widget.price_product.toString(),
    );

    Future getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    }

    Future update() async {
      final apiUrl =
          'http://192.168.43.94/api-product-management/editProducts.php';
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['id'] = widget.id;
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

    print(widget.id);

    final AppBar MyAppbar = AppBar(
      title: const Text("EDIT DATA"),
      automaticallyImplyLeading: false,
      centerTitle: true,
    );
    return Scaffold(
      appBar: MyAppbar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: "Name Products"),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: "Quantity Products"),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: "Price Products",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text("Kembali")),
                  Padding(padding: EdgeInsets.only(right: 10.0)),
                  ElevatedButton.icon(
                    onPressed: () {
                      update();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Success"),
                              content: const SingleChildScrollView(
                                child: Text("Success Edit Data"),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dashboard()));
                                    },
                                    child: const Text("Ok"))
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.update),
                    label: const Text("UPDATE"),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  getImage();
                },
                icon: Icon(Icons.picture_in_picture),
                label: Text("Choose Images"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                          "http://192.168.43.94/api-product-management/gambar/${widget.image.replaceAll(' ', '')}")),
                  Padding(padding: EdgeInsets.all(20.0)),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Text(
                            'Update Image',
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
