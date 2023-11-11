import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:heliverse/jsonDetails/jsonDetails.dart';
import 'package:heliverse/select_team.dart';
import 'package:heliverse/team_list.dart';
import 'filter_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<JsonDetails>? allUsers;
  TextEditingController searchController = TextEditingController();
  String? search = "";
  List<JsonDetails> selectedTeamMembers = [];

  bool showAvailable = true;
  bool showNotAvailable = true;
  bool showMale = true;
  bool showFemale = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final items = await readJsonData();
          // ignore: use_build_context_synchronously
          final selectedMembers = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectTeamMembersPage(allUsers: items),
            ),
          );

          if (selectedMembers != null) {
            setState(() {
              selectedTeamMembers = List.from(selectedMembers);
            });
          }
        },
      ),
      appBar: AppBar(
        elevation: 20,
        title: const Text(
          "Heliverse",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Add a button to navigate to the Team List Page
          IconButton(
            icon: Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TeamListPage(teamMembers: selectedTeamMembers),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              left: 8.0,
              right: 8.0,
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search for name",
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                print(value);
                setState(() {
                  search = value.toString();
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: const Text('Available'),
                  selected: showAvailable,
                  onSelected: (bool value) {
                    setState(() {
                      showAvailable = value;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Not Available'),
                  selected: showNotAvailable,
                  onSelected: (bool value) {
                    setState(() {
                      showNotAvailable = value;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Male'),
                  selected: showMale,
                  onSelected: (bool value) {
                    setState(() {
                      showMale = value;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Female'),
                  selected: showFemale,
                  onSelected: (bool value) {
                    setState(() {
                      showFemale = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: readJsonData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  var items = snapshot.data as List<JsonDetails>;
                  items = items.where((item) {
                    bool isAvailable = item.available == true && showAvailable;
                    bool isNotAvailable =
                        item.available == false && showNotAvailable;
                    bool isMale = item.gender == "Male" && showMale;
                    bool isFemale = item.gender == "Female" && showFemale;

                    return isAvailable || isNotAvailable || isMale || isFemale;
                  }).toList();
                  if (searchController.text.isNotEmpty) {
                    items = items
                        .where((item) => item.first_name
                            .toString()
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: Image(
                            image: NetworkImage(items[index].avatar.toString()),
                            fit: BoxFit.fill,
                          ),
                          title: Text("${items[index].first_name}"),
                          subtitle: items[index].available == true
                              ? const Text("Available")
                              : const Text("Not Available"),
                          onTap: () {
                            setState(() {
                              if (selectedTeamMembers.contains(items[index])) {
                                selectedTeamMembers.remove(items[index]);
                              } else {
                                selectedTeamMembers.add(items[index]);
                              }
                            });
                          },
                        ),
                      );
                    },
                    itemCount: 10,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<JsonDetails>> readJsonData() async {
    final jsondata = await rootBundle.rootBundle
        .loadString('jsonFile/heliverse_mock_data.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => JsonDetails.fromJson(e)).toList();
  }
}
