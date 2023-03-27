import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:product_management_api_php/auth/registration.dart';

import '../dashboard/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future login() async {
    final apiUrl = 'http://192.168.43.94/api-product-management/login.php';
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields['email'] = emailController.text;
    request.fields['password'] = passwordController.text;
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
                          MaterialPageRoute(builder: (context) => Dashboard()));
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
        title: const Text("LOGIN"),
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter Email"),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter Password"),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                ElevatedButton.icon(
                  onPressed: () {
                    login();
                  },
                  icon: Icon(Icons.login),
                  label: Text("Login"),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Register"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
