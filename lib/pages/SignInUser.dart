import 'package:flutter/material.dart';

class SignInAsUserPage extends StatefulWidget {
  const SignInAsUserPage({super.key});

  @override
  State<SignInAsUserPage> createState() => _SignInAsUserPageState();
}

class _SignInAsUserPageState extends State<SignInAsUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      if (username == 'testuser1' &&
          email == 'testuser1@gmail.com' &&
          password == '123456') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erfolgreich angemeldet')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültige Anmeldedaten')),
        );
      }
    }
  }

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
      appBar: AppBar(title: const Text("Sign In as User")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Benutzername'),
                validator: (value) =>
                value!.isEmpty ? 'Bitte Benutzername eingeben' : null,
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
                onPressed: _signIn,
                child: const Text('Anmelden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
