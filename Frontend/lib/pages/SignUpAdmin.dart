import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'AdminBereich/AdminStartseite.dart';
import 'package:flutter2/auth/session_manager.dart';

class SignUpAsAdminPage extends StatefulWidget {
  const SignUpAsAdminPage({super.key});

  @override
  State<SignUpAsAdminPage> createState() => _SignUpAsAdminPageState();
}

class _SignUpAsAdminPageState extends State<SignUpAsAdminPage> {
  static final _logger = Logger('SignUpAsAdminPage');
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _register() async {
    _logger.info('Starting admin registration process');
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) return;

    try {
      _logger.info('Checking if admin exists with name: $name or email: $email');
      final existingAdmin = await supabase
          .from('Admin')
          .select()
          .or('name.eq.$name,email.eq.$email')
          .maybeSingle();

      if (existingAdmin != null) {
        _logger.warning('Admin already exists with name or email');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Benutzername oder E-Mail existiert bereits')),
        );
        return;
      }

      final hashedPassword = _hashPassword(password);

      _logger.info('Inserting new admin');
      final inserted = await supabase.from('Admin').insert({
        'name': name,
        'email': email,
        'password': hashedPassword,
      }).select().single();

      if (inserted != null && inserted['id'] != null) {
        SessionManager.currentAdminId = inserted['id'].toString();
        _logger.info('Admin registered successfully with ID: ${SessionManager.currentAdminId}');
      } else {
        _logger.warning('Failed to retrieve new admin ID');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrierung erfolgreich')),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminStartseite()),
        );
      }
    } catch (e, stacktrace) {
      _logger.severe('Error during admin registration', e, stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler bei der Registrierung: $e')),
      );
    }
  }

  @override
  void dispose() {
    _logger.fine('Disposing SignUpAsAdminPage controllers');
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building SignUpAsAdminPage');
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Registrierung')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Benutzername'),
                    validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Benutzername erforderlich' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'E-Mail erforderlich';
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      return emailRegex.hasMatch(value) ? null : 'Ungültige E-Mail';
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Passwort'),
                    obscureText: true,
                    validator: (value) =>
                    value == null || value.length < 6 ? 'Mind. 6 Zeichen' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _register, child: const Text('Registrieren')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
