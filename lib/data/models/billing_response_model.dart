// No PART file to avoid build_runner dependency issues in this environment
// Implementing manual fromJson/toJson for immediate stability

class BillingResponseData {
  final CurrentSubscriptionModel? currentSubscription;
  final List<PaymentMethodModel>? paymentMethods;
  final List<BillingHistoryModel>? billingHistory;

  BillingResponseData({
    this.currentSubscription,
    this.paymentMethods,
    this.billingHistory,
  });

  factory BillingResponseData.fromJson(Map<String, dynamic> json) {
    return BillingResponseData(
      currentSubscription: json['currentSubscription'] != null
          ? CurrentSubscriptionModel.fromJson(json['currentSubscription'])
          : null,
      paymentMethods: json['paymentMethods'] != null
          ? (json['paymentMethods'] as List)
              .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      billingHistory: json['billingHistory'] != null
          ? (json['billingHistory'] as List)
              .map((e) => BillingHistoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class CurrentSubscriptionModel {
  final String? programName;
  final num? price;
  final String? frequency;
  final String? status;
  final String? renewalDate;
  final String? startDate;

  CurrentSubscriptionModel({
    this.programName,
    this.price,
    this.frequency,
    this.status,
    this.renewalDate,
    this.startDate,
  });

  factory CurrentSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionModel(
      programName: json['programName'] as String?,
      price: json['price'] as num?,
      frequency: json['frequency'] as String?,
      status: json['status'] as String?,
      renewalDate: json['renewalDate'] as String?,
      startDate: json['startDate'] as String?,
    );
  }
}

class PaymentMethodModel {
  final String? brand;
  final String? lastFour;
  final String? expiry;
  final bool? isPrimary;

  PaymentMethodModel({this.brand, this.lastFour, this.expiry, this.isPrimary});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      brand: json['brand'] as String?,
      lastFour: json['lastFour'] as String?,
      expiry: json['expiry'] as String?,
      isPrimary: json['isPrimary'] as bool?,
    );
  }
}

class BillingHistoryModel {
  final String? id;
  final String? description;
  final String? date;
  final num? amount;
  final String? currency;
  final String? status;
  final String? receiptNumber;

  BillingHistoryModel({
    this.id,
    this.description,
    this.date,
    this.amount,
    this.currency,
    this.status,
    this.receiptNumber,
  });

  factory BillingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BillingHistoryModel(
      id: json['id']?.toString(),
      description: json['description'] as String?,
      date: json['date'] as String?,
      amount: json['amount'] as num?,
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      receiptNumber: json['receiptNumber'] as String?,
    );
  }
}
