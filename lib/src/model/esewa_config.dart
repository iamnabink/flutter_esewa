part of esewa_flutter;

/// eSewa configuration for v2 form integration
class ESewaConfig {
  /// Live mode configuration
  ESewaConfig.live({
    required this.amount,
    this.taxAmount = 0,
    this.productServiceCharge = 0,
    this.productDeliveryCharge = 0,
    double? totalAmount,
    this.serverUrl = 'https://epay.esewa.com.np/api/epay/main/v2/form',
    required this.productCode,
    this.transactionUuid,
    required this.successUrl,
    required this.failureUrl,
    this.signedFieldNames = 'total_amount,transaction_uuid,product_code',
    required this.secretKey,
  }) : totalAmount = totalAmount ??
            amount +
                (productDeliveryCharge ?? 0.0) +
                (productServiceCharge ?? 0.0) +
                (taxAmount ?? 0.0);

  /// Dev/RC mode configuration
  ESewaConfig.dev({
    required this.amount,
    this.taxAmount = 0,
    this.productServiceCharge = 0,
    this.productDeliveryCharge = 0,
    double? totalAmount,
    this.serverUrl = 'https://rc-epay.esewa.com.np/api/epay/main/v2/form',
    this.productCode = 'EPAYTEST',
    this.transactionUuid,
    required this.successUrl,
    required this.failureUrl,
    this.signedFieldNames = 'total_amount,transaction_uuid,product_code',
    required this.secretKey,
  }) : totalAmount = totalAmount ??
            amount +
                (productDeliveryCharge ?? 0.0) +
                (productServiceCharge ?? 0.0) +
                (taxAmount ?? 0.0);

  /// Total payment amount including tax, service and delivery charge.
  double? totalAmount;

  /// API form endpoint URL
  String serverUrl;

  /// Amount of product or item
  double amount;

  /// Tax amount on product or item
  double? taxAmount;

  /// Service charge by merchant
  double? productServiceCharge;

  /// Delivery charge by merchant
  double? productDeliveryCharge;

  /// Merchant product code (was scd)
  String productCode;

  /// Success redirect URL
  String successUrl;

  /// Failure redirect URL
  String failureUrl;

  /// Unique transaction UUID
  String? transactionUuid;

  /// Comma separated field names to sign
  String signedFieldNames;

  /// Secret key used to generate signature
  String secretKey;
}
