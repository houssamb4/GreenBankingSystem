class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final double ecoScore;
  final double totalCarbonSaved;
  final double monthlyCarbonBudget;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.ecoScore,
    required this.totalCarbonSaved,
    required this.monthlyCarbonBudget,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      ecoScore: (json['ecoScore'] as num?)?.toDouble() ?? 0.0,
      totalCarbonSaved: (json['totalCarbonSaved'] as num?)?.toDouble() ?? 0.0,
      monthlyCarbonBudget:
          (json['monthlyCarbonBudget'] as num?)?.toDouble() ?? 100.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'ecoScore': ecoScore,
      'totalCarbonSaved': totalCarbonSaved,
      'monthlyCarbonBudget': monthlyCarbonBudget,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
}
