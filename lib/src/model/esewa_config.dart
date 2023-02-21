part of esewa_flutter;
/// Creates an instance of `ESewaConfig` for live mode
class ESewaConfig {
  ESewaConfig.live({
    required this.amt,
    this.serverUrl = keSewaLiveUrl,
    required this.scd,
    required this.pid,
    required this.su,
    required this.fu,
    this.txAmt = 0,
    this.psc = 0,
    this.pdc = 0,
    double? tAmt,
  }) : tAmt = tAmt ?? amt + (pdc ?? 0.0) + (psc ?? 0.0) + (txAmt ?? 0.0);

  /// Creates an instance of `ESewaConfig` for dev mode
  ESewaConfig.dev({
    required this.amt,
    this.txAmt = 0,
    this.psc = 0,
    this.pdc = 0,
    this.serverUrl = keSewaDevUrl,
    this.scd = keSewaDevMerchantId,
    required this.pid,
    required this.su,
    required this.fu,
    double? tAmt,
  }) : tAmt = tAmt ?? amt + (pdc ?? 0.0) + (psc ?? 0.0) + (txAmt ?? 0.0);

  /// Total payment amount including tax, service and deliver charge. [i.e tAmt = amt + txAmt + psc + tAmt]
  double? tAmt;

  /// live : https://esewa.com.np/epay/main
  /// dev : https://uat.esewa.com.np/epay/main?
  String serverUrl;

  /// Amount of product or item or ticket etc
  double amt;

  /// Tax amount on product or item or ticket etc
  double? txAmt;

  /// Service charge by merchant on product or item or ticket etc
  double? psc;

  /// Delivery charge by merchant on product or item or ticket etc
  double? pdc;

  /// Merchant code provided by eSewa
  String scd;

  /// Success URL: a redirect URL of merchant application where customer will be redirected after SUCCESSFUL transaction
  String su;

  /// Failure URL: a redirect URL of merchant application where customer will be redirected after FAILURE or PENDING transaction
  String fu;

  /// A unique ID of product or item or ticket etc
  String pid;
}
