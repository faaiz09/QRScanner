import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.red,
        title: const Text("Landing Page"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.sunny : Icons.nightlight_round,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to the Landing Page!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
