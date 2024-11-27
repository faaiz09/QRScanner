// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, deprecated_member_use, unused_local_variable, unused_element, unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isSidebarOpen = false;
  double sidebarOffset = -250;

  // Toggle Sidebar
  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
      sidebarOffset = isSidebarOpen ? 0 : -250;
    });
  }

  // Open QR Scanner
  void openScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(isSidebarOpen ? Icons.close : Icons.menu),
            onPressed: toggleSidebar,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content area
          Positioned.fill(
            top: 0,
            bottom: 60,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Content goes here.'),
                    SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),

          // Sidebar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: sidebarOffset,
            top: 0,
            bottom: 0,
            child: Container(
              width: 250,
              color: Colors.red,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Home',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('About',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Products',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Settings',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // Footer (Icons)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code),
                    onPressed: openScanner,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
  }

  // When barcode is detected
  void onBarcodeDetected(BarcodeCapture capture) {
    String qrCode = capture.barcodes[0].displayValue ?? '';

    cameraController.stop(); // Stop the scanner after detecting a code
    Navigator.pop(context); // Close the scanner screen

    // Show the QR code in a Snackbar (You can modify this to open URLs or navigate)
    if (qrCode.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FileViewerPage(
              pdfURL: qrCode), // Open the FileViewerPage with URL
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.red,
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect:
            onBarcodeDetected, // Trigger onBarcodeDetected when QR is detected
      ),
    );
  }
}

class FileViewerPage extends StatefulWidget {
  final String pdfURL;
  const FileViewerPage({super.key, required this.pdfURL});

  @override
  _FileViewerPageState createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.pdfURL)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }
}
