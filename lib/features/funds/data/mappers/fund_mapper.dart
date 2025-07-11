import '../../domain/models/fund.dart';


class FundMapper {
  static Fund fromJson(Map<String, dynamic> json) {
    return Fund(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      minInvestment: (json['minInvestment'] ?? 0.0).toDouble(),
      annualReturn: (json['annualReturn'] ?? 0.0).toDouble(),
      risk: json['risk'] ?? '',
      category: json['category'] ?? '',
      manager: json['manager'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? '',
      currency: json['currency'] ?? '',
      managementFee: (json['managementFee'] ?? 0.0).toDouble(),
      performance: (json['performance'] ?? 0.0).toDouble(),
      returnRates: json['returnRates'] != null 
        ? FundReturn.fromJson(json['returnRates']) 
        : FundReturn(),
    );
  }

  static Map<String, dynamic> toJson(Fund fund) {
    return {
      'id': fund.id,
      'name': fund.name,
      'description': fund.description,
      'minInvestment': fund.minInvestment,
      'annualReturn': fund.annualReturn,
      'risk': fund.risk,
      'category': fund.category,
      'manager': fund.manager,
      'createdAt': fund.createdAt.toIso8601String(),
      'imageUrl': fund.imageUrl,
      'type': fund.type,
      'currency': fund.currency,
      'managementFee': fund.managementFee,
      'performance': fund.performance,
      'returnRates': fund.returnRates.toJson(),
    };
  }

  static List<Fund> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
