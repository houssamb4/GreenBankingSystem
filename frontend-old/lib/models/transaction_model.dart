class Transaction {
  final String id;
  final double amount;
  final String currency;
  final String category;
  final String? merchant;
  final String? description;
  final double carbonFootprint;
  final DateTime transactionDate;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.category,
    this.merchant,
    this.description,
    required this.carbonFootprint,
    required this.transactionDate,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      category: json['category'],
      merchant: json['merchant'],
      description: json['description'],
      carbonFootprint: (json['carbonFootprint'] ?? 0).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class CarbonStats {
  final String userId;
  final double totalCarbon;
  final double monthlyCarbon;
  final double carbonBudget;
  final double carbonPercentage;
  final int ecoScore;

  CarbonStats({
    required this.userId,
    required this.totalCarbon,
    required this.monthlyCarbon,
    required this.carbonBudget,
    required this.carbonPercentage,
    required this.ecoScore,
  });

  factory CarbonStats.fromJson(Map<String, dynamic> json) {
    return CarbonStats(
      userId: json['userId'],
      totalCarbon: (json['totalCarbon'] ?? 0).toDouble(),
      monthlyCarbon: (json['monthlyCarbon'] ?? 0).toDouble(),
      carbonBudget: (json['carbonBudget'] ?? 100).toDouble(),
      carbonPercentage: (json['carbonPercentage'] ?? 0).toDouble(),
      ecoScore: json['ecoScore'] ?? 100,
    );
  }
}

class CategoryBreakdown {
  final String category;
  final double totalCarbon;
  final double totalAmount;
  final int transactionCount;
  final double percentage;

  CategoryBreakdown({
    required this.category,
    required this.totalCarbon,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentage,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      category: json['category'],
      totalCarbon: (json['totalCarbon'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      transactionCount: json['transactionCount'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}
