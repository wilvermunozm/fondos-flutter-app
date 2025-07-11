class FundReturn {
  final double oneYear;
  final double threeYear;
  final double fiveYear;
  final double tenYear;
  final double ytd;

  const FundReturn({
    this.oneYear = 0.0,
    this.threeYear = 0.0,
    this.fiveYear = 0.0,
    this.tenYear = 0.0,
    this.ytd = 0.0,
  });

  factory FundReturn.fromJson(Map<String, dynamic> json) {
    return FundReturn(
      oneYear: (json['oneYear'] ?? 0.0).toDouble(),
      threeYear: (json['threeYear'] ?? 0.0).toDouble(),
      fiveYear: (json['fiveYear'] ?? 0.0).toDouble(),
      tenYear: (json['tenYear'] ?? 0.0).toDouble(),
      ytd: (json['ytd'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'oneYear': oneYear,
    'threeYear': threeYear,
    'fiveYear': fiveYear,
    'tenYear': tenYear,
    'ytd': ytd,
  };
}

class Fund {
  final String id;
  final String name;
  final String description;
  final double minInvestment;
  final double annualReturn;
  final String risk;
  final String category;
  final String manager;
  final DateTime createdAt;
  final String imageUrl;
  final String type;
  final String currency;
  final double managementFee;
  final double performance;
  final FundReturn returnRates;

  Fund({
    required this.id,
    required this.name,
    required this.description,
    required this.minInvestment,
    required this.annualReturn,
    required this.risk,
    required this.category,
    required this.manager,
    required this.createdAt,
    required this.imageUrl,
    this.type = '',
    this.currency = '',
    this.managementFee = 0.0,
    this.performance = 0.0,
    this.returnRates = const FundReturn(),
  });

  Fund copyWith({
    String? id,
    String? name,
    String? description,
    double? minInvestment,
    double? annualReturn,
    String? risk,
    String? category,
    String? manager,
    DateTime? createdAt,
    String? imageUrl,
    String? type,
    String? currency,
    double? managementFee,
    double? performance,
    FundReturn? returnRates,
  }) {
    return Fund(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      minInvestment: minInvestment ?? this.minInvestment,
      annualReturn: annualReturn ?? this.annualReturn,
      risk: risk ?? this.risk,
      category: category ?? this.category,
      manager: manager ?? this.manager,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      managementFee: managementFee ?? this.managementFee,
      performance: performance ?? this.performance,
      returnRates: returnRates ?? this.returnRates,
    );
  }
}
