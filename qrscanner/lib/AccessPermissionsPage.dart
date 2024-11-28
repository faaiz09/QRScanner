// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class AccessPermissionsPage extends StatefulWidget {
  const AccessPermissionsPage({super.key});

  @override
  _AccessPermissionsPageState createState() => _AccessPermissionsPageState();
}

class _AccessPermissionsPageState extends State<AccessPermissionsPage> {
  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;

  String selected = ""; // Declare outside of build() to maintain state

  List restrictionItems = [
    {"id": 0, "value": false, "text": "Edit User Email & Phone"},
    {"id": 1, "value": false, "text": "Support Access"},
    {"id": 2, "value": false, "text": "Export User"},
    {"id": 3, "value": false, "text": "Dashboard"},
    {"id": 4, "value": false, "text": "Organization Switch"},
    {"id": 5, "value": false, "text": "Reports"}
  ];

  List applicableOnItems = [
    {"id": 0, "value": false, "text": "Non-admin users"},
    {"id": 1, "value": false, "text": "Admin users"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // Red background for the AppBar
        title: const Text(
          "Users & Permission",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/landing', (route) => false),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView for scrollable content
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            const Text("Name",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Name",
                labelStyle: const TextStyle(color: Colors.red),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description Field
            const Text("Description",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Description",
                labelStyle: const TextStyle(color: Colors.red),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Applicable On Section
            const Text("Applicable On",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Column(
              children: List.generate(
                applicableOnItems.length,
                (index) => CheckboxListTile(
                  title: Text(
                    applicableOnItems[index]["text"],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  value: applicableOnItems[index]["value"],
                  onChanged: (value) {
                    setState(() {
                      for (var element in applicableOnItems) {
                        element["value"] = false;
                      }
                      applicableOnItems[index]["value"] = value;
                      selected =
                          "${applicableOnItems[index]["id"]},${applicableOnItems[index]["text"]},${applicableOnItems[index]["value"]}";
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Restricted Access Section
            const Text("Restricted Access",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Column(
              children: List.generate(
                restrictionItems.length,
                (index) => CheckboxListTile(
                  title: Text(
                    restrictionItems[index]["text"],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  value: restrictionItems[index]["value"],
                  onChanged: (value) {
                    setState(() {
                      restrictionItems[index]["value"] = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Permissions Table
            const Text("Permissions Table",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 8),
            DataTable(
              columns: const [
                DataColumn(
                    label: Text("Assign Permissions",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red))),
                DataColumn(
                    label: Text("View",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red))),
                DataColumn(
                    label: Text("Share",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red))),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text("Admins")),
                  DataCell(
                    Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                  ),
                  DataCell(
                    Checkbox(
                        value: isChecked1,
                        onChanged: (value) {
                          setState(() {
                            isChecked1 = value!;
                          });
                        }),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text("Users")),
                  DataCell(
                    Checkbox(
                        value: isChecked2,
                        onChanged: (value) {
                          setState(() {
                            isChecked2 = value!;
                          });
                        }),
                  ),
                  DataCell(
                    Checkbox(
                        value: isChecked3,
                        onChanged: (value) {
                          setState(() {
                            isChecked3 = value!;
                          });
                        }),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text("Guests")),
                  DataCell(
                    Checkbox(
                        value: isChecked4,
                        onChanged: (value) {
                          setState(() {
                            isChecked4 = value!;
                          });
                        }),
                  ),
                  DataCell(
                    Checkbox(
                        value: isChecked5,
                        onChanged: (value) {
                          setState(() {
                            isChecked5 = value!;
                          });
                        }),
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
