import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'UserBereich/home.dart'; // Zielseite bei erfolgreichem Login
import 'package:flutter2/auth/session_manager.dart'; // <-- anpassen an deinen Pfad

class SignInAsUserPage extends StatefulWidget {
  const SignInAsUserPage({super.key});

  @override
  State<SignInAsUserPage> createState() => _SignInAsUserPageState();
}

class _SignInAsUserPageState extends State<SignInAsUserPage> {
  static final _logger = Logger('SignInAsUserPage');
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> _signIn() async {
    _logger.info('Attempting user sign in');
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        _logger.info('Validating user credentials for email: $email');
        final response = await supabase
            .from('User')
            .select()
            .eq('email', email)
            .eq('password', password) // ⚠️ Nur zu Lernzwecken unverschlüsselt
            .maybeSingle();

        if (response != null) {
          SessionManager.currentUserId = response['id_user'];
          _logger.info('User successfully logged in. User ID: ${SessionManager.currentUserId}');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          _logger.warning('Invalid login credentials for email: $email');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ungültige Anmeldedaten')),
          );
        }
      } catch (error) {
        _logger.severe('Error during login process', error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $error')),
        );
      }
    }
  }

  @override
  void dispose() {
    _logger.fine('Disposing SignInAsUserPage controllers');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building SignInAsUserPage');
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      appBar: AppBar(
        title: const Text('User Login'),
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
                        value!.isEmpty ? 'Bitte E-Mail eingeben' : null,
                      ),
                      const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}
