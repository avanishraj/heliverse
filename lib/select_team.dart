import 'package:flutter/material.dart';
import 'package:heliverse/jsonDetails/jsonDetails.dart';

class SelectTeamMembersPage extends StatefulWidget {
  final List<JsonDetails> allUsers;

  const SelectTeamMembersPage({Key? key, required this.allUsers}) : super(key: key);

  @override
  _SelectTeamMembersPageState createState() => _SelectTeamMembersPageState();
}

class _SelectTeamMembersPageState extends State<SelectTeamMembersPage> {
  late List<JsonDetails> selectedMembers;

  @override
  void initState() {
    super.initState();
    // Initialize selectedMembers with a copy of allUsers
    selectedMembers = List.from(widget.allUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Team Members"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final List<JsonDetails> result = selectedMembers
                  .where((member) => member.isSelected ?? false)
                  .toList();
              Navigator.pop(context, result);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(selectedMembers[index].first_name.toString()),
              onTap: () {
                setState(() {
                  selectedMembers[index].isSelected =
                      !(selectedMembers[index].isSelected ?? false);
                });
              },
              trailing: Icon(
                selectedMembers[index].isSelected ?? false
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
            ),
          );
        },
        itemCount: selectedMembers.length,
      ),
    );
  }
}
