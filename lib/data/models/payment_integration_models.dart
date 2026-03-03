
import 'package:json_annotation/json_annotation.dart';

// No PART file to avoid build_runner dependency issues in this environment
// Implementing manual fromJson/toJson for immediate stability

/// Response for Get User Subscription (Payway + Local)
class SubscriptionPaywayDetails {
  final PaywaySchedule? paywaySchedule;
  final LocalSubscription? localSubscription;

  SubscriptionPaywayDetails({
    this.paywaySchedule,
    this.localSubscription,
  });

  factory SubscriptionPaywayDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionPaywayDetails(
      paywaySchedule: json['paywaySchedule'] != null
          ? PaywaySchedule.fromJson(json['paywaySchedule'])
          : null,
      localSubscription: json['localSubscription'] != null
          ? LocalSubscription.fromJson(json['localSubscription'])
          : null,
    );
  }
}

class PaywaySchedule {
  final String? frequency;
  final String? nextPaymentDate;
  final int? numberOfPaymentsRemaining;
  final num? nextPaymentAmount;
  final num? regularPaymentAmount;
  final num? finalPaymentAmount;

  PaywaySchedule({
    this.frequency,
    this.nextPaymentDate,
    this.numberOfPaymentsRemaining,
    this.nextPaymentAmount,
    this.regularPaymentAmount,
    this.finalPaymentAmount,
  });

  factory PaywaySchedule.fromJson(Map<String, dynamic> json) {
    return PaywaySchedule(
      frequency: json['frequency'] as String?,
      nextPaymentDate: json['nextPaymentDate'] as String?,
      numberOfPaymentsRemaining: json['numberOfPaymentsRemaining'] as int?,
      nextPaymentAmount: json['nextPaymentAmount'] as num?,
      regularPaymentAmount: json['regularPaymentAmount'] as num?,
      finalPaymentAmount: json['finalPaymentAmount'] as num?,
    );
  }
}

class LocalSubscription {
  final String? id;
  final String? status;
  final String? startDate;
  final String? endDate;

  LocalSubscription({
    this.id,
    this.status,
    this.startDate,
    this.endDate,
  });

  factory LocalSubscription.fromJson(Map<String, dynamic> json) {
    return LocalSubscription(
      id: json['id'] as String?,
      status: json['status'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }
}

/// Response for Get Saved Cards (Payment Customer)
class PaymentCustomerDetails {
  final String? customerNumber;
  final PaymentSetup? paymentSetup;
  final CreditCardDetails? creditCard; // Can be null if in paymentSetup

  PaymentCustomerDetails({
    this.customerNumber,
    this.paymentSetup,
    this.creditCard,
  });

  factory PaymentCustomerDetails.fromJson(Map<String, dynamic> json) {
    return PaymentCustomerDetails(
      customerNumber: json['customerNumber'] as String?,
      paymentSetup: json['paymentSetup'] != null
          ? PaymentSetup.fromJson(json['paymentSetup'])
          : null,
      creditCard: json['creditCard'] != null
          ? CreditCardDetails.fromJson(json['creditCard'])
          : null,
    );
  }
}

class PaymentSetup {
  final String? paymentMethod;
  final bool? stopped;
  final CreditCardDetails? creditCard;
  final MerchantDetails? merchant;

  PaymentSetup({
    this.paymentMethod,
    this.stopped,
    this.creditCard,
    this.merchant,
  });

  factory PaymentSetup.fromJson(Map<String, dynamic> json) {
    return PaymentSetup(
      paymentMethod: json['paymentMethod'] as String?,
      stopped: json['stopped'] as bool?,
      creditCard: json['creditCard'] != null
          ? CreditCardDetails.fromJson(json['creditCard'])
          : null,
      merchant: json['merchant'] != null
          ? MerchantDetails.fromJson(json['merchant'])
          : null,
    );
  }
}

class CreditCardDetails {
  final String? cardNumber; // Often masked
  final String? expiryDateMonth;
  final String? expiryDateYear;
  final String? cardScheme;
  final String? cardType;
  final String? cardholderName;
  final String? panType;

  // Sometimes returned as 'maskedNumber' in save-card response
  final String? maskedNumber;

  CreditCardDetails({
    this.cardNumber,
    this.expiryDateMonth,
    this.expiryDateYear,
    this.cardScheme,
    this.cardType,
    this.cardholderName,
    this.panType,
    this.maskedNumber,
  });

  factory CreditCardDetails.fromJson(Map<String, dynamic> json) {
    return CreditCardDetails(
      cardNumber: json['cardNumber'] as String?,
      expiryDateMonth: json['expiryDateMonth'] as String?,
      expiryDateYear: json['expiryDateYear'] as String?,
      cardScheme: json['cardScheme'] as String?,
      cardType: json['cardType'] as String?,
      cardholderName: json['cardholderName'] as String?,
      panType: json['panType'] as String?,
      maskedNumber: json['maskedNumber'] as String?,
    );
  }
}

class MerchantDetails {
  final String? merchantId;
  final String? merchantName;

  MerchantDetails({
    this.merchantId,
    this.merchantName,
  });

  factory MerchantDetails.fromJson(Map<String, dynamic> json) {
    return MerchantDetails(
      merchantId: json['merchantId'] as String?,
      merchantName: json['merchantName'] as String?,
    );
  }
}

/// Response for Tokenize Card
class SingleUseTokenResponse {
  final String singleUseTokenId;

  SingleUseTokenResponse({required this.singleUseTokenId});

  factory SingleUseTokenResponse.fromJson(Map<String, dynamic> json) {
    return SingleUseTokenResponse(
      singleUseTokenId: json['singleUseTokenId'] as String,
    );
  }
}

/// Response for Save Card
class SaveCardResponse {
  final CreditCardDetails? creditCard;
  final String? message;

  SaveCardResponse({
    this.creditCard,
    this.message,
  });

  factory SaveCardResponse.fromJson(Map<String, dynamic> json) {
    print("SaveCardResponse: $json");
    return SaveCardResponse(
      creditCard: json['creditCard'] != null
          ? CreditCardDetails.fromJson(json['creditCard'])
          : null,
      message: json['message'] as String?,
    );
  }
}
