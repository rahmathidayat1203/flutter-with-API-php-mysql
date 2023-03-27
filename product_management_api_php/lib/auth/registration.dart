import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_management_api_php/auth/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final picker = ImagePicker();
  File? _imageFile;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future register() async {
    final apiUrl =
        'http://192.168.43.94/api-product-management/registeration.php';
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['nama'] = namaController.text;
    request.fields['email'] = emailController.text;
    request.fields['password'] = passwordController.text;
    request.files
        .add(await http.MultipartFile.fromPath('gambar', _imageFile!.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const SingleChildScrollView(
                child: Text("Success Login"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: const Text("Ok"))
              ],
            );
          });
    } else {
      print('Image upload failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REGISTRATION"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(50),
        children: [
          Form(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "NAME"),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Password"),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                ElevatedButton.icon(
                  onPressed: () {
                    register();
                  },
                  icon: Icon(Icons.login),
                  label: Text("Register"),
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
          )
        ],
      ),
    );
  }
}
