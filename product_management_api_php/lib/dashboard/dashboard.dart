import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_management_api_php/dashboard/addProduct.dart';
import 'editProduct.dart';
import 'dart:developer' as dev;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List _listData = [];
  bool _isLoading = true;

  Future _getData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.43.94/api-product-management/readProducts.php'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listData = data["data"];
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _refreshData() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.94/api-product-management/readProducts.php'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listData = data["data"];
        _isLoading = false;
      });
    }
  }

  Future _DeleteData(final id) async {
    var url = "http://192.168.43.94/api-product-management/deleteProducts.php";
    http.post(Uri.parse(url), body: {"id": id.toString()});
    setState(() {
      _refreshData();
    });
  }

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          ElevatedButton.icon(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text(""))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 218, 161, 3),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProducts(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listData.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Name Product : ${_listData[index]['name_product']}",
                        ),
                        subtitle: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Quantity Product : ${_listData[index]['quantity_product']}",
                                  ),
                                  Text(
                                    "Price Product : ${_listData[index]['price_product']}",
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(left: 80.0)),
                              Image.network(
                                'http://192.168.43.94/api-product-management/gambar/${_listData[index]['product_pictures'].replaceAll(' ', '')}',
                                width: 100.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProducts(
                                id: _listData[index]['id'],
                                nama_product: _listData[index]['name_product'],
                                quantity_product: int.parse(
                                    _listData[index]['quantity_product']),
                                price_product: int.parse(
                                  _listData[index]['price_product'],
                                ),
                                image: _listData[index]['product_pictures'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          _DeleteData(_listData[index]["id"]);
                        },
                        icon: const Icon(Icons.phonelink_erase),
                        label: const Text("Delete"),
                      ),
                    ],
                  ),
                );
              }),
            ),
    );
  }
}
