class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final int ecoScore;
  final double totalCarbonSaved;
  final double monthlyCarbonBudget;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    required this.ecoScore,
    required this.totalCarbonSaved,
    required this.monthlyCarbonBudget,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      ecoScore: json['ecoScore'] ?? 100,
      totalCarbonSaved: (json['totalCarbonSaved'] ?? 0).toDouble(),
      monthlyCarbonBudget: (json['monthlyCarbonBudget'] ?? 100).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}

class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: User.fromJson(json['user']),
    );
  }
}
