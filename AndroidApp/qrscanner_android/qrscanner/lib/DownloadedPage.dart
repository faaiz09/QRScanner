// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';

class DownloadedPage extends StatefulWidget {
  const DownloadedPage({super.key});

  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
    );
  }
}
