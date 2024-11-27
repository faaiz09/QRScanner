// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class ScannedQRsPage extends StatelessWidget {
  final List<String> scannedQRs;

  const ScannedQRsPage({super.key, required this.scannedQRs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Scanned QR Codes',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: scannedQRs.isEmpty
          ? Center(
              child: Text(
                'No scanned QR codes yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: scannedQRs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(scannedQRs[index]),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Remove the item from the list
                    scannedQRs.removeAt(index);

                    // Show feedback with a SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('QR Code deleted'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red.withOpacity(0.8),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      title: Text(
                        scannedQRs[index],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Manually trigger deletion on the delete button click
                          scannedQRs.removeAt(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('QR Code deleted'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
