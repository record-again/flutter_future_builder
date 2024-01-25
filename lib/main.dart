import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  // const HomePage({super.key});

  List<Map<String, dynamic>> allUsers = [];

  Future getUsers() async {
    try {
      var response = await http.get(Uri.parse('https://reqres.in/api/users'));
      List data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
      data.forEach((element) {
        allUsers.add(element);
      });
      // print(response.body);
    } catch (e) {
      print('Error!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Future Builder"),
        ),
        body: FutureBuilder(
            future: getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("LOADING..."),
                );
              } else {
                return ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black54,
                      backgroundImage: NetworkImage(allUsers[index]['avatar']),
                    ),
                    title: Text("${allUsers[index]['first_name']}"),
                    subtitle: Text("${allUsers[index]['email']}"),
                  ),
                );
              }
            }));
  }
}
