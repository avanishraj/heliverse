import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:heliverse/jsonDetails/jsonDetails.dart';
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

  bool showAvailable = true;
  bool showNotAvailable = true;
  bool showMale = true;
  bool showFemale = true;

  @override
  Widget build(BuildContext context) {
    void _showFilterDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FilterDialog(
            onFilterChanged: (bool available, bool notAvailable, bool male, bool female) {
              setState(() {
                showAvailable = available;
                showNotAvailable = notAvailable;
                showMale = male;
                showFemale = female;
              });
            },
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showFilterDialog();
        },
      ),
      appBar: AppBar(
        elevation: 20,
        title: const Text(
          "Heliverse",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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

                  // Apply filters
                  items = items.where((item) {
                    bool isAvailable = item.available == true && showAvailable;
                    bool isNotAvailable = item.available == false && showNotAvailable;
                    bool isMale = item.gender == "Male" && showMale;
                    bool isFemale = item.gender == "Female" && showFemale;

                    return isAvailable || isNotAvailable || isMale || isFemale;
                  }).toList();

                  // Apply search filter
                  if (searchController.text.isNotEmpty) {
                    items = items.where((item) =>
                        item.first_name.toString().toLowerCase().contains(searchController.text.toLowerCase()))
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
                        ),
                      );
                    },
                    itemCount: items.length,
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





