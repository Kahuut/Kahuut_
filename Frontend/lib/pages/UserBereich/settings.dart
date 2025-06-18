import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'package:flutter2/auth/session_manager.dart';
import 'sidebar.dart';
import 'home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static final _logger = Logger('SettingsPage');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _logger.info('Initializing SettingsPage');
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = SessionManager.currentUserId;
    _logger.info('Loading user data for ID: $userId');

    if (userId == null) {
      _logger.warning('No user ID available');
      return;
    }

    try {
      _logger.fine('Fetching user data from database');
      final response = await supabase
          .from('User')
          .select()
          .eq('id_user', userId)
          .maybeSingle();

      _logger.fine('User data response received');

      if (response != null) {
        _logger.info('Successfully loaded user data');
        setState(() {
          _nameController.text = response['name'] ?? '';
          _emailController.text = response['email'] ?? '';
        });
      } else {
        _logger.warning('No user data found for ID: $userId');
      }
    } catch (e) {
      _logger.severe('Error loading user data', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden: $e')),
      );
    }
  }

  Future<void> _saveChanges() async {
    final userId = SessionManager.currentUserId;
    if (userId == null) {
      _logger.warning('Attempting to save changes without user ID');
      return;
    }

    _logger.info('Saving user profile changes');
    try {
      final updates = {
        'name': _nameController.text,
        'email': _emailController.text,
      };

      if (_passwordController.text.isNotEmpty) {
        _logger.info('Password change detected');
        updates['password'] = _passwordController.text;
      }

      _logger.fine('Updating user data in database');
      await supabase
          .from('User')
          .update(updates)
          .eq('id_user', userId);

      _logger.info('User profile successfully updated');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Änderungen gespeichert')),
      );
    } catch (e) {
      _logger.severe('Error saving user data', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Speichern: $e')),
      );
    }
  }

  @override
  void dispose() {
    _logger.fine('Disposing SettingsPage controllers');
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Building SettingsPage');
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(activePage: 'Profil'),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              color: const Color(0xFFEFF8FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.account_circle, size: 40, color: Colors.black54),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Benutzereinstellungen',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'E-Mail'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Passwort ändern'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveChanges,
                          child: const Text('Speichern'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
