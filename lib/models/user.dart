class User {
  final String email;
  final String? password; // Optional for storage, required for auth

  User({required this.email, this.password});

  // Convert to Map for storage (if using Firebase/shared_preferences)
  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  // Create from Map (for storage retrieval)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(email: map['email'], password: map['password']);
  }
}
