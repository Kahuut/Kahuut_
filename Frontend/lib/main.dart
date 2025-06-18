import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';
import 'constants.dart';
import 'pages/SignIn.dart';
import 'pages/SignUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('KahuutApp');
  logger.info('Starting Kahuut application...');

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    logger.info('Supabase initialized successfully');
  } catch (e) {
    logger.severe('Failed to initialize Supabase', e);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final logger = Logger('MyApp');
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.fine('Building MyApp widget');
    return MaterialApp(
      title: 'Kahuutt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  static final logger = Logger('HomeScreen');
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logger.fine('Building HomeScreen widget');
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Kahuut!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    logger.info('Navigating to Sign In page');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInPage()),
                    );
                  },
                  child: const Text('Sign in'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    logger.info('Navigating to Sign Up page');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('Sign up', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
