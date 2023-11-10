import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:heliverse/jsonDetails/jsonDetails.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<JsonDetails>? allUsers;
  bool showAvailable = true;
  TextEditingController searchContrller = TextEditingController();
  String? search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
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
                  top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
              child: TextField(
                controller: searchContrller,
                decoration: const InputDecoration(
                    hintText: "Search for name", border: OutlineInputBorder()),
                onChanged: (String? value) {
                  print(value);
                  setState(() {
                    search = value.toString();
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: readJsonData(),
                builder: (context, snapshot) {
                  if (searchContrller.text.isEmpty && snapshot.hasData) {
                    var items = snapshot.data as List<JsonDetails>;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: Image(
                              image:
                                  NetworkImage(items[index].avatar.toString()),
                              fit: BoxFit.fill,
                            ),
                            title: Text("${items[index].first_name}"),
                            subtitle: items[index].available == true
                                ? const Text("Available")
                                : const Text("Not Available"),
                          ),
                        );
                      },
                      itemCount: 10,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    var items = snapshot.data as List<JsonDetails>;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        String name = items[index].first_name.toString().toLowerCase();
                        if(name.toLowerCase().contains(searchContrller.text.toLowerCase())){
                          return Card(
                          margin: const EdgeInsets.all(5.0),
                          child: ListTile(
                            leading: Image(
                              image:
                                  NetworkImage(items[index].avatar.toString()),
                              fit: BoxFit.fill,
                            ),
                            title: Text("${items[index].first_name}"),
                            subtitle: items[index].available == true
                                ? const Text("Available")
                                : const Text("Not Available"),
                          ),
                        );
                        }
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
        ));
  }

  // ignore: non_constant_identifier_names
  // Card UserCard(List<JsonDetails> items, int index) {
  //   return Card(
  //     elevation: 5,
  //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //     child: Container(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             width: 50,
  //             height: 50,
  //             child: Image(
  //               image: NetworkImage(items[index].avatar.toString()),
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               padding: const EdgeInsets.only(bottom: 8),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 8, right: 8),
  //                     child: Text("${items[index].first_name}"),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void showFilterOptions(BuildContext context) {
  //   final List<PopupMenuEntry<bool>> filterOptions = [
  //     const PopupMenuItem<bool>(
  //       value: true,
  //       child: Text('Available'),
  //     ),
  //     const PopupMenuItem<bool>(
  //       value: false,
  //       child: Text('Not Available'),
  //     ),
  //   ];

  //   showMenu(
  //     context: context,
  //     position: const RelativeRect.fromLTRB(50, 50, 50, 50),
  //     items: filterOptions,
  //     elevation: 8.0,
  //   ).then((value) {
  //     if (value != null) {
  //       setState(() {
  //         showAvailable = value;
  //       });
  //     }
  //   });
  // }

  // List<JsonDetails> filterUsers() {
  //   if (showAvailable) {
  //     return allUsers!.where((user) => user.available!).toList();
  //   } else {
  //     return allUsers!;
  //   }
  // }

  Future<List<JsonDetails>> readJsonData() async {
    final jsondata = await rootBundle.rootBundle
        .loadString('jsonFile/heliverse_mock_data.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => JsonDetails.fromJson(e)).toList();
  }
}
