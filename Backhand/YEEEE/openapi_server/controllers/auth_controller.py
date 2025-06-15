import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter2/pages/UserBereich/UserStartseite.dart'; // Pfad ggf. anpassen

class SignUpAsUserPage extends StatefulWidget {
  const SignUpAsUserPage({super.key});

  @override
  State<SignUpAsUserPage> createState() => _SignUpAsUserPageState();
}

class _SignUpAsUserPageState extends State<SignUpAsUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  static const String apiUrl = "http://10.0.2.2:8080/UserRegister"; // Bei Android Emulator

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": _nameController.text.trim(),
            "email": _emailController.text.trim(),
            "password": _passwordController.text,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Registrierung erfolgreich')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserStartseite()),
          );
        } else {
          _showErrorDialog(responseData['message'] ?? 'Fehler bei der Registrierung');
        }
      } catch (e) {
        _showErrorDialog('Verbindungsfehler: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Registrierung fehlgeschlagen"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Sign Up as User',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Bitte Namen eingeben' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-Mail',
                          hintText: 'z. B. name@example.com',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte E-Mail eingeben';
                          }
                          final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Bitte gültige E-Mail eingeben';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Passwort'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte Passwort eingeben';
                          }
                          if (value.length < 6) {
                            return 'Mindestens 6 Zeichen';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _register,
                        child: const Text('Registrieren'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
