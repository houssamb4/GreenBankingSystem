class Transaction {
  final String id;
  final double amount;
  final String currency;
  final String category;
  final String merchant;
  final String? description;
  final double carbonFootprint;
  final DateTime transactionDate;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.category,
    required this.merchant,
    this.description,
    required this.carbonFootprint,
    required this.transactionDate,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      category: json['category'] as String,
      merchant: json['merchant'] as String,
      description: json['description'] as String?,
      carbonFootprint: (json['carbonFootprint'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'category': category,
      'merchant': merchant,
      'description': description,
      'carbonFootprint': carbonFootprint,
      'transactionDate': transactionDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class CarbonStats {
  final String userId;
  final double totalCarbon;
  final double monthlyCarbon;
  final double carbonBudget;
  final double carbonPercentage;
  final double ecoScore;

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
      userId: json['userId'] as String,
      totalCarbon: (json['totalCarbon'] as num).toDouble(),
      monthlyCarbon: (json['monthlyCarbon'] as num).toDouble(),
      carbonBudget: (json['carbonBudget'] as num).toDouble(),
      carbonPercentage: (json['carbonPercentage'] as num).toDouble(),
      ecoScore: (json['ecoScore'] as num).toDouble(),
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
      category: json['category'] as String,
      totalCarbon: (json['totalCarbon'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      transactionCount: json['transactionCount'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
