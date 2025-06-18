import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'AdminBereich/AdminStartseite.dart';
import 'package:flutter2/auth/session_manager.dart';

class SignInAsAdminPage extends StatefulWidget {
  const SignInAsAdminPage({super.key});

  @override
  State<SignInAsAdminPage> createState() => _SignInAsAdminPageState();
}

class _SignInAsAdminPageState extends State<SignInAsAdminPage> {
  static final _logger = Logger('SignInAsAdminPage');
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _signIn() async {
    _logger.info('Versuche Admin anzumelden');
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      _logger.warning('Formular ungültig');
      return;
    }

    try {
      final hashedPassword = _hashPassword(password);
      _logger.info('Überprüfe Zugangsdaten für $email');
      final response = await supabase
          .from('Admin')
          .select()
          .eq('email', email)
          .eq('password', hashedPassword)
          .maybeSingle();

      if (response != null) {
        _logger.info('Admin erfolgreich angemeldet: ${response['name']}');
        SessionManager.currentAdminId = response['id_admin'] ?? response['id'] ?? '';

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anmeldung erfolgreich')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminStartseite()),
          );
        }
      }
      else {
        _logger.warning('Ungültige Zugangsdaten für Admin $email');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ungültige Zugangsdaten')),
          );
        }
      }
    } catch (e) {
      _logger.severe('Fehler bei der Anmeldung', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _logger.fine('Dispose SignInAsAdminPage Controller');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Baue SignInAsAdminPage auf');
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
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-Mail'),
                        validator: (value) =>
                        value == null || value.trim().isEmpty ? 'E-Mail erforderlich' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Passwort'),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Passwort erforderlich' : null,
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
