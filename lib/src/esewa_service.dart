part of esewa_flutter;

class _EsewaService {
  _EsewaService._(); // private constructor for singletons
  /// return the same instance of PaymentService
  static _EsewaService i = _EsewaService._();

  Future<EsewaPaymentResult> init(
      {required BuildContext context, required ESewaConfig eSewaConfig}) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WalletPage(eSewaConfig)),
      );
      return result;
    } catch (e) {
      return EsewaPaymentResult(error: 'Payment Failed or Cancelled!');
    }
  }
}

class Esewa {
  Esewa._(); // private constructor for singletons
  /// return the same instance of eSewa
  static Esewa instance = Esewa._();

  /// you can use PaymentService.instance or eSewa.i
  static Esewa get i => instance;

  final _EsewaService _payment = _EsewaService.i;

  /// return a new instance of eSewa for testing
  @visibleForTesting
  static Esewa getInstance() => Esewa._();

  /// like webview, native app, or a dialog.
  Future<EsewaPaymentResult> init({
    required BuildContext context,
    required ESewaConfig eSewaConfig,
  }) =>
      _payment.init(
        context: context,
        eSewaConfig: eSewaConfig,
      );
}
