// lib/models/UserProfile.dart

class UserProfile {
  final String userId;
  final String name;
  final String role;
  final String fullName; // Add this field

  UserProfile({
    required this.userId,
    required this.name,
    required this.role,
    required this.fullName,
  });
}
