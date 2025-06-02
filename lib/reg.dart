import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Hier kannst du die Daten weiterverarbeiten oder speichern
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrierung erfolgreich!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrierung')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Benutzername'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte Benutzernamen eingeben';
                  }
                  return null;
                },
                onSaved: (value) => username = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Bitte eine gültige E-Mail eingeben';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Passwort muss mindestens 6 Zeichen lang sein';
                  }
                  return null;
                },
                onSaved: (value) => password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrieren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
