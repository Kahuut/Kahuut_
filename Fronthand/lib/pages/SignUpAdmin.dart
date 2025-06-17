import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'AdminBereich/AdminStartseite.dart';

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

  final supabase = Supabase.instance.client;

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        // Admin mit gleichem Namen oder E-Mail prüfen
        final existingAdmin = await supabase
            .from('Admin')
            .select()
            .or('name.eq.$name,email.eq.$email')
            .maybeSingle();

        if (existingAdmin != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Benutzername oder E-Mail existiert bereits')),
          );
          return;
        }

        // In Datenbank einfügen
        await supabase.from('Admin').insert({
          'name': name,
          'email': email,
          'password': password, // Hinweis: Nur zu Lernzwecken im Klartext!
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin erfolgreich registriert')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminStartseite()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei der Registrierung: $error')),
        );
      }
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
      backgroundColor: const Color(0xFFEFF8FF),
      appBar: AppBar(
        title: const Text('Admin Registrierung'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
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
                    decoration: const InputDecoration(labelText: 'Benutzername'),
                    validator: (value) =>
                    value!.isEmpty ? 'Bitte Benutzernamen eingeben' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte E-Mail eingeben';
                      }
                      final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Ungültige E-Mail-Adresse';
                      }
                      return null;
                    },
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
        ),
      ),
    );
  }
}
