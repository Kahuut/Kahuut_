import 'package:flutter/material.dart';

class SignUpAsAdminPage extends StatefulWidget {
  const SignUpAsAdminPage({super.key});

  @override
  State<SignUpAsAdminPage> createState() => _SignUpAsAdminPageState();
}

class _SignUpAsAdminPageState extends State<SignUpAsAdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin erfolgreich registriert')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up as Admin")),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                decoration: const InputDecoration(labelText: 'E-Mail'),
                validator: (value) =>
                value!.isEmpty ? 'Bitte E-Mail eingeben' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? 'Mindestens 6 Zeichen' : null,
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
    );
  }
}
