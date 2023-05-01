import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';

class api extends StatefulWidget {
  const api({super.key});

  @override
  State<api> createState() => _apiState();
}

class _apiState extends State<api> {
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            onTap: () => print("CLICKED $index"),
            // leading: ClipRRect(
            //   borderRadius: BorderRadius.circular(100),
            //   child: Image.network(user["picture"]["thumbnail"]),
            // ),
            // // title: Text(user?["name"]["first"] + " " + user?["name"]["last"]),
            // title: Text(user?["name"]["first"]),
            // subtitle: Text(user["email"]),
            title: Text(user.email),
            subtitle: Text(user.name.first),
            tileColor:
                user.gender == "male" ? Colors.blue[200] : Colors.pink[200],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Text(
          "Generate",
          style: TextStyle(fontSize: 11, color: Colors.black),
        ),
        onPressed: fetchUsers,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> fetchUsers() async {
    print("FETCHED USERS");
    final uri = Uri.parse("https://randomuser.me/api/?results=20");
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json["results"] as List<dynamic>;
    setState(() {
      users = results.map((e) {
        final name = Username(
          title: e["name"]["title"],
          first: e["name"]["first"],
          last: e["name"]["last"],
        );
        return User(
          gender: e["gender"],
          email: e["email"],
          cell: e["cell"],
          nat: e["nat"],
          phone: e["phone"],
          name: name,
        );
      }).toList();
    });
    print("COMPLETED");
  }
}
