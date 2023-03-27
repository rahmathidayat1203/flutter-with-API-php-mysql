import 'package:flutter/material.dart';
import 'package:product_management_api_php/dashboard/addProduct.dart';
import 'package:product_management_api_php/home/splashScreen.dart';
import './dashboard/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRODUCT MANAGEMENT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
