part of esewa_flutter;

class EsewaPayButton extends StatelessWidget {
  /// button width
  final double? width;

  /// button height
  final double? height;

  /// elevated button style
  final ButtonStyle? style;

  /// onSuccess callback, when payment will be succeed this call back will be called with esewa payment response
  final Function(EsewaPaymentResponse) onSuccess;

  /// onFailure callback, when payment will be failed this call back will be called with a fail message
  final Function(String) onFailure;

  /// Esewa Payment Configuration object , required to initialize payment screen
  final ESewaConfig paymentConfig;

  /// button borderRadius
  final double? radius;

  /// optional widget in place of title Text field, if use wants to place a row with esewa icon or different widget
  final Widget? widget;

  /// button title [default] tp Pay with Esewa
  final String? title;

  /// button title's textStyle
  final TextStyle? textStyle;

  const EsewaPayButton({
    Key? key,
    this.radius,
    this.width,
    this.textStyle,
    this.widget,
    this.style,
    this.height,
    required this.paymentConfig,
    required this.onSuccess,
    required this.onFailure,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final result =
              await Esewa.i.init(context: context, eSewaConfig: paymentConfig);
          if (result.hasData) {
            onSuccess(result.data!);
          } else {
            onFailure(result.error!);
          }
        } catch (e) {
          onFailure('An Exception Occurred');
        }
      },
      style: style ??
          ElevatedButton.styleFrom(
            minimumSize: Size(width ?? double.infinity, height ?? 40.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)),
            ),
          ),
      child: widget ?? Text(title ?? 'Pay with Esewa', style: textStyle),
    );
  }
}
