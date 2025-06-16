import 'package:flutter/material.dart';
import 'package:flutter2/pages/UserBereich/UserStartseite.dart'; // Stelle sicher, dass dieser Pfad korrekt ist

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

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrierung erfolgreich')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserStartseite()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openMicrosoftLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MicrosoftLoginPage()),
    );
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
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
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
                        decoration:
                        const InputDecoration(labelText: 'Passwort'),
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
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _openMicrosoftLogin,
                        icon: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/4/44/Microsoft_logo.svg',
                          height: 20,
                          width: 20,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.login),
                        ),
                        label: const Text('Mit Microsoft anmelden'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue[800],
                          side: BorderSide(color: Colors.blue.shade800),
                          minimumSize: const Size.fromHeight(45),
                        ),
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

// Neues Microsoft Login Fenster (Platzhalter)
class MicrosoftLoginPage extends StatelessWidget {
  const MicrosoftLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microsoft Anmeldung'),
        backgroundColor: Colors.blue[800],
      ),
      body: const Center(
        child: Text(
          'Hier kommt später das Microsoft Login',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
