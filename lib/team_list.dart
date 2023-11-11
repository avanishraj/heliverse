import 'package:flutter/material.dart';
import 'package:heliverse/jsonDetails/jsonDetails.dart';

class TeamListPage extends StatelessWidget {
  final List<JsonDetails> teamMembers;
  final List<String> list = [];

   TeamListPage({Key? key, required this.teamMembers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Team"),
      ),
      body: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(teamMembers[index].first_name.toString()),
          );
        },
      ),
    );
  }
}
