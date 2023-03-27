import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../auth/login.dart';
import '../dashboard/dashboard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40.0),
        scrollDirection: Axis.vertical,
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(300.0),
                    child: Lottie.asset("assets/home.json", width: 450.0),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 253, 174, 71),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            icon: const Icon(Icons.input_sharp),
            label: const Text("Masuk"),
          )
        ],
      ),
    );
  }
}
