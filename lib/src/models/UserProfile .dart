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
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      name: json['name'],
      role: json['role'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'role': role,
      'fullName': fullName,
    };
  }
}
