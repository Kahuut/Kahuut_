import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import 'package:flutter2/auth/session_manager.dart';
import 'topics.dart';
import 'start_the_game.dart';

class AdminStartseite extends StatefulWidget {
  const AdminStartseite({super.key});

  @override
  State<AdminStartseite> createState() => _AdminStartseiteState();
}

class _AdminStartseiteState extends State<AdminStartseite> {
  static final _logger = Logger('AdminStartseite');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;
  String activePage = 'Settings';

  @override
  void initState() {
    super.initState();
    _logger.info('AdminStartseite initialisiert');
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final adminId = SessionManager.currentAdminId;
    _logger.info('Lade Admin-Daten für ID: $adminId');

    if (adminId == null) {
      _logger.warning('Keine Admin-ID verfügbar');
      return;
    }

    try {
      final response = await supabase
          .from('Admin')
          .select()
          .eq('id_admin', adminId)
          .maybeSingle();

      if (response != null) {
        _logger.info('Admin-Daten erfolgreich geladen');
        setState(() {
          _nameController.text = response['name'] ?? '';
          _emailController.text = response['email'] ?? '';
        });
      } else {
        _logger.warning('Keine Admin-Daten gefunden für ID $adminId');
      }
    } catch (e) {
      _logger.severe('Fehler beim Laden der Admin-Daten', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden der Daten: $e')),
        );
      }
    }
  }

  Future<void> _saveAdminData() async {
    final adminId = SessionManager.currentAdminId;

    if (adminId == null) {
      _logger.warning('Keine Admin-ID vorhanden');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fehler: Keine Admin-ID verfügbar')),
        );
      }
      return;
    }

    _logger.info('Speichere Admin-Daten');
    try {
      final updates = {
        'name': _nameController.text,
        'email': _emailController.text,
      };

      if (_passwordController.text.isNotEmpty) {
        _logger.info('Passwortänderung erkannt');
        updates['password'] = _passwordController.text;
      }

      await supabase
          .from('Admin')
          .update(updates)
          .eq('id_admin', adminId);

      _logger.info('Admin-Daten erfolgreich aktualisiert');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Änderungen gespeichert')),
        );
      }
    } catch (e) {
      _logger.severe('Fehler beim Speichern', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Speichern: $e')),
        );
      }
    }
  }

  Widget _buildMenuButton(String label, IconData icon, VoidCallback onPressed) {
    final isActive = activePage == label;
    return InkWell(
      onTap: () {
        setState(() => activePage = label);
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        color: isActive ? Colors.grey.shade600 : Colors.grey.shade300,
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
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
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Icon(Icons.admin_panel_settings, size: 80),
                const SizedBox(height: 20),
                _buildMenuButton('Topics', Icons.topic, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const TopicsPage()),
                  );
                }),
                _buildMenuButton('Start the game', Icons.play_arrow, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const StartTheGamePage()),
                  );
                }),
                _buildMenuButton('Settings', Icons.settings, () {}),
                const Spacer(),
                _buildMenuButton('Log out', Icons.logout, () {
                  SessionManager.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MyApp()),
                  );
                }),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              color: const Color(0xFFEFF8FF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Einstellungen',
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
                          onPressed: _saveAdminData,
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
