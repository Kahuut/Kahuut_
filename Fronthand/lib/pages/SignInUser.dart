import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'UserBereich/home.dart'; // Zielseite bei erfolgreichem Login
import 'package:http/http.dart' as http;

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

  final supabase = Supabase.instance.client;

  Future<void> _signIn() async {
    const String apiUrl = "http://127.0.0.1:8080/Login";
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        final response = await supabase
            .from('User') // 🔁 <-- Tabellenname prüfen
            .select()
            .eq('name', username)
            .eq('email', email)
            .eq('password', password) // ⚠️ Nur zu Lernzwecken unverschlüsselt
            .maybeSingle();

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erfolgreich angemeldet')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ungültige Anmeldedaten')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $error')),
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
            ],
          ),
        ),
      ),
    );
  }
}
