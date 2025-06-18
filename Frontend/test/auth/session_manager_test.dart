import 'package:flutter_test/flutter_test.dart';
import 'package:flutter2/auth/session_manager.dart';

void main() {
  group('SessionManager Tests', () {
    // Reset SessionManager before each test
    setUp(() {
      SessionManager.clear();
    });

    test('Should start with null values', () {
      expect(SessionManager.currentUserId, isNull);
      expect(SessionManager.currentAdminId, isNull);
    });

    test('Should store user ID', () {
      const testUserId = 'test-user-123';
      SessionManager.currentUserId = testUserId;
      
      expect(SessionManager.currentUserId, equals(testUserId));
      expect(SessionManager.currentAdminId, isNull);
    });

    test('Should store admin ID', () {
      const testAdminId = 'test-admin-456';
      SessionManager.currentAdminId = testAdminId;
      
      expect(SessionManager.currentAdminId, equals(testAdminId));
      expect(SessionManager.currentUserId, isNull);
    });

    test('Should store both user and admin IDs independently', () {
      const testUserId = 'test-user-123';
      const testAdminId = 'test-admin-456';
      
      SessionManager.currentUserId = testUserId;
      SessionManager.currentAdminId = testAdminId;
      
      expect(SessionManager.currentUserId, equals(testUserId));
      expect(SessionManager.currentAdminId, equals(testAdminId));
    });

    test('Should clear all session data', () {
      // Set some test data
      SessionManager.currentUserId = 'test-user-123';
      SessionManager.currentAdminId = 'test-admin-456';
      
      // Clear the session
      SessionManager.clear();
      
      // Verify everything is cleared
      expect(SessionManager.currentUserId, isNull);
      expect(SessionManager.currentAdminId, isNull);
    });

    test('Should allow setting null values', () {
      // Set initial values
      SessionManager.currentUserId = 'test-user-123';
      SessionManager.currentAdminId = 'test-admin-456';
      
      // Set individual fields to null
      SessionManager.currentUserId = null;
      expect(SessionManager.currentUserId, isNull);
      expect(SessionManager.currentAdminId, equals('test-admin-456'));
      
      SessionManager.currentAdminId = null;
      expect(SessionManager.currentUserId, isNull);
      expect(SessionManager.currentAdminId, isNull);
    });

    test('Should handle empty string values', () {
      SessionManager.currentUserId = '';
      SessionManager.currentAdminId = '';
      
      expect(SessionManager.currentUserId, equals(''));
      expect(SessionManager.currentAdminId, equals(''));
    });

    test('Should overwrite existing values', () {
      // Set initial values
      SessionManager.currentUserId = 'initial-user';
      SessionManager.currentAdminId = 'initial-admin';
      
      // Overwrite with new values
      SessionManager.currentUserId = 'new-user';
      SessionManager.currentAdminId = 'new-admin';
      
      expect(SessionManager.currentUserId, equals('new-user'));
      expect(SessionManager.currentAdminId, equals('new-admin'));
    });
  });
}
