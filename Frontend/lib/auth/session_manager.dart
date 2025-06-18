class SessionManager {
  static String? currentUserId;
  static String? currentAdminId;

  static void clear() {
    currentUserId = null;
    currentAdminId = null;
  }
}
