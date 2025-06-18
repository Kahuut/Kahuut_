import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/constants.dart';

void main() {
  group('Constants Tests', () {
    test('supabaseUrl should be valid URL', () {
      expect(supabaseUrl, isNotEmpty);
      expect(supabaseUrl, startsWith('https://'));
      expect(supabaseUrl, endsWith('.supabase.co'));
    });

    test('supabaseAnonKey should be valid JWT format', () {
      expect(supabaseAnonKey, isNotEmpty);
      expect(supabaseAnonKey.split('.').length, equals(3)); // JWT has 3 parts
      expect(supabaseAnonKey, startsWith('eyJ')); // JWT typically starts with this
    });

    test('Constants should not be null', () {
      expect(supabaseUrl, isNotNull);
      expect(supabaseAnonKey, isNotNull);
    });
  });
}
