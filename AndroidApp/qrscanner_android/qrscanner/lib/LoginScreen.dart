import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'LandingPage.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Function to handle login with API
  Future<void> _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showAlert(
          "Invalid Credentials", "Please input both username and password.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://localhost:9819/api/Login/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Assume API returns a token and theme preference
        String token = data['token'];
        bool isDark = data['isDarkTheme'] ? false : true;

        // Save token and set the theme
        // ignore: use_build_context_synchronously
        Provider.of<ThemeProvider>(context, listen: false).setTheme(isDark);

        // Fetch user info
        await _fetchUserInfo(token);

        // Navigate to Landing Page
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
        );
      } else {
        _showAlert("Login Failed", "Invalid username or password.");
      }
    } catch (e) {
      _showAlert("Error", "An error occurred. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch user-specific info using the retrieved token
  Future<void> _fetchUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse("https://localhost:9819/api/Login/user-info"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final userInfo = json.decode(response.body);

        // ignore: avoid_print
        print("User Info: $userInfo");
        // You can store or display this data in the UI as needed
      } else {
        // ignore: avoid_print
        print("Failed to fetch user info");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user info: $e");
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height * 0.4,
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text("Login"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
