import 'package:flutter/material.dart';
import 'AdminBereich/AdminStartseite.dart';

class SignInAsAdminPage extends StatefulWidget {
  const SignInAsAdminPage({super.key});

  @override
  State<SignInAsAdminPage> createState() => _SignInAsAdminPageState();
}

class _SignInAsAdminPageState extends State<SignInAsAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      if (username == 'a' &&
          email == 'a' &&
          password == 'a') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin erfolgreich angemeldet')),
        );

        // ✅ Weiterleitung zur AdminStartseite nach erfolgreicher Anmeldung
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminStartseite()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültige Admin-Daten')),
        );
      }
    }  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      appBar: AppBar(
        title: const Text('Admin Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Benutzername'),
                        validator: (value) => value!.isEmpty ? 'Bitte Benutzername eingeben' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-Mail'),
                        validator: (value) => value!.isEmpty ? 'Bitte E-Mail eingeben' : null,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Passwort'),
                        obscureText: true,
                        validator: (value) => value!.length < 1 ? 'Mindestens 1 Zeichen' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signIn,
                        child: const Text('Anmelden'),
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
