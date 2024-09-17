import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dahsbord.dart';
class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password.';
      });
    } else {
      // Clear any previous error message
      setState(() {
        _errorMessage = null;
      });
      loginAdmin(email, password);
    }
  }

Future<void> loginAdmin(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/auth/admin/login'), // Nouvelle URL pour la connexion admin
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final tokens = jsonDecode(response.body);
      String accessToken = tokens['accessToken'];
      String refreshToken = tokens['refreshToken'];
      String role = tokens['role'];  // Capture the role from the response

      if (role == 'ADMIN' || role == 'EMPLOYEE') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('role', role);

        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()), // Assurez-vous que cette page est appropriée pour l'admin
        );
      } else {
        setState(() {
          _errorMessage = 'Unauthorized role. Only ADMIN or EMPLOYEE can log in.';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid credentials. Please try again.';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'An error occurred. Please try again later.';
    });
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 800, // Adjust width as needed
                height: 100, // Adjust height as needed
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo.png'),
                    fit: BoxFit.cover, // Adjust fit as needed
                  ),
                  borderRadius: BorderRadius.circular(10), // Optional
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _login,
                child: Text('Login'),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
