import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Function(bool, bool, bool, bool) onFilterChanged;

  const FilterDialog({Key? key, required this.onFilterChanged}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool showAvailable = true;
  bool showNotAvailable = true;
  bool showMale = true;
  bool showFemale = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filter Options"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: Text("Available"),
            value: showAvailable,
            onChanged: (value) {
              setState(() {
                showAvailable = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Not Available"),
            value: showNotAvailable,
            onChanged: (value) {
              setState(() {
                showNotAvailable = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Male"),
            value: showMale,
            onChanged: (value) {
              setState(() {
                showMale = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Female"),
            value: showFemale,
            onChanged: (value) {
              setState(() {
                showFemale = value ?? false;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
        TextButton(
          onPressed: () {
            widget.onFilterChanged(showAvailable, showNotAvailable, showMale, showFemale);
            Navigator.of(context).pop();
          },
          child: Text("Submit"),
        ),
      ],
    );
  }
}
