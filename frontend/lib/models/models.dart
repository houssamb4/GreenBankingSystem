// Models for Green Banking System

enum Category {
  transport,
  food,
  shopping,
  utilities,
  entertainment,
  health,
  travel,
  other,
}

enum PaymentMethod { creditCard, transfer, cash }

class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final String currency;
  final String merchant;
  final Category category;
  final PaymentMethod paymentMethod;
  final double estimatedCO2grams;
  final String details;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.currency,
    required this.merchant,
    required this.category,
    required this.paymentMethod,
    required this.estimatedCO2grams,
    this.details = '',
    required this.createdAt,
  });

  double get estimatedCO2kg => estimatedCO2grams / 1000;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String? ?? '',
      date: DateTime.parse(
        json['date'] as String? ?? DateTime.now().toIso8601String(),
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EUR',
      merchant: json['merchant'] as String? ?? '',
      category: Category.values[json['categoryIndex'] as int? ?? 0],
      paymentMethod:
          PaymentMethod.values[json['paymentMethodIndex'] as int? ?? 0],
      estimatedCO2grams: (json['estimatedCO2grams'] as num?)?.toDouble() ?? 0,
      details: json['details'] as String? ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'amount': amount,
    'currency': currency,
    'merchant': merchant,
    'categoryIndex': category.index,
    'paymentMethodIndex': paymentMethod.index,
    'estimatedCO2grams': estimatedCO2grams,
    'details': details,
    'createdAt': createdAt.toIso8601String(),
  };
}

class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String preferredCurrency;
  final String carbonUnit;
  final bool isAdmin;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.preferredCurrency = 'EUR',
    this.carbonUnit = 'kg',
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
      preferredCurrency: json['preferredCurrency'] as String? ?? 'EUR',
      carbonUnit: json['carbonUnit'] as String? ?? 'kg',
      isAdmin: json['isAdmin'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
    'preferredCurrency': preferredCurrency,
    'carbonUnit': carbonUnit,
    'isAdmin': isAdmin,
  };
}

class MonthlyReport {
  final double totalCO2kg;
  final int transactionCount;
  final double averageCO2PerTransaction;
  final Map<String, double> co2ByDay;
  final Map<Category, double> co2ByCategory;
  final DateTime month;

  MonthlyReport({
    required this.totalCO2kg,
    required this.transactionCount,
    required this.averageCO2PerTransaction,
    required this.co2ByDay,
    required this.co2ByCategory,
    required this.month,
  });

  factory MonthlyReport.fromJson(Map<String, dynamic> json) {
    return MonthlyReport(
      totalCO2kg: (json['totalCO2kg'] as num?)?.toDouble() ?? 0,
      transactionCount: json['transactionCount'] as int? ?? 0,
      averageCO2PerTransaction:
          (json['averageCO2PerTransaction'] as num?)?.toDouble() ?? 0,
      co2ByDay: Map<String, double>.from(
        (json['co2ByDay'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ) ??
            {},
      ),
      co2ByCategory: Map<Category, double>.from(
        (json['co2ByCategory'] as Map?)?.entries.fold<Map<Category, double>>(
              {},
              (acc, entry) {
                final catIndex = int.tryParse(entry.key.toString()) ?? 0;
                acc[Category.values[catIndex]] = (entry.value as num)
                    .toDouble();
                return acc;
              },
            ) ??
            {},
      ),
      month: DateTime.parse(
        json['month'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class EmissionFactor {
  final String id;
  final Category category;
  final double factorValue;
  final String unit;
  final String description;

  EmissionFactor({
    required this.id,
    required this.category,
    required this.factorValue,
    required this.unit,
    required this.description,
  });
}

class CarbonEstimate {
  final double grams;
  final double emissionFactor;
  final String factorUnit;
  final String formula;
  final String explanation;

  CarbonEstimate({
    required this.grams,
    required this.emissionFactor,
    required this.factorUnit,
    required this.formula,
    required this.explanation,
  });
}
