part of esewa_flutter;

class EsewaPaymentResult {
  /// Creates an [EsewaPaymentResponse] with the given object either [data] or [error] (but not both).
  EsewaPaymentResult({this.error, this.data});

  /// The latest data received by the asynchronous computation.
  ///
  /// If this is non-null, [hasData] will be true.
  ///
  /// If [error] is not null, this will be null. See [hasError].
  ///
  /// If the asynchronous computation has never returned a value, this may be
  ///
  EsewaPaymentResponse? data;

  /// The latest error object received.
  ///
  /// If this is non-null, [hasError] will be true.
  ///
  /// If [data] is not null, this will be null.

  String? error;

  /// Returns whether this modal contains a non-null [data] value.
  ///
  /// This can be false even when the asynchronous computation has completed
  /// successfully, if the computation did not return a non-null value. For
  /// example, a [Future<void>] will complete with the null value even if it
  /// completes successfully.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  ///
  /// This is always true if the asynchronous computation's last result was
  /// failure.
  bool get hasError => error != null;
}
